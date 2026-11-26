import 'package:html/dom.dart';

const _paragraphTags = {
  'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'table', 'ul', 'ol', //
};
const _lineTags = {
  'div', 'tr', 'li', 'section', 'header', 'footer', 'article', 'center', //
};
const _skipTags = {'head', 'style', 'script', 'title', 'template'};

/// Converts rendered email HTML into a readable plain-text version, used
/// when a template has no hand-written text body.
String htmlToText(Document document) {
  final out = _TextBuilder();
  final root = document.body ?? document.documentElement;
  if (root != null) _walk(root, out);
  return normalizeText(out.toString());
}

/// Collects text, collapsing consecutive line breaks so that, e.g., two
/// adjacent list items are separated by one newline, not two.
class _TextBuilder {
  final _buffer = StringBuffer();
  var _trailingNewlines = 0;

  void text(String s) {
    if (s.isEmpty) return;
    _buffer.write(s);
    if (s.trim().isNotEmpty) _trailingNewlines = 0;
  }

  /// Ensures the output ends with at least [count] line breaks.
  void breakLines(int count) {
    while (_trailingNewlines < count) {
      _buffer.write('\n');
      _trailingNewlines++;
    }
  }

  @override
  String toString() => _buffer.toString();
}

void _walk(Node node, _TextBuilder out) {
  if (node is Text) {
    out.text(node.text.replaceAll(RegExp(r'\s+'), ' '));
    return;
  }
  if (node is! Element) return;

  final tag = node.localName ?? '';
  if (_skipTags.contains(tag)) return;

  switch (tag) {
    case 'br':
      // A <br> always adds a line, even after another break.
      out.text('\n');
      return;
    case 'hr':
      out
        ..breakLines(2)
        ..text('——————————')
        ..breakLines(2);
      return;
    case 'img':
      final alt = node.attributes['alt'];
      if (alt != null && alt.trim().isNotEmpty) out.text(alt);
      return;
  }

  if (_paragraphTags.contains(tag)) out.breakLines(2);
  if (_lineTags.contains(tag)) out.breakLines(1);
  if (tag == 'li') out.text('• ');
  if (tag == 'td' || tag == 'th') out.text(' ');

  for (final child in node.nodes) {
    _walk(child, out);
  }

  if (tag == 'a') {
    final href = node.attributes['href']?.trim();
    final text = node.text.trim();
    if (href != null &&
        href.isNotEmpty &&
        href != text &&
        !href.startsWith('mailto:') &&
        !href.startsWith('#')) {
      out.text(' ($href)');
    }
  }
  if (_paragraphTags.contains(tag)) out.breakLines(2);
  if (_lineTags.contains(tag)) out.breakLines(1);
}

/// Tidies whitespace: trims lines, and allows at most one blank line in a
/// row. Also used for hand-written text bodies, where Mustache sections
/// that render nothing can leave stray blank lines.
String normalizeText(String text) => text
    .replaceAll('\r\n', '\n')
    .split('\n')
    .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
    .join('\n')
    .replaceAll(RegExp(r'\n{3,}'), '\n\n')
    .trim();
