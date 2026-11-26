import 'package:html/dom.dart';

/// A CSS rule as written in the stylesheet.
class CssRule {
  const CssRule(this.selectors, this.declarations);

  final List<String> selectors;
  final List<CssDeclaration> declarations;
}

class CssDeclaration {
  const CssDeclaration(this.property, this.value, {this.important = false});

  final String property;
  final String value;
  final bool important;
}

/// Parses plain style rules. At-rules (`@media`, `@font-face`…) are skipped:
/// they can't be inlined and stay in the `<style>` block instead.
List<CssRule> parseCss(String css) {
  final source = css.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
  final rules = <CssRule>[];
  var i = 0;
  while (i < source.length) {
    final open = source.indexOf('{', i);
    if (open < 0) break;
    final selectorText = source.substring(i, open).trim();

    // Find the matching close brace, allowing nesting inside at-rules.
    var depth = 1;
    var j = open + 1;
    while (j < source.length && depth > 0) {
      if (source[j] == '{') depth++;
      if (source[j] == '}') depth--;
      j++;
    }
    final body = source.substring(open + 1, depth == 0 ? j - 1 : j);
    i = j;

    if (selectorText.isEmpty || selectorText.startsWith('@')) continue;
    final selectors = selectorText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final declarations = parseDeclarations(body);
    if (selectors.isNotEmpty && declarations.isNotEmpty) {
      rules.add(CssRule(selectors, declarations));
    }
  }
  return rules;
}

final _important = RegExp(r'!\s*important$', caseSensitive: false);

List<CssDeclaration> parseDeclarations(String block) {
  final result = <CssDeclaration>[];
  for (final part in block.split(';')) {
    final colon = part.indexOf(':');
    if (colon <= 0) continue;
    final property = part.substring(0, colon).trim().toLowerCase();
    var value = part.substring(colon + 1).trim();
    if (property.isEmpty || value.isEmpty) continue;
    final isImportant = _important.hasMatch(value);
    if (isImportant) value = value.replaceFirst(_important, '').trim();
    result.add(CssDeclaration(property, value, important: isImportant));
  }
  return result;
}

/// (ids, classes/attributes, tags), compared left to right.
(int, int, int) specificity(String selector) {
  final ids = RegExp(r'#[\w-]+').allMatches(selector).length;
  final classes = RegExp(r'\.[\w-]+|\[[^\]]*\]').allMatches(selector).length;
  final stripped = selector
      .replaceAll(RegExp(r'#[\w-]+|\.[\w-]+|\[[^\]]*\]'), ' ')
      .replaceAll(RegExp(r'[>+~]'), ' ');
  final tags = RegExp(r'(?:^|\s)([a-zA-Z][\w-]*)').allMatches(stripped).length;
  return (ids, classes, tags);
}

int _compareSpecificity((int, int, int) a, (int, int, int) b) {
  if (a.$1 != b.$1) return a.$1 - b.$1;
  if (a.$2 != b.$2) return a.$2 - b.$2;
  return a.$3 - b.$3;
}

/// Selectors that only make sense live in a browser (`:hover`, `::before`)
/// or would bloat every element (`*`) are left to the `<style>` block.
bool _canInline(String selector) =>
    !selector.contains(':') && !selector.contains('*');

class _Match {
  _Match(this.specificity, this.order, this.declarations);

  final (int, int, int) specificity;
  final int order;
  final List<CssDeclaration> declarations;
}

/// Copies the document's `<style>` rules onto matching elements' `style`
/// attributes, leaving the `<style>` blocks in place.
///
/// Gmail (in some apps and account types), Outlook and others ignore or
/// strip `<style>` blocks but keep inline styles. Cascade order is
/// respected: specificity, then source order; an element's own inline
/// style beats stylesheet rules; `!important` beats everything.
void inlineStyles(Document document) {
  final css = document.querySelectorAll('style').map((s) => s.text).join('\n');
  if (css.trim().isEmpty) return;

  final matches = <Element, List<_Match>>{};
  var order = 0;
  for (final rule in parseCss(css)) {
    for (final selector in rule.selectors) {
      order++;
      if (!_canInline(selector)) continue;
      List<Element> elements;
      try {
        elements = document.querySelectorAll(selector);
      } catch (_) {
        continue; // Selector the parser doesn't support: leave it in <style>.
      }
      for (final element in elements) {
        matches
            .putIfAbsent(element, () => [])
            .add(_Match(specificity(selector), order, rule.declarations));
      }
    }
  }

  for (final MapEntry(key: element, value: list) in matches.entries) {
    list.sort((a, b) {
      final bySpecificity = _compareSpecificity(a.specificity, b.specificity);
      return bySpecificity != 0 ? bySpecificity : a.order - b.order;
    });

    final normal = <String, String>{};
    final important = <String, String>{};
    for (final match in list) {
      for (final d in match.declarations) {
        (d.important ? important : normal)[d.property] = d.value;
      }
    }
    for (final d in parseDeclarations(element.attributes['style'] ?? '')) {
      (d.important ? important : normal)[d.property] = d.value;
    }
    final merged = {...normal, ...important};
    element.attributes['style'] = merged.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('; ');
  }
}
