import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/email/builtin_templates.dart';
import '../../core/email/email_context.dart';
import '../../core/email/email_renderer.dart';
import '../../data/database.dart';
import '../../data/templates_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';
import '../settings/test_email_action.dart';

const _codeStyle = TextStyle(
  fontFamily: 'monospace',
  fontFamilyFallback: ['Consolas', 'Courier New'],
  fontSize: 13,
  height: 1.4,
);

String builtinTemplateLabel(AppLocalizations l10n, String languageCode) =>
    l10n.builtinTemplateName(
      languageCode == 'es' ? l10n.languageSpanish : l10n.languageEnglish,
    );

/// Plain-language explanation of a template problem.
String describeProblem(AppLocalizations l10n, TemplateProblem problem) {
  final variable = problem.unknownVariable;
  if (variable != null) {
    return l10n.templateUnknownVariable('{{$variable}}', problem.line ?? 1);
  }
  return problem.line == null
      ? l10n.templateSyntaxError(problem.message)
      : l10n.templateSyntaxErrorAt(problem.line!, problem.message);
}

/// Lets the user pick a template file. Returns null if they cancel.
Future<PlatformFile?> _pickTemplateFile() => FilePicker.pickFile(
  type: FileType.custom,
  allowedExtensions: templateFileExtensions,
);

/// Lists the built-in template and imported template files.
class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final file = await _pickTemplateFile();
    if (file == null || !context.mounted) return;
    try {
      final template = await ref
          .read(templatesRepositoryProvider)
          .importFile(file.name, await file.readAsBytes());
      if (!context.mounted) return;
      final problem = template.problem;
      showSnack(
        context,
        problem == null
            ? l10n.templateImported(template.name)
            : l10n.templateImportedWithProblem(template.name),
      );
    } on UnsupportedTemplateFileException {
      if (context.mounted) showSnack(context, l10n.templateUnsupportedFile);
    } catch (_) {
      if (context.mounted) showSnack(context, l10n.csvReadError);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final templates =
        ref.watch(templatesProvider).value ?? const <EmailTemplate>[];

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(text, style: theme.textTheme.titleSmall),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.emailTemplates)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(l10n.templatesIntro),
          ),
          header(l10n.templatesBuiltIn),
          for (final lang in builtinLanguages)
            ListTile(
              leading: const Icon(Icons.mark_email_read_outlined),
              title: Text(builtinTemplateLabel(l10n, lang)),
              subtitle: Text(l10n.builtinTemplateSubtitle),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _BuiltinTemplateScreen(languageCode: lang),
                ),
              ),
            ),
          header(l10n.templatesImported),
          if (templates.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                l10n.templatesImportedEmpty,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          for (final t in templates) _TemplateTile(template: t),
          const SizedBox(height: 8),
          const _VariablesHelp(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.upload_file),
        label: Text(l10n.importTemplate),
        onPressed: () => _import(context, ref),
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({required this.template});

  final EmailTemplate template;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final problem = template.problem;
    final isHtml = template.format == TemplateFormat.html;

    return ListTile(
      leading: Icon(isHtml ? Icons.html : Icons.notes),
      title: Text(template.name),
      subtitle: problem == null
          ? Text(
              '${template.fileName} · ${isHtml ? l10n.formatHtml : l10n.formatText}',
            )
          : Text(
              l10n.templateNeedsFixing,
              style: TextStyle(color: scheme.error),
            ),
      trailing: problem == null
          ? const Icon(Icons.chevron_right)
          : Icon(Icons.error_outline, color: scheme.error),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TemplateDetailScreen(templateId: template.id),
        ),
      ),
    );
  }
}

/// Details of an imported template: problems, a sample preview, and
/// actions to replace or delete it.
class TemplateDetailScreen extends ConsumerWidget {
  const TemplateDetailScreen({super.key, required this.templateId});

  final int templateId;

