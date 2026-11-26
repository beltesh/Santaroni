import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/send_service.dart';
import '../../l10n/app_localizations.dart';
import '../common/account_status_widgets.dart';
import '../common/dialogs.dart';
import '../common/status_colors.dart';
import '../templates/templates_screen.dart';
import 'send_controller.dart';
import 'send_screen.dart';

/// The cancellation emails of a cancelled event: progress, plus retrying
/// the ones that failed.
class CancelNoticesScreen extends ConsumerWidget {
  const CancelNoticesScreen({super.key, required this.eventId});

  final int eventId;

  Future<void> _resend(
    BuildContext context,
    WidgetRef ref,
    Participant person,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resendTitle(person.name)),
        content: Text(l10n.cancelResendBody(person.email)),
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
      await ref
          .read(cancelNoticesControllerProvider(eventId).notifier)
          .resend(person.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notices = ref.watch(noticesProvider(eventId)).value;
    final account = ref.watch(accountStatusProvider).value;
    final run = ref.watch(cancelNoticesControllerProvider(eventId));
    final blockers =
        ref.watch(noticeBlockersProvider(eventId)).value ??
        const <SendBlocker>{};
    final controller = ref.read(
      cancelNoticesControllerProvider(eventId).notifier,
    );

    ref.listen(cancelNoticesControllerProvider(eventId), (previous, next) {
      if (previous?.running != true || next.running) return;
      final message = SendScreen.runMessage(
        l10n,
        next,
        account?.account?.provider,
      );
      if (message != null) showSnack(context, message);
    });

    if (notices == null || account == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.cancelNoticesTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final sent = notices
        .where((n) => n.notice.sendStatus == SendStatus.sent)
        .length;
    final failed = notices
        .where((n) => n.notice.sendStatus == SendStatus.failed)
        .length;
    final pending = notices.length - sent - failed;
    final ready = blockers.isEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cancelNoticesTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (blockers.contains(SendBlocker.accountNotReady))
            _Problem(
              text: l10n.checkAccountMissing,
              action: l10n.setUpAccount,
              onAction: () => openEmailAccount(context),
            ),
          if (blockers.contains(SendBlocker.templateProblem))
            _Problem(
              text: l10n.checkTemplateProblem,
              action: l10n.emailTemplates,
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TemplatesScreen(
                    initialKind: TemplateKind.cancellation,
                  ),
                ),
              ),
            ),
          SendProgressCard(
            total: notices.length,
            sent: sent,
            failed: failed,
            running: run.running,
          ),
          const SizedBox(height: 12),
          if (run.running)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: run.stopRequested ? null : controller.stop,
                icon: const Icon(Icons.stop_circle_outlined),
                label: Text(run.stopRequested ? l10n.stopping : l10n.stop),
              ),
            )
          else if (pending + failed > 0)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilledButton.icon(
                onPressed: ready ? controller.sendAll : null,
                icon: const Icon(Icons.refresh),
                label: Text(
                  pending > 0
                      ? l10n.sendRemainingButton(pending + failed)
                      : l10n.retryFailedButton(failed),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, n) in notices.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  EmailStatusTile(
                    person: n.participant,
                    status: n.notice.sendStatus,
                    sentAt: n.notice.sentAt,
                    lastError: n.notice.lastError,
                    sendingNow:
                        run.running && run.currentGiverId == n.participant.id,
                    canResend: !run.running && ready,
                    onResend: () => _resend(context, ref, n.participant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Problem extends StatelessWidget {
  const _Problem({
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
    return Card(
      color: colors.background,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
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
      ),
    );
  }
}
