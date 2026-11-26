import '../languages.dart';
import 'email_renderer.dart';

/// Languages with a built-in template and default subject.
const builtinLanguages = supportedLanguages;

/// Subject used when an event doesn't set its own.
String defaultSubject(String languageCode) => _phrases(languageCode).subject;

/// The default email: HTML in the event's language, with a hand-written
/// plain-text version sent alongside it.
BodyTemplate builtinBody(String languageCode) => BodyTemplate(
  BodyFormat.html,
  builtinHtml(languageCode),
  alternativeText: _text(_phrases(languageCode)),
);

/// Everything that differs between languages in the built-in email.
/// Phrases may contain `{{Variables}}`.
typedef _Phrases = ({
  String subject,
  String eyebrow,
  String greeting,
  String htmlLead,
  String textLead,
  String when,
  String where,
  String budget,
  String budgetUpTo,
  String textBudget,
  String wishlistTitle,
  String secret,
  String sentBy,
  String madeWith,
});

_Phrases _phrases(String languageCode) => switch (languageCode) {
  'es' => (
    subject: '🎁 {{EventName}}: descubre a quién te tocó regalar',
    eyebrow: '🎁 Intercambio de regalos',
    greeting: '¡Hola, {{GiverName}}!',
    htmlLead: 'Te tocó regalarle a',
    textLead: 'Te tocó regalarle a {{RecipientName}}. 🎁',
    when: 'Cuándo',
    where: 'Dónde',
    budget: 'Presupuesto',
    budgetUpTo: 'Hasta {{Budget}}',
    textBudget: 'Presupuesto: hasta {{Budget}}',
    wishlistTitle: 'A {{RecipientName}} le encantaría',
    secret: 'Shh… ¡mantenlo en secreto, mantenlo a salvo!',
    sentBy: 'Enviado por',
    madeWith: 'Hecho con Santaroni',
  ),
  'pt' => (
    subject: '🎁 {{EventName}}: descubra quem você tirou',
    eyebrow: '🎁 Amigo Secreto',
    greeting: 'Oi, {{GiverName}}!',
    htmlLead: 'Você tirou',
    textLead: 'Você tirou {{RecipientName}} no amigo secreto! 🎁',
    when: 'Quando',
    where: 'Onde',
    budget: 'Valor',
    budgetUpTo: 'Até {{Budget}}',
    textBudget: 'Valor: até {{Budget}}',
    wishlistTitle: '{{RecipientName}} adoraria ganhar',
    secret: 'Shh… mantenha em segredo, mantenha seguro!',
    sentBy: 'Enviado por',
    madeWith: 'Feito com Santaroni',
  ),
  _ => (
    subject: '🎁 Your Secret Santa assignment for {{EventName}}',
    eyebrow: '🎁 Secret Santa',
    greeting: 'Hi {{GiverName}},',
    htmlLead: "You're the Secret Santa for",
    textLead: "You're the Secret Santa for {{RecipientName}}! 🎁",
    when: 'When',
    where: 'Where',
    budget: 'Budget',
    budgetUpTo: 'Up to {{Budget}}',
    textBudget: 'Budget: up to {{Budget}}',
    wishlistTitle: '{{RecipientName}} would love',
    secret: 'Shh… keep it secret, keep it safe!',
    sentBy: 'Sent by',
    madeWith: 'Made with Santaroni',
  ),
};

