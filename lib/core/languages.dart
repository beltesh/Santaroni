/// Languages Santaroni speaks, both in its interface and in emails.
/// Adding one means: an ARB file, a built-in email phrasebook (see
/// builtin_templates.dart) and an entry here.
const supportedLanguages = ['en', 'es', 'pt'];

/// [code] if supported, otherwise English.
String supportedLanguage(String? code) =>
    supportedLanguages.contains(code) ? code! : 'en';

/// The regional variant used for dates, times and money in emails:
/// Mexican Spanish and Brazilian Portuguese.
String formattingLocale(String languageCode) => switch (languageCode) {
  'es' => 'es_MX',
  'pt' => 'pt_BR',
  _ => 'en_US',
};

/// Each language's name in that language, as shown in language pickers.
String languageEndonym(String languageCode) => switch (languageCode) {
  'es' => 'Español',
  'pt' => 'Português (Brasil)',
  _ => 'English',
};
