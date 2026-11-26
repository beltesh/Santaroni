import 'package:html/parser.dart' as html_parser;
import 'package:mustache_template/mustache.dart';

import 'css_inliner.dart';
import 'email_context.dart';
import 'html_to_text.dart';
import 'template_kind.dart';

enum BodyFormat { text, html }

/// An email body template: plain text or a complete HTML document, with
/// `{{Variables}}`.
///
/// For HTML, the author writes normal HTML with a `<style>` block; when
/// sending, those styles are also copied onto each element (see
/// [inlineStyles]) because several email apps ignore `<style>`.
class BodyTemplate {
  const BodyTemplate(this.format, this.source, {this.alternativeText});

  final BodyFormat format;
  final String source;

  /// Hand-written plain-text version for HTML templates. When null, it is
  /// generated from the HTML.
  final String? alternativeText;
}

class RenderedEmail {
  const RenderedEmail({required this.subject, required this.text, this.html});

  final String subject;

  /// Plain-text body. For HTML templates this is generated from the HTML
  /// and sent alongside it, which helps with spam filters and with email
  /// apps that can't show HTML.
  final String text;

  /// HTML body, or null for plain-text templates.
  final String? html;
}

enum TemplatePart { subject, body }

/// Why a template can't be used, and where.
class TemplateProblem implements Exception {
  const TemplateProblem(
    this.part,
    this.message, {
    this.line,
    this.column,
    this.unknownVariable,
  });

  final TemplatePart part;

  /// Technical description (from the template parser), in English.
  final String message;
  final int? line;
  final int? column;

  /// Set when the problem is a misspelled or unsupported `{{Variable}}`.
  final String? unknownVariable;

  @override
  String toString() =>
      'TemplateProblem(${part.name}'
      '${line == null ? '' : ' $line:$column'}): $message';
}

/// Fills in [subject] and [body] for one recipient.
///
/// In HTML bodies, values are HTML-escaped (participants type them, so this
/// keeps their text from breaking the layout or injecting markup). Throws
/// [TemplateProblem] for templates that don't parse.
RenderedEmail renderEmail({
  required String subject,
  required BodyTemplate body,
  required TemplateValues context,
}) {
  final values = context.toMustache();
  final renderedSubject = _render(
    TemplatePart.subject,
    subject,
    values,
    escapeHtml: false,
  ).replaceAll(RegExp(r'\s+'), ' ').trim();

  switch (body.format) {
    case BodyFormat.text:
      return RenderedEmail(
        subject: renderedSubject,
        text: normalizeText(
          _render(TemplatePart.body, body.source, values, escapeHtml: false),
        ),
      );
    case BodyFormat.html:
      final document = html_parser.parse(
        _render(TemplatePart.body, body.source, values, escapeHtml: true),
      );
      inlineStyles(document);
      final alternative = body.alternativeText;
      return RenderedEmail(
        subject: renderedSubject,
        html: '<!DOCTYPE html>\n${document.documentElement!.outerHtml}',
        text: alternative != null
            ? normalizeText(
                _render(
                  TemplatePart.body,
                  alternative,
                  values,
                  escapeHtml: false,
                ),
              )
            : htmlToText(document),
      );
  }
}

/// Returns why [subject] can't be used, or null when it's fine.
TemplateProblem? checkSubject(
  String subject, {
  TemplateKind kind = TemplateKind.assignment,
}) => _check(TemplatePart.subject, subject, kind);

/// Returns why [body] can't be used for a [kind] of email, or null when
/// it's fine: unknown variables (usually typos, or ones that belong to the
/// other kind) or broken `{{#Section}}` tags.
TemplateProblem? checkBody(
  BodyTemplate body, {
  TemplateKind kind = TemplateKind.assignment,
}) =>
    _check(
      TemplatePart.body,
      body.source,
      kind,
      escapeHtml: body.format == BodyFormat.html,
    ) ??
    (body.alternativeText == null
        ? null
        : _check(TemplatePart.body, body.alternativeText!, kind));

TemplateProblem? _check(
  TemplatePart part,
  String source,
  TemplateKind kind, {
  bool escapeHtml = false,
}) {
  final unknown = _findUnknownVariable(part, source, kind);
  if (unknown != null) return unknown;
  try {
    // Render with full and with minimal sample data, so both branches of
    // every section get exercised.
    for (final minimal in [false, true]) {
      _render(
        part,
        source,
        sampleValues(kind, 'en', minimal: minimal).toMustache(),
        escapeHtml: escapeHtml,
      );
    }
    return null;
  } on TemplateProblem catch (e) {
    return e;
  }
}

/// Names valid in a [kind] of template, plus the fields of each wishlist
/// item.
Set<String> _knownTags(TemplateKind kind) => {
  for (final v in TemplateVariable.forKind(kind)) v.tag,
  if (kind == TemplateKind.assignment) ...['Text', 'Url'],
  '.',
};

final _tagPattern = RegExp(r'\{\{(\{?)\s*([#^/&!>]?)\s*([^}]*?)\s*\}?\}\}');

/// Unknown variables silently render as nothing, so catch typos like
/// `{{EventNmae}}` before any email goes out.
TemplateProblem? _findUnknownVariable(
  TemplatePart part,
  String source,
  TemplateKind kind,
) {
  final known = _knownTags(kind);
  for (final m in _tagPattern.allMatches(source)) {
    final sigil = m[2]!;
    final name = m[3]!;
    if (sigil == '!' || name.isEmpty) continue; // Mustache comment.
    if (!known.contains(name.split('.').first)) {
      final (line, column) = _position(source, m.start);
      return TemplateProblem(
        part,
        'Unknown variable {{$name}}',
        line: line,
        column: column,
        unknownVariable: name,
      );
    }
  }
  return null;
}

(int, int) _position(String source, int offset) {
  final before = source.substring(0, offset);
  final line = '\n'.allMatches(before).length + 1;
  final column = offset - (before.lastIndexOf('\n') + 1) + 1;
  return (line, column);
}

String _render(
  TemplatePart part,
  String source,
  Map<String, Object?> values, {
  required bool escapeHtml,
}) {
  try {
    // Lenient so `{{^Url}}…{{/Url}}` works when Url is a string (strict
    // mode rejects inverse sections on strings). Unknown variables are
    // caught by [checkBody]/[checkSubject] instead.
    return Template(
      source,
      htmlEscapeValues: escapeHtml,
      lenient: true,
      name: part.name,
    ).renderString(values);
  } on TemplateException catch (e) {
    final hasPosition = e.offset != null;
    throw TemplateProblem(
      part,
      e.message,
      line: hasPosition ? e.line : null,
      column: hasPosition ? e.column : null,
    );
  }
}
