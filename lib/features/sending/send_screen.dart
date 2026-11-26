import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/email/email_providers.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../data/send_service.dart';
import '../../l10n/app_localizations.dart';
import '../common/account_status_widgets.dart';
import '../common/dialogs.dart';
import '../common/format.dart';
import '../common/status_colors.dart';
import '../settings/test_email_action.dart';
import '../templates/templates_screen.dart';
import 'send_controller.dart';

/// Sends the assignments and shows, per participant, whether their email
/// went out. Only givers are listed; recipients are never shown here.
class SendScreen extends ConsumerWidget {
  const SendScreen({super.key, required this.eventId});

  final int eventId;

  Future<void> _confirmAndSend(
    BuildContext context,
    WidgetRef ref, {
    required int count,
    required String from,
    required bool firstTime,
  }) async {
    final l10n = AppLocalizations.of(context);
    if (firstTime) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.send_outlined),
          title: Text(l10n.sendConfirmTitle(count)),
          content: Text(l10n.sendConfirmBody(from)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.sendNow),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    await ref.read(sendControllerProvider(eventId).notifier).sendAll();
  }

  Future<void> _resend(
    BuildContext context,
    WidgetRef ref,
    Participant giver,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resendTitle(giver.name)),
        content: Text(l10n.resendBody(giver.email)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.resend),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(sendControllerProvider(eventId).notifier).resend(giver.id);
    }
  }

  Future<void> _preview(
    BuildContext context,
    WidgetRef ref,
    Event event,
  ) async {
    final template = await ref
        .read(templatesRepositoryProvider)
        .forEvent(event);
    if (!context.mounted) return;
    await sendTestEmail(
      context,
      ref,
      subject: template.subject,
      body: template.body,
      languageCode: event.languageCode,
      event: event,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final event = ref.watch(eventProvider(eventId)).value;
    final assignments = ref.watch(assignmentsProvider(eventId)).value;
    final account = ref.watch(accountStatusProvider).value;
    final run = ref.watch(sendControllerProvider(eventId));

    // Surface the end of a run once, as a snackbar.
    ref.listen(sendControllerProvider(eventId), (previous, next) {
      if (previous?.running != true || next.running) return;
      final message = _runMessage(l10n, next, account?.account?.provider);
      if (message != null) showSnack(context, message);
    });

    if (event == null || assignments == null || account == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.sendTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final sentCount = assignments
        .where((a) => a.assignment.sendStatus == SendStatus.sent)
        .length;
    final failedCount = assignments
        .where((a) => a.assignment.sendStatus == SendStatus.failed)
        .length;
    final pendingCount = assignments.length - sentCount - failedCount;
    final remaining = pendingCount + failedCount;
    final nothingSentYet = sentCount == 0 && failedCount == 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sendTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _Checklist(event: event, accountReady: account.isReady),
          const SizedBox(height: 16),
          _ProgressCard(
            total: assignments.length,
            sent: sentCount,
            failed: failedCount,
            running: run.running,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (run.running)
                OutlinedButton.icon(
                  onPressed: run.stopRequested
                      ? null
                      : () => ref
                            .read(sendControllerProvider(eventId).notifier)
                            .stop(),
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: Text(run.stopRequested ? l10n.stopping : l10n.stop),
                )
              else if (remaining > 0)
                FilledButton.icon(
                  onPressed: account.isReady
                      ? () => _confirmAndSend(
                          context,
                          ref,
                          count: remaining,
                          from: account.account!.address,
                          firstTime: nothingSentYet,
                        )
                      : null,
                  icon: Icon(nothingSentYet ? Icons.send : Icons.refresh),
                  label: Text(
                    nothingSentYet
                        ? l10n.sendAllButton(remaining)
                        : pendingCount > 0
                        ? l10n.sendRemainingButton(remaining)
                        : l10n.retryFailedButton(failedCount),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: run.running || !account.isReady
                    ? null
                    : () => _preview(context, ref, event),
                icon: const Icon(Icons.preview_outlined),
                label: Text(l10n.sendMePreview),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.sendPrivacyNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, a) in assignments.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _GiverRow(
                    view: a,
                    sendingNow: run.running && run.currentGiverId == a.giver.id,
                    canResend: !run.running && account.isReady,
                    onResend: () => _resend(context, ref, a.giver),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String? _runMessage(
    AppLocalizations l10n,
    SendRunState state,
    EmailProvider? provider,
  ) {
    final error = state.lastError;
    if (error is SendBlockedException) return l10n.sendBlocked;
    if (error != null) return l10n.sendErrorOther('$error');
    final result = state.lastResult;
    if (result == null) return null;
    return switch (result.outcome) {
      SendOutcome.finished when result.failed == 0 => l10n.sendFinished(
        result.sent,
      ),
      SendOutcome.finished => l10n.sendFinishedWithFailures(
        result.sent,
        result.failed,
      ),
      SendOutcome.stopped => l10n.sendStopped(result.sent),
      SendOutcome.aborted => describeSendFailure(
        l10n,
        result.error!,
        provider ?? EmailProvider.gmail,
      ),
    };
  }
}

/// What must be in place before sending, with ways to fix each item.
class _Checklist extends ConsumerWidget {
  const _Checklist({required this.event, required this.accountReady});

  final Event event;
  final bool accountReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final blockers =
        ref.watch(sendBlockersProvider(event.id)).value ??
        const <SendBlocker>{};

    Widget item(
      bool ok,
      String text, {
      String? action,
      VoidCallback? onAction,
    }) {
      final colors = ok
          ? StatusColors.success(context)
          : StatusColors.warning(context);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(
              ok ? Icons.check_circle : Icons.warning_amber_rounded,
              color: colors.foreground,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
            if (!ok && action != null)
              TextButton(onPressed: onAction, child: Text(action)),
          ],
        ),
      );
    }

    final templateOk = !blockers.contains(SendBlocker.templateProblem);
    final drawOk =
        !blockers.contains(SendBlocker.drawInvalid) &&
        !blockers.contains(SendBlocker.notDrawn);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item(
              accountReady,
              accountReady ? l10n.checkAccountReady : l10n.checkAccountMissing,
              action: l10n.setUpAccount,
              onAction: () => openEmailAccount(context),
            ),
            item(
              templateOk,
              templateOk ? l10n.checkTemplateReady : l10n.checkTemplateProblem,
              action: l10n.emailTemplates,
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TemplatesScreen(),
                ),
              ),
            ),
            item(drawOk, drawOk ? l10n.checkDrawReady : l10n.drawInvalid),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.total,
    required this.sent,
    required this.failed,
    required this.running,
  });

  final int total;
  final int sent;
  final int failed;
  final bool running;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final done = total > 0 && sent == total;
    final colors = done
        ? StatusColors.success(context)
        : StatusColors(
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.onSurface,
          );

    return Card(
      margin: EdgeInsets.zero,
      color: colors.background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  done ? Icons.mark_email_read : Icons.outgoing_mail,
                  color: colors.foreground,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    done ? l10n.allEmailsSent : l10n.sentOfTotal(sent, total),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.foreground,
                    ),
                  ),
                ),
              ],
            ),
            if (failed > 0) ...[
              const SizedBox(height: 4),
              Text(
                l10n.failedCount(failed),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: total == 0 ? 0 : sent / total,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            if (running) ...[
              const SizedBox(height: 8),
              Text(
                l10n.sendingInProgress,
                style: TextStyle(color: colors.foreground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GiverRow extends StatelessWidget {
  const _GiverRow({
    required this.view,
    required this.sendingNow,
    required this.canResend,
    required this.onResend,
  });

  final AssignmentView view;
  final bool sendingNow;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final a = view.assignment;
    final locale = Localizations.localeOf(context).toLanguageTag();

    final (Widget icon, String status) = sendingNow
        ? (
            const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            l10n.statusSendingNow,
          )
        : switch (a.sendStatus) {
            SendStatus.sent => (
              Icon(
                Icons.check_circle,
                color: StatusColors.success(context).foreground,
              ),
              a.sentAt == null
                  ? l10n.statusEmailSent
                  : l10n.statusEmailSentAt(
                      DateFormat.MMMd(locale).add_jm().format(a.sentAt!),
                    ),
            ),
            SendStatus.failed => (
              Icon(Icons.error, color: theme.colorScheme.error),
              l10n.statusEmailFailed(a.lastError ?? ''),
            ),
            SendStatus.pending => (
              Icon(Icons.schedule, color: theme.colorScheme.onSurfaceVariant),
              l10n.statusEmailPending,
            ),
          };

    return ListTile(
      leading: CircleAvatar(child: Text(initials(view.giver.name))),
      title: Text(view.giver.name),
      subtitle: Text(
        '${view.giver.email}\n$status',
        style: a.sendStatus == SendStatus.failed && !sendingNow
            ? TextStyle(color: theme.colorScheme.error)
            : null,
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          if (a.sendStatus != SendStatus.pending)
            IconButton(
              tooltip: l10n.resend,
              icon: const Icon(Icons.forward_to_inbox_outlined),
              onPressed: canResend ? onResend : null,
            ),
        ],
      ),
    );
  }
}
