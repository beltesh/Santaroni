import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/email/builtin_templates.dart';
import '../../core/email/email_renderer.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../data/send_service.dart';
import '../../data/templates_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/account_status_widgets.dart';
import '../common/dialogs.dart';
import '../common/status_colors.dart';
import '../sending/cancel_notices_screen.dart';
import '../sending/send_controller.dart';
import '../settings/test_email_action.dart';
import '../templates/template_picker.dart';
import '../templates/templates_screen.dart';

/// Asks how to cancel [event] (note, emails, template), cancels it, and
/// sends the cancellation emails, showing their progress.
Future<void> cancelEventFlow(
  BuildContext context,
  WidgetRef ref,
  Event event, {
  required int participantCount,
}) async {
  final l10n = AppLocalizations.of(context);
  final request = await showDialog<CancelRequest>(
    context: context,
    builder: (_) =>
        CancelEventDialog(event: event, participantCount: participantCount),
  );
  if (request == null || !context.mounted) return;

  try {
    await ref.read(cancellationServiceProvider).cancel(event.id, request);
  } on SendBlockedException {
    // The dialog checks the same things, so this only happens if something
    // changed in between (e.g. the event's date just passed).
    if (context.mounted) showSnack(context, l10n.sendBlocked);
    return;
  } on EventCompletedException {
    if (context.mounted) showSnack(context, l10n.eventCompletedError);
    return;
  }
  if (!context.mounted) return;
  showSnack(context, l10n.eventCancelledSnack);

  if (request.notify && participantCount > 0) {
    // The organizer already confirmed in the dialog: start right away.
    ref.read(cancelNoticesControllerProvider(event.id).notifier).sendAll();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CancelNoticesScreen(eventId: event.id),
      ),
    );
  }
}

/// Collects how to cancel an event. Pops a [CancelRequest], or null when
/// the organizer keeps the event.
class CancelEventDialog extends ConsumerStatefulWidget {
  const CancelEventDialog({
    super.key,
    required this.event,
    required this.participantCount,
  });

  final Event event;
  final int participantCount;

  @override
  ConsumerState<CancelEventDialog> createState() => _CancelEventDialogState();
}

class _CancelEventDialogState extends ConsumerState<CancelEventDialog> {
  late bool _notify = widget.participantCount > 0;
  final _note = TextEditingController();
  late final _subject = TextEditingController(
    text: defaultCancellationSubject(widget.event.languageCode),
  );
  int? _templateId;

  @override
  void dispose() {
    _note.dispose();
    _subject.dispose();
    super.dispose();
  }

  CancelRequest get _request => CancelRequest(
    notify: _notify,
    note: _note.text,
    templateId: _templateId,
    subject: _subject.text,
  );

  Future<void> _preview() async {
    final template = await ref
        .read(cancellationServiceProvider)
        .templateFor(widget.event, _request);
    if (!mounted) return;
    await sendTestEmail(
      context,
      ref,
      subject: template.subject,
      body: template.body,
      languageCode: widget.event.languageCode,
      kind: TemplateKind.cancellation,
      event: widget.event,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accountReady =
        ref.watch(accountStatusProvider).value?.isReady ?? false;
    final templates = ref.watch(templatesProvider).value ?? const [];
    final templateHasProblem = templates.any(
      (t) => t.id == _templateId && t.problem != null,
    );
    final subjectProblem = checkSubject(
      _subject.text,
      kind: TemplateKind.cancellation,
    );
    final canEmail = widget.participantCount > 0;
    final emailsReady =
        accountReady && !templateHasProblem && subjectProblem == null;
    final canConfirm = !_notify || emailsReady;

    return AlertDialog(
      icon: const Icon(Icons.event_busy_outlined),
      title: Text(l10n.cancelEventTitle(widget.event.name)),
      scrollable: true,
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cancelEventBody),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                canEmail
                    ? l10n.cancelNotify(widget.participantCount)
                    : l10n.cancelNotifyNone,
              ),
              value: _notify,
              onChanged: canEmail ? (v) => setState(() => _notify = v) : null,
            ),
            if (_notify) ...[
              if (!accountReady)
                _Warning(
                  text: l10n.cancelAccountNeeded,
                  action: l10n.setUpAccount,
                  onAction: () => openEmailAccount(context),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _note,
                minLines: 2,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.cancelNoteLabel,
                  helperText: l10n.cancelNoteHelp,
                  helperMaxLines: 2,
                  prefixIcon: const Icon(Icons.sticky_note_2_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TemplatePicker(
                kind: TemplateKind.cancellation,
                languageCode: widget.event.languageCode,
                value: _templateId,
                onChanged: (id) => setState(() => _templateId = id),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _subject,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.emailSubject,
                  prefixIcon: const Icon(Icons.subject),
                  errorText: subjectProblem == null
                      ? null
                      : describeProblem(l10n, subjectProblem),
                  errorMaxLines: 3,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: emailsReady ? _preview : null,
                  icon: const Icon(Icons.preview_outlined),
                  label: Text(l10n.sendMePreview),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.keepEvent),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: canConfirm
              ? () => Navigator.of(context).pop(_request)
              : null,
          child: Text(l10n.cancelConfirm),
        ),
      ],
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning({
    required this.text,
    required this.action,
    required this.onAction,
  });

  final String text;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = StatusColors.warning(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: colors.foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: colors.foreground)),
          ),
          TextButton(onPressed: onAction, child: Text(action)),
        ],
      ),
    );
  }
}