  Future<void> _replace(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final file = await _pickTemplateFile();
    if (file == null || !context.mounted) return;
    try {
      final t = await ref
          .read(templatesRepositoryProvider)
          .replaceFile(templateId, file.name, await file.readAsBytes());
      if (context.mounted) {
        showSnack(
          context,
          t.problem == null
              ? l10n.templateReplaced
              : l10n.templateImportedWithProblem(t.name),
        );
      }
    } on UnsupportedTemplateFileException {
      if (context.mounted) showSnack(context, l10n.templateUnsupportedFile);
    } catch (_) {
      if (context.mounted) showSnack(context, l10n.csvReadError);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirmDestructive(
      context,
      title: l10n.deleteTemplateTitle,
      body: l10n.deleteTemplateBody,
      confirmLabel: l10n.delete,
    );
    if (!ok || !context.mounted) return;
    final navigator = Navigator.of(context);
    await ref.read(templatesRepositoryProvider).delete(templateId);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = ref.watch(templateProvider(templateId)).value;
    if (t == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }
    final problem = t.problem;
    final isHtml = t.format == TemplateFormat.html;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.name),
        actions: [
          IconButton(
            tooltip: l10n.delete,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(isHtml ? Icons.html : Icons.notes),
            title: Text(t.fileName),
            subtitle: Text(
              '${isHtml ? l10n.formatHtml : l10n.formatText} · '
              '${l10n.templateImportedOn(DateFormat.yMMMd(locale).add_jm().format(t.importedAt))}',
            ),
          ),
          if (problem != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.error_outline,
                  color: theme.colorScheme.onErrorContainer,
                ),
                title: Text(
                  l10n.templateCannotSend,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
                subtitle: Text(
                  describeProblem(l10n, problem),
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => _replace(context, ref),
                icon: const Icon(Icons.upload_file),
                label: Text(l10n.replaceFile),
              ),
              if (problem == null)
                OutlinedButton.icon(
                  onPressed: () {
                    final lang =
                        Localizations.localeOf(context).languageCode == 'es'
                        ? 'es'
                        : 'en';
                    sendTestEmail(
                      context,
                      ref,
                      subject: defaultSubject(lang),
                      body: t.bodyTemplate,
                      languageCode: lang,
                    );
                  },
                  icon: const Icon(Icons.send_outlined),
                  label: Text(l10n.sendTestEmail),
                ),
            ],
          ),
          if (problem == null) ...[
            const SizedBox(height: 24),
            Text(
              isHtml ? l10n.previewPlainVersion : l10n.previewSample,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            if (isHtml)
              Text(
                l10n.previewHtmlNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 8),
            _SamplePreview(body: t.bodyTemplate),
          ],
        ],
      ),
    );
  }
}

/// Built-in template: explains it, offers its HTML as a file to customize,
/// and shows the plain-text version that goes along with it.
class _BuiltinTemplateScreen extends ConsumerWidget {
  const _BuiltinTemplateScreen({required this.languageCode});

  final String languageCode;

  Future<void> _saveCopy(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final uri = await FilePicker.saveFile(
        fileName: 'santaroni-template-$languageCode.html',
        bytes: Uint8List.fromList(utf8.encode(builtinHtml(languageCode))),
        mimeType: 'text/html',
      );
      if (uri != null && context.mounted) {
        showSnack(context, l10n.templateCopySaved);
      }
    } catch (_) {
      if (context.mounted) showSnack(context, l10n.fileSaveError);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(builtinTemplateLabel(l10n, languageCode))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.builtinTemplateDescription),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => sendTestEmail(
                  context,
                  ref,
                  subject: defaultSubject(languageCode),
                  body: builtinBody(languageCode),
                  languageCode: languageCode,
                ),
                icon: const Icon(Icons.send_outlined),
                label: Text(l10n.sendTestEmail),
              ),
              OutlinedButton.icon(
                onPressed: () => _saveCopy(context),
                icon: const Icon(Icons.save_alt),
                label: Text(l10n.saveTemplateCopy),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.previewPlainVersion, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            l10n.previewHtmlNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _SamplePreview(
            body: builtinBody(languageCode),
            subject: defaultSubject(languageCode),
            languageCode: languageCode,
          ),
        ],
      ),
    );
  }
}

/// The plain-text email a template produces for sample participants.
class _SamplePreview extends StatelessWidget {
  const _SamplePreview({required this.body, this.subject, this.languageCode});

  final BodyTemplate body;
  final String? subject;
  final String? languageCode;

  @override
  Widget build(BuildContext context) {
    final lang =
        languageCode ??
        (Localizations.localeOf(context).languageCode == 'es' ? 'es' : 'en');
    final email = renderEmail(
      subject: subject ?? defaultSubject(lang),
      body: body,
      context: EmailContext.sample(lang),
    );
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(
        subject == null ? email.text : '${email.subject}\n\n${email.text}',
        style: _codeStyle,
      ),
    );
  }
}

/// Reference of the variables template files can use.
class _VariablesHelp extends StatelessWidget {
  const _VariablesHelp();

  String _describe(AppLocalizations l10n, TemplateVariable v) => switch (v) {
    TemplateVariable.eventName => l10n.varEventName,
    TemplateVariable.eventWhen => l10n.varEventWhen,
    TemplateVariable.eventDate => l10n.varEventDate,
    TemplateVariable.eventTime => l10n.varEventTime,
    TemplateVariable.eventPlace => l10n.varEventPlace,
    TemplateVariable.budget => l10n.varBudget,
    TemplateVariable.giverName => l10n.varGiverName,
    TemplateVariable.giverEmail => l10n.varGiverEmail,
    TemplateVariable.recipientName => l10n.varRecipientName,
    TemplateVariable.organizerName => l10n.varOrganizerName,
    TemplateVariable.hasDetails => l10n.varHasDetails,
    TemplateVariable.hasWishlist => l10n.varHasWishlist,
    TemplateVariable.wishlist => l10n.varWishlist,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ExpansionTile(
        leading: const Icon(Icons.data_object),
        title: Text(l10n.templateVariablesTitle),
        subtitle: Text(l10n.templateVariablesSubtitle),
        shape: const Border(),
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: [
          for (final v in TemplateVariable.values)
            ListTile(
              dense: true,
              title: SelectableText(v.snippet, style: _codeStyle),
              subtitle: Text(_describe(l10n, v)),
            ),
        ],
      ),
    );
  }
}
