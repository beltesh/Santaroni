import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/assignment/secret_santa_cycle.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';
import 'export_action.dart';
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
            AssignmentFailure.tooFewParticipants =>
              l10n.needMoreParticipants(SecretSantaCycle.minParticipants),
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
    final canEdit = event.status == EventStatus.draft ||
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
                  child: Text(
                    drawn ? l10n.drawDoneTitle : l10n.drawReadyTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(drawn ? l10n.drawDoneBody : l10n.drawReadyBody),
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
                  FilledButton.icon(
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
                      onPressed:
                          _busy ? null : () => _draw(confirmRedraw: true),
                      icon: const Icon(Icons.shuffle),
                      label: Text(l10n.redraw),
                    ),
                ],
                OutlinedButton.icon(
                  onPressed: () => exportEvent(context, ref, event),
                  icon: const Icon(Icons.save_alt),
                  label: Text(l10n.exportJson),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
