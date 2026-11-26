import 'email_renderer.dart';

/// Languages with a built-in template and default subject.
const builtinLanguages = ['en', 'es'];

/// Subject used when an event doesn't set its own.
String defaultSubject(String languageCode) => languageCode == 'es'
    ? '🎁 {{EventName}}: descubre a quién te tocó regalar'
    : '🎁 Your Secret Santa assignment for {{EventName}}';

/// The default email: HTML in the event's language, with a hand-written
/// plain-text version sent alongside it.
BodyTemplate builtinBody(String languageCode) => languageCode == 'es'
    ? BodyTemplate(
        BodyFormat.html,
        builtinHtml('es'),
        alternativeText: _spanishText,
      )
    : BodyTemplate(
        BodyFormat.html,
        builtinHtml('en'),
        alternativeText: _englishText,
      );

/// The complete HTML document of the built-in template. Also a good
/// starting point for anyone writing their own template file.
String builtinHtml(String languageCode) {
  final es = languageCode == 'es';
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
${es ? _spanishBody : _englishBody}
</body>
</html>
''';
}

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

const _englishBody = '''
<table role="presentation" class="page" width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center">
      <table role="presentation" class="card" width="600" cellpadding="0" cellspacing="0">
        <tr>
          <td class="header">
            <p class="eyebrow">🎁 Secret Santa</p>
            <p class="event-name">{{EventName}}</p>
          </td>
        </tr>
        <tr>
          <td class="content">
            <p class="greeting">Hi {{GiverName}},</p>
            <p class="lead">You're the Secret Santa for</p>
            <p class="recipient">{{RecipientName}}</p>
            {{#HasDetails}}
            <table role="presentation" class="details" width="100%" cellpadding="0" cellspacing="0">
              {{#EventWhen}}
              <tr><td class="label">When</td><td class="value">{{EventWhen}}</td></tr>
              {{/EventWhen}}
              {{#EventPlace}}
              <tr><td class="label">Where</td><td class="value">{{EventPlace}}</td></tr>
              {{/EventPlace}}
              {{#Budget}}
              <tr><td class="label">Budget</td><td class="value">Up to {{Budget}}</td></tr>
              {{/Budget}}
            </table>
            {{/HasDetails}}
            {{#HasWishlist}}
            <p class="wishlist-title">{{RecipientName}} would love</p>
            <ul class="wishlist">
              {{#Wishlist}}
              <li>{{#Url}}<a href="{{Url}}">{{Text}}</a>{{/Url}}{{^Url}}{{Text}}{{/Url}}</li>
              {{/Wishlist}}
            </ul>
            {{/HasWishlist}}
            <p class="secret">Shh… keep it secret, keep it safe! <span class="emoji">🤫</span></p>
          </td>
        </tr>
        <tr>
          <td class="footer">{{#OrganizerName}}Sent by {{OrganizerName}} · {{/OrganizerName}}Made with Santaroni</td>
        </tr>
      </table>
    </td>
  </tr>
</table>''';

const _spanishBody = '''
<table role="presentation" class="page" width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center">
      <table role="presentation" class="card" width="600" cellpadding="0" cellspacing="0">
        <tr>
          <td class="header">
            <p class="eyebrow">🎁 Intercambio de regalos</p>
            <p class="event-name">{{EventName}}</p>
          </td>
        </tr>
        <tr>
          <td class="content">
            <p class="greeting">¡Hola, {{GiverName}}!</p>
            <p class="lead">Te tocó regalarle a</p>
            <p class="recipient">{{RecipientName}}</p>
            {{#HasDetails}}
            <table role="presentation" class="details" width="100%" cellpadding="0" cellspacing="0">
              {{#EventWhen}}
              <tr><td class="label">Cuándo</td><td class="value">{{EventWhen}}</td></tr>
              {{/EventWhen}}
              {{#EventPlace}}
              <tr><td class="label">Dónde</td><td class="value">{{EventPlace}}</td></tr>
              {{/EventPlace}}
              {{#Budget}}
              <tr><td class="label">Presupuesto</td><td class="value">Hasta {{Budget}}</td></tr>
              {{/Budget}}
            </table>
            {{/HasDetails}}
            {{#HasWishlist}}
            <p class="wishlist-title">A {{RecipientName}} le encantaría</p>
            <ul class="wishlist">
              {{#Wishlist}}
              <li>{{#Url}}<a href="{{Url}}">{{Text}}</a>{{/Url}}{{^Url}}{{Text}}{{/Url}}</li>
              {{/Wishlist}}
            </ul>
            {{/HasWishlist}}
            <p class="secret">Shh… ¡mantenlo en secreto, mantenlo a salvo! <span class="emoji">🤫</span></p>
          </td>
        </tr>
        <tr>
          <td class="footer">{{#OrganizerName}}Enviado por {{OrganizerName}} · {{/OrganizerName}}Hecho con Santaroni</td>
        </tr>
      </table>
    </td>
  </tr>
</table>''';

const _englishText = '''
Hi {{GiverName}},

You're the Secret Santa for {{RecipientName}}! 🎁

{{EventName}}
{{#EventWhen}}
When: {{EventWhen}}
{{/EventWhen}}
{{#EventPlace}}
Where: {{EventPlace}}
{{/EventPlace}}
{{#Budget}}
Budget: up to {{Budget}}
{{/Budget}}
{{#HasWishlist}}

{{RecipientName}} would love:
{{#Wishlist}}
• {{Text}}{{#Url}} – {{Url}}{{/Url}}
{{/Wishlist}}
{{/HasWishlist}}

Shh… keep it secret, keep it safe! 🤫
{{#OrganizerName}}

— {{OrganizerName}}
{{/OrganizerName}}
''';

const _spanishText = '''
¡Hola, {{GiverName}}!

Te tocó regalarle a {{RecipientName}}. 🎁

{{EventName}}
{{#EventWhen}}
Cuándo: {{EventWhen}}
{{/EventWhen}}
{{#EventPlace}}
Dónde: {{EventPlace}}
{{/EventPlace}}
{{#Budget}}
Presupuesto: hasta {{Budget}}
{{/Budget}}
{{#HasWishlist}}

A {{RecipientName}} le encantaría:
{{#Wishlist}}
• {{Text}}{{#Url}} – {{Url}}{{/Url}}
{{/Wishlist}}
{{/HasWishlist}}

Shh… ¡mantenlo en secreto, mantenlo a salvo! 🤫
{{#OrganizerName}}

— {{OrganizerName}}
{{/OrganizerName}}
''';
