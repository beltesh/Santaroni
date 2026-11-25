const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', //
  'ñ': 'n', 'ç': 'c', 'ß': 'ss', 'æ': 'ae', 'œ': 'oe',
};

/// Turns an event name into a kebab-case file name stem:
/// "Comic Book Group Secret Santa 2026" → "comic-book-group-secret-santa-2026",
/// "Año Nuevo: ¡Intercambio!" → "ano-nuevo-intercambio".
///
/// Falls back to [fallback] when nothing usable is left.
String slugify(String input, {String fallback = 'secret-santa'}) {
  final buffer = StringBuffer();
  for (final char in input.toLowerCase().split('')) {
    buffer.write(_accents[char] ?? char);
  }
  final slug = buffer
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.isEmpty ? fallback : slug;
}
