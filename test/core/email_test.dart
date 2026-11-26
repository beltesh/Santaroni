import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/date_symbol_data_local.dart';
import 'package:santaroni/core/email/builtin_templates.dart';
import 'package:santaroni/core/email/css_inliner.dart';
import 'package:santaroni/core/email/email_context.dart';
import 'package:santaroni/core/email/email_renderer.dart';
import 'package:santaroni/core/email/html_to_text.dart';
import 'package:santaroni/core/email/template_kind.dart';
import 'package:santaroni/core/model/wishlist_entry.dart';

/// Narrow no-break space: CLDR puts it before AM/PM.
const nnbsp = ' ';

RenderedEmail render(
  BodyTemplate body, {
  String subject = 'S',
  EmailContext? context,
}) => renderEmail(
  subject: subject,
  body: body,
  context: context ?? EmailContext.sample('en'),
);

void main() {
  setUpAll(() => initializeDateFormatting());

  group('EmailContext', () {
    test('formats fields in the event language', () {
      final en = EmailContext.sample('en');
      expect(en.eventDate, 'Sunday, December 20, 2026');
      expect(en.eventTime, '7:30${nnbsp}PM');
      expect(en.budget, '\$25');
      expect(en.eventWhen, 'Sunday, December 20, 2026 · 7:30${nnbsp}PM');

      final es = EmailContext.sample('es');
      expect(es.eventDate, 'domingo, 20 de diciembre de 2026');
      expect(es.budget, contains('500'));
    });

    test('optional values are null, never empty strings', () {
      final values = EmailContext.sample('en', minimal: true).toMustache();
      for (final key in [
        'EventDate',
        'EventTime',
        'EventWhen',
        'EventPlace',
        'Budget',
        'OrganizerName',
      ]) {
        expect(values[key], isNull, reason: key);
      }
      expect(values['HasDetails'], isFalse);
      expect(values['HasWishlist'], isFalse);
    });

    test('drops non-web links from wishlists', () {
      final ctx = EmailContext(
        eventName: 'E',
        giverName: 'A',
        giverEmail: 'a@example.com',
        recipientName: 'B',
        wishlist: const [
          WishlistEntry('Evil', 'javascript:alert(1)'),
          WishlistEntry('Good', 'https://example.com'),
        ],
      );
      final list = ctx.toMustache()['Wishlist'] as List;
      expect(list[0], {'Text': 'Evil', 'Url': null});
      expect(list[1], {'Text': 'Good', 'Url': 'https://example.com'});
    });
  });

  group('inlineStyles', () {
    String inline(String html) {
      final doc = html_parser.parse(html);
      inlineStyles(doc);
      return doc.body!.innerHtml;
    }

    String withStyle(String css, String body) =>
        '<html><head><style>$css</style></head><body>$body</body></html>';

    test('applies <style> rules in cascade order and keeps inline styles', () {
      final out = inline(
        withStyle(
          'p { color: red; padding: 2px } .a { color: blue } #x { color: green } p { color: black }',
          '<p class="a" id="x" style="margin: 1px">Hi</p><p>Plain</p>',
        ),
      );
      expect(out, contains('color: green'));
      expect(out, contains('padding: 2px'));
      expect(out, contains('margin: 1px'));
      expect(out, contains('<p style="color: black; padding: 2px">Plain</p>'));
    });

    test('keeps the <style> block for apps that support it', () {
      final doc = html_parser.parse(withStyle('p { color: red }', '<p>x</p>'));
      inlineStyles(doc);
      expect(doc.querySelector('style')!.text, 'p { color: red }');
    });

    test('!important wins over inline styles', () {
      final out = inline(
        withStyle(
          'p { color: blue !important }',
          '<p style="color: red">x</p>',
        ),
      );
      expect(out, contains('color: blue'));
      expect(out, isNot(contains('red')));
    });

    test('supports descendant and grouped selectors', () {
      final out = inline(
        withStyle(
          '.w li { margin: 0 } h1, h2 { font-weight: bold }',
          '<ul class="w"><li>a</li></ul><h1>t</h1><h2>u</h2>',
        ),
      );
      expect(out, contains('<li style="margin: 0">'));
      expect(out, contains('<h1 style="font-weight: bold">'));
      expect(out, contains('<h2 style="font-weight: bold">'));
    });

    test(
      'leaves pseudo-classes, media queries and comments to the <style> block',
      () {
        final out = inline(
          withStyle(
            '/* note */ a:hover { color: red } @media (max-width: 600px) { a { color: blue } } a { color: green }',
            '<a href="#">x</a>',
          ),
        );
        expect(out, contains('style="color: green"'));
      },
    );

    test('documents without styles are left alone', () {
      expect(inline('<p>x</p>'), '<p>x</p>');
    });

    test('specificity counts ids, classes and tags', () {
      expect(specificity('#a .b p'), (1, 1, 1));
      expect(specificity('.details td'), (0, 1, 1));
      expect(specificity('ul > li + li'), (0, 0, 3));
      expect(specificity('a[href]'), (0, 1, 1));
    });
  });

  group('htmlToText', () {
    test('keeps structure, bullets and links', () {
      final doc = html_parser.parse(
        '<h1>Title</h1><p>Hello   <b>there</b></p>'
        '<ul><li><a href="https://example.com/a">Book</a></li><li>Socks</li></ul>'
        '<p>Line<br>break</p><style>p{}</style>',
      );
      expect(
        htmlToText(doc),
        'Title\n\nHello there\n\n• Book (https://example.com/a)\n• Socks\n\nLine\nbreak',
      );
    });
  });

  group('built-in template', () {
    test(
      'Brazilian Portuguese reads naturally and formats the Brazilian way',
      () {
        final ctx = EmailContext.sample('pt');
        expect(ctx.eventDate, 'domingo, 20 de dezembro de 2026');
        expect(ctx.budget, contains('R\$'));
        expect(ctx.budget, contains('100'));

        final email = renderEmail(
          subject: defaultSubject('pt'),
          body: builtinBody('pt'),
          context: ctx,
        );
        expect(
          email.subject,
          '🎁 Amigo Secreto da Firma 2026: descubra quem você tirou',
        );
        expect(
          email.text,
          startsWith('Oi, João!\n\nVocê tirou Beatriz no amigo secreto! 🎁'),
        );
        expect(email.text, contains('Onde: Casa da Ana, Vila Madalena'));
        expect(
          email.text,
          contains('Beatriz adoraria ganhar:\n• Livro de receitas'),
        );
        expect(
          email.text,
          contains('Shh… mantenha em segredo, mantenha seguro! 🤫'),
        );
        expect(email.html, contains('<p class="lead"'));
        expect(email.html, contains('Você tirou'));
        expect(email.html, contains('Feito com Santaroni'));
        expect(email.html, contains('<html lang="pt">'));
      },
    );

    test('is an HTML email with a hand-written plain-text version', () {
      for (final lang in builtinLanguages) {
        for (final minimal in [false, true]) {
          final ctx = EmailContext.sample(lang, minimal: minimal);
          final email = renderEmail(
            subject: defaultSubject(lang),
            body: builtinBody(lang),
            context: ctx,
          );
          expect(email.subject, contains(ctx.eventName));
          expect(email.html, startsWith('<!DOCTYPE html>'));
          expect(email.html, contains('<html lang="$lang">'));
          expect(email.html, contains(ctx.recipientName));
          expect(email.text, contains(ctx.recipientName));
          // Styles were copied inline, and the <style> block is still there.
          expect(email.html, contains('style="background-color: #c62828'));
          expect(email.html, contains('<style>'));
          // The emoji isn't italicized along with the sentence around it.
          expect(
            email.html,
            contains(
              '<span class="emoji" style="font-style: normal">🤫</span>',
            ),
          );
          expect(email.html, isNot(contains('{{')));
          expect(email.text, isNot(contains('{{')));
          expect(email.text, isNot(contains('\n\n\n')));
        }
      }
    });

    test('English plain-text version reads well', () {
      final email = renderEmail(
        subject: defaultSubject('en'),
        body: builtinBody('en'),
        context: EmailContext.sample('en'),
      );
      expect(
        email.subject,
        '🎁 Your Secret Santa assignment for Comic Book Group Secret Santa 2026',
      );
      expect(email.text, '''
Hi Alex,

You're the Secret Santa for Jordan! 🎁

Comic Book Group Secret Santa 2026
When: Sunday, December 20, 2026 · 7:30${nnbsp}PM
Where: Ana's place
Budget: up to \$25

Jordan would love:
• Saga Vol. 1 – https://example.com/saga
• Any Moebius artbook
• Good hot sauce

Shh… keep it secret, keep it safe! 🤫

— Sam''');
    });

    test('minimal data leaves no empty labels behind', () {
      final email = renderEmail(
        subject: defaultSubject('es'),
        body: builtinBody('es'),
        context: EmailContext.sample('es', minimal: true),
      );
      expect(email.text, isNot(contains('Cuándo')));
      expect(email.text, isNot(contains('Presupuesto')));
      expect(email.text, isNot(contains('le encantaría')));
      expect(email.html, isNot(contains('Dónde')));
      expect(email.html, isNot(contains('Enviado por')));
    });

    test('passes the template checks', () {
      for (final lang in builtinLanguages) {
        expect(checkSubject(defaultSubject(lang)), isNull);
        expect(checkBody(builtinBody(lang)), isNull);
      }
    });
  });

  group('user templates', () {
    test('plain text is filled in and tidied, with no HTML part', () {
      final email = render(
        const BodyTemplate(
          BodyFormat.text,
          'Hi {{GiverName}},\n\n\n\nyou got {{RecipientName}}.\n{{#EventPlace}}At {{EventPlace}}{{/EventPlace}}\n',
        ),
      );
      expect(email.html, isNull);
      expect(email.text, "Hi Alex,\n\nyou got Jordan.\nAt Ana's place");
    });

    test('HTML gets its styles inlined and a generated plain-text version', () {
      final email = render(
        const BodyTemplate(
          BodyFormat.html,
          '<html><head><style>.n { color: red }</style></head>'
          '<body><p>Hello {{GiverName}}</p><p class="n">You got <b>{{RecipientName}}</b></p></body></html>',
        ),
      );
      expect(
        email.html,
        contains('<p class="n" style="color: red">You got <b>Jordan</b></p>'),
      );
      expect(email.text, 'Hello Alex\n\nYou got Jordan');
    });

    test('escapes participant input in HTML but not in text or subject', () {
      final ctx = EmailContext(
        eventName: 'Tom & Jerry <3',
        giverName: '<script>x</script>',
        giverEmail: 'a@example.com',
        recipientName: 'Ana "La Jefa"',
      );
      final html = render(
        const BodyTemplate(
          BodyFormat.html,
          '<p>{{GiverName}} → {{RecipientName}}</p>',
        ),
        subject: '{{EventName}}',
        context: ctx,
      );
      expect(html.subject, 'Tom & Jerry <3');
      expect(html.html, isNot(contains('<script>')));
      expect(html.html, contains('&lt;script&gt;'));

      final text = render(
        const BodyTemplate(
          BodyFormat.text,
          '{{GiverName}} → {{RecipientName}}',
        ),
        context: ctx,
      );
      expect(text.text, '<script>x</script> → Ana "La Jefa"');
    });

    test('inverse sections work on text values', () {
      final email = render(
        const BodyTemplate(
          BodyFormat.text,
          '{{#Wishlist}}{{Text}}{{^Url}} (no link){{/Url}}\n{{/Wishlist}}',
        ),
      );
      expect(
        email.text,
        'Saga Vol. 1\nAny Moebius artbook (no link)\nGood hot sauce (no link)',
      );
    });
  });

  group('template checks', () {
    test('flag misspelled variables with their position', () {
      final problem = checkBody(
        const BodyTemplate(
          BodyFormat.html,
          '<p>Hi</p>\n<p>{{RecipientNmae}}</p>',
        ),
      );
      expect(problem, isNotNull);
      expect(problem!.unknownVariable, 'RecipientNmae');
      expect(problem.line, 2);
      expect(problem.column, 4);
    });

    test('flag broken sections', () {
      final problem = checkBody(
        const BodyTemplate(BodyFormat.text, 'a\n{{#HasWishlist}}oops'),
      );
      expect(problem, isNotNull);
      expect(problem!.unknownVariable, isNull);
      expect(problem.line, isNotNull);
    });

    test('check subjects too', () {
      expect(checkSubject('🎁 {{EventName}} for {{GiverName}}'), isNull);
      expect(checkSubject('{{EventNmae}}')!.part, TemplatePart.subject);
    });

    test('accept wishlist fields, comments and triple braces', () {
      expect(
        checkBody(
          const BodyTemplate(
            BodyFormat.html,
            '{{! a comment }}{{{GiverName}}}{{#Wishlist}}{{Text}} {{Url}}{{/Wishlist}}',
          ),
        ),
        isNull,
      );
    });
  });

  group('cancellation template', () {
    const cancel = TemplateKind.cancellation;

    test('passes the checks in every language', () {
      for (final lang in builtinLanguages) {
        expect(
          checkSubject(defaultCancellationSubject(lang), kind: cancel),
          isNull,
        );
        expect(checkBody(builtinCancellationBody(lang), kind: cancel), isNull);
        // It's not an assignment template, and vice versa.
        expect(checkBody(builtinCancellationBody(lang)), isNotNull);
        expect(checkBody(builtinBody(lang), kind: cancel), isNotNull);
      }
    });

    test('keeps the assignment email look', () {
      final html = builtinCancellationHtml('en');
      expect(html, contains('class="card"'));
      expect(html, contains('class="cancelled"'));
      expect(html, isNot(contains('RecipientName')));
    });

    test('shows the note only when there is one', () {
      final full = renderEmail(
        subject: defaultCancellationSubject('pt'),
        body: builtinCancellationBody('pt'),
        context: CancellationContext.sample('pt'),
      );
      expect(full.subject, '❌ Cancelado: Amigo Secreto da Firma 2026');
      expect(full.text, startsWith('Oi, João!\n\nSentimos avisar'));
      expect(full.text, contains('Um recado de Carol:\nMuita gente'));
      expect(full.html, contains('Um recado de Carol'));

      final minimal = renderEmail(
        subject: defaultCancellationSubject('es'),
        body: builtinCancellationBody('es'),
        context: CancellationContext.sample('es', minimal: true),
      );
      expect(minimal.text, isNot(contains('mensaje')));
      expect(minimal.text, isNot(contains('Cuándo')));
      expect(minimal.html, isNot(contains('class="note"')));
      expect(minimal.html, isNot(contains('Enviado por')));
    });

    test('a note without an organizer name still has a heading', () {
      final email = renderEmail(
        subject: 'S',
        body: builtinCancellationBody('en'),
        context: CancellationContext(
          eventName: 'Party',
          participantName: 'Ana',
          participantEmail: 'ana@example.com',
          note: '<b>See you</b> in January',
        ),
      );
      expect(
        email.text,
        contains('A note from the organizer:\n<b>See you</b>'),
      );
      expect(email.html, contains('&lt;b&gt;See you&lt;/b&gt;'));
    });

    test('variables belong to their kind', () {
      BodyTemplate t(String s) => BodyTemplate(BodyFormat.text, s);
      expect(
        checkBody(
          t('{{ParticipantName}} {{#Note}}{{Note}}{{/Note}}'),
          kind: cancel,
        ),
        isNull,
      );
      expect(checkBody(t('{{Note}}'))!.unknownVariable, 'Note');
      expect(
        checkBody(t('{{GiverName}}'), kind: cancel)!.unknownVariable,
        'GiverName',
      );
      expect(
        checkBody(t('{{#Wishlist}}{{Text}}{{/Wishlist}}'), kind: cancel),
        isNotNull,
      );
      expect(
        checkSubject('{{Budget}}', kind: cancel)!.unknownVariable,
        'Budget',
      );
    });
  });
}
