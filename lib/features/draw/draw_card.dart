import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/assignment/secret_santa_cycle.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';
import '../sending/send_screen.dart';
import '../common/status_colors.dart';
import '../sending/send_controller.dart';
import 'review_screen.dart';

/// The "draw names" section of the event screen.
class DrawCard extends ConsumerStatefulWidget {
  const DrawCard({
    super.key,
    required this.event,
    required this.participantCount,
  });

  final Event event;
  final int participantCount;

  @override
  ConsumerState<DrawCard> createState() => _DrawCardState();
}

class _DrawCardState extends ConsumerState<DrawCard> {
  bool _busy = false;

  Future<void> _draw({bool confirmRedraw = false}) async {
    final l10n = AppLocalizations.of(context);
    if (confirmRedraw) {
      final ok = await confirmDestructive(
        context,
        title: l10n.redrawTitle,
        body: l10n.redrawBody,
        confirmLabel: l10n.redraw,
      );
      if (!ok || !mounted) return;
    }

    setState(() => _busy = true);
    try {
      await ref.read(eventsRepositoryProvider).drawNames(widget.event.id);
      if (mounted) showSnack(context, l10n.drawDoneSnack);
    } on AssignmentException catch (e) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.drawErrorTitle),
          content: Text(switch (e.failure) {
            AssignmentFailure.tooFewParticipants => l10n.needMoreParticipants(
              SecretSantaCycle.minParticipants,
            ),
            _ => l10n.drawErrorExclusions,
          }),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    } on EventLockedException {
      if (mounted) showSnack(context, l10n.eventLockedError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final event = widget.event;
    final drawn = event.status != EventStatus.draft;
    final canEdit =
        event.status == EventStatus.draft ||
        event.status == EventStatus.generated;
    final enoughPeople =
        widget.participantCount >= SecretSantaCycle.minParticipants;

    return Card(
      color: drawn ? theme.colorScheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  drawn ? Icons.check_circle : Icons.shuffle,
                  color: drawn
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(switch (event.status) {
                    EventStatus.draft => l10n.drawReadyTitle,
                    EventStatus.generated => l10n.drawDoneTitle,
                    EventStatus.sending => l10n.sendPartlyTitle,
                    EventStatus.sent => l10n.allEmailsSent,
                  }, style: theme.textTheme.titleMedium),
                ),
                if (drawn) ...[
                  const SizedBox(width: 8),
                  _SendButton(event: event),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(switch (event.status) {
              EventStatus.draft => l10n.drawReadyBody,
              EventStatus.generated => l10n.drawDoneBody,
              EventStatus.sending => l10n.sendPartlyBody,
              EventStatus.sent => l10n.sentBody,
            }),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (!drawn)
                  FilledButton.icon(
                    onPressed: _busy || !enoughPeople ? null : _draw,
                    icon: const Icon(Icons.shuffle),
                    label: Text(l10n.drawNames),
                  )
                else ...[
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ReviewScreen(eventId: event.id),
                      ),
                    ),
                    icon: const Icon(Icons.visibility_off_outlined),
                    label: Text(l10n.reviewDraw),
                  ),
                  if (canEdit)
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _draw(confirmRedraw: true),
                      icon: const Icon(Icons.shuffle),
                      label: Text(l10n.redraw),
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens the send screen. Solid green when everything is ready and there
/// are emails left to send, so it can be spotted without reading; a plain
/// tonal button otherwise (the send screen explains what's missing).
class _SendButton extends ConsumerWidget {
  const _SendButton({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final blockers = ref.watch(sendBlockersProvider(event.id)).value;
    final ready =
        blockers != null &&
        blockers.isEmpty &&
        event.status != EventStatus.sent;

    void open() => Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SendScreen(eventId: event.id)),
    );
    final label = Text(
      event.status == EventStatus.generated
          ? l10n.sendEmails
          : l10n.emailStatus,
    );

    if (!ready) {
      return FilledButton.tonalIcon(
        onPressed: open,
        icon: const Icon(Icons.send_outlined),
        label: label,
      );
    }
    final go = StatusColors.go(context);
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: go.background,
        foregroundColor: go.foreground,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
        elevation: 2,
      ),
      onPressed: open,
      icon: const Icon(Icons.send),
      label: label,
    );
  }
}