/// The complete HTML document of the built-in template. Also a good
/// starting point for anyone writing their own template file.
String builtinHtml(String languageCode) {
  final p = _phrases(languageCode);
  return '''
<!DOCTYPE html>
<html lang="$languageCode">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{EventName}}</title>
<style>
$_css
</style>
</head>
<body>
<table role="presentation" class="page" width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center">
      <table role="presentation" class="card" width="600" cellpadding="0" cellspacing="0">
        <tr>
          <td class="header">
            <p class="eyebrow">${p.eyebrow}</p>
            <p class="event-name">{{EventName}}</p>
          </td>
        </tr>
        <tr>
          <td class="content">
            <p class="greeting">${p.greeting}</p>
            <p class="lead">${p.htmlLead}</p>
            <p class="recipient">{{RecipientName}}</p>
            {{#HasDetails}}
            <table role="presentation" class="details" width="100%" cellpadding="0" cellspacing="0">
              {{#EventWhen}}
              <tr><td class="label">${p.when}</td><td class="value">{{EventWhen}}</td></tr>
              {{/EventWhen}}
              {{#EventPlace}}
              <tr><td class="label">${p.where}</td><td class="value">{{EventPlace}}</td></tr>
              {{/EventPlace}}
              {{#Budget}}
              <tr><td class="label">${p.budget}</td><td class="value">${p.budgetUpTo}</td></tr>
              {{/Budget}}
            </table>
            {{/HasDetails}}
            {{#HasWishlist}}
            <p class="wishlist-title">${p.wishlistTitle}</p>
            <ul class="wishlist">
              {{#Wishlist}}
              <li>{{#Url}}<a href="{{Url}}">{{Text}}</a>{{/Url}}{{^Url}}{{Text}}{{/Url}}</li>
              {{/Wishlist}}
            </ul>
            {{/HasWishlist}}
            <p class="secret">${p.secret} <span class="emoji">🤫</span></p>
          </td>
        </tr>
        <tr>
          <td class="footer">{{#OrganizerName}}${p.sentBy} {{OrganizerName}} · {{/OrganizerName}}${p.madeWith}</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
''';
}

String _text(_Phrases p) =>
    '''
${p.greeting}

${p.textLead}

{{EventName}}
{{#EventWhen}}
${p.when}: {{EventWhen}}
{{/EventWhen}}
{{#EventPlace}}
${p.where}: {{EventPlace}}
{{/EventPlace}}
{{#Budget}}
${p.textBudget}
{{/Budget}}
{{#HasWishlist}}

${p.wishlistTitle}:
{{#Wishlist}}
• {{Text}}{{#Url}} – {{Url}}{{/Url}}
{{/Wishlist}}
{{/HasWishlist}}

${p.secret} 🤫
{{#OrganizerName}}

— {{OrganizerName}}
{{/OrganizerName}}
''';

/// Tables plus styles (copied inline when sending) are the most reliable
/// layout across Gmail, Outlook and Apple Mail.
const _css = '''
body { margin: 0; padding: 0; background-color: #f6f1ea; }
.page { background-color: #f6f1ea; padding: 24px 12px; }
.card { width: 100%; max-width: 600px; background-color: #ffffff; border-radius: 16px; font-family: Helvetica, Arial, sans-serif; color: #2b2b2b; }
.header { background-color: #c62828; padding: 28px 32px; text-align: center; border-radius: 16px 16px 0 0; }
.eyebrow { margin: 0; color: #ffd8d4; font-size: 13px; letter-spacing: 2px; text-transform: uppercase; }
.event-name { margin: 8px 0 0; color: #ffffff; font-size: 24px; line-height: 1.3; font-weight: bold; }
.content { padding: 32px; font-size: 16px; line-height: 1.5; }
.greeting { margin: 0 0 8px; }
.lead { margin: 0; }
.recipient { margin: 8px 0 24px; padding: 12px 20px; background-color: #1b5e20; color: #ffffff; font-size: 26px; font-weight: bold; border-radius: 12px; text-align: center; }
.details { margin: 0 0 24px; border-top: 1px solid #eeeeee; }
.details td { padding: 10px 0; border-bottom: 1px solid #eeeeee; vertical-align: top; }
.label { width: 110px; color: #8a8a8a; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; }
.value { color: #2b2b2b; }
.wishlist-title { margin: 0 0 8px; font-size: 18px; color: #c62828; }
.wishlist { margin: 0 0 24px; padding-left: 20px; }
.wishlist li { margin: 0 0 6px; }
a { color: #c62828; }
.secret { margin: 0; color: #666666; font-style: italic; }
.emoji { font-style: normal; }
.footer { padding: 16px 32px; background-color: #faf7f2; color: #9a9a9a; font-size: 12px; text-align: center; border-radius: 0 0 16px 16px; }''';
