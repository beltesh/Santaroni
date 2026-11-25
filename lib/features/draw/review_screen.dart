import 'dart:ui' show ImageFilter;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/assignment/secret_santa_cycle.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/format.dart';
import 'export_action.dart';

/// Lists who gives to whom, with every recipient hidden until revealed, so
/// an organizer who is also a participant can use it without spoiling
/// their own surprise.
class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, required this.eventId});

  final int eventId;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  /// Givers whose recipient is currently shown.
  final _revealed = <int>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final event = ref.watch(eventProvider(widget.eventId)).value;
    final assignments = ref.watch(assignmentsProvider(widget.eventId)).value;
    final participants = ref.watch(participantsProvider(widget.eventId)).value;

    if (event == null || assignments == null || participants == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.reviewTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final allShown = assignments.isNotEmpty &&
        assignments.every((a) => _revealed.contains(a.giver.id));
    final verified = _verify(participants, assignments);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reviewTitle),
        actions: [
          IconButton(
            tooltip: allShown ? l10n.hideAll : l10n.showAll,
            icon: Icon(allShown
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            onPressed: () => setState(() {
              if (allShown) {
                _revealed.clear();
              } else {
                _revealed.addAll(assignments.map((a) => a.giver.id));
              }
            }),
          ),
          IconButton(
            tooltip: l10n.exportJson,
            icon: const Icon(Icons.save_alt),
            onPressed: () => exportEvent(context, ref, event),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _StatusLine(
            ok: verified,
            text: verified ? l10n.drawVerified : l10n.drawInvalid,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reviewHiddenHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, a) in assignments.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _AssignmentRow(
                    view: a,
                    revealed: _revealed.contains(a.giver.id),
                    onToggle: () => setState(() {
                      if (!_revealed.remove(a.giver.id)) {
                        _revealed.add(a.giver.id);
                      }
                    }),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Re-checks the stored draw against the current participants.
  bool _verify(
    List<ParticipantWithWishlist> participants,
    List<AssignmentView> assignments,
  ) {
    final ids = [for (final p in participants) p.participant.id];
    final groups = {
      for (final p in participants) p.participant.id: p.participant.groupTag,
    };
    final map = {
      for (final a in assignments)
        a.assignment.giverId: a.assignment.recipientId,
    };
    return SecretSantaCycle.isValid(ids, map, groups: groups);
  }
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({
    required this.view,
    required this.revealed,
    required this.onToggle,
  });

  final AssignmentView view;
  final bool revealed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListTile(
      onTap: onToggle,
      leading: CircleAvatar(child: Text(initials(view.giver.name))),
      title: Text(view.giver.name),
      subtitle: Row(
        children: [
          Text('${l10n.givesTo} '),
          Flexible(
            child: revealed
                ? Text(
                    view.recipient.name,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  )
                : const _HiddenName(),
          ),
        ],
      ),
      trailing: IconButton(
        tooltip: revealed ? l10n.hide : l10n.show,
        icon: Icon(revealed
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined),
        onPressed: onToggle,
      ),
    );
  }
}

/// Stand-in for a hidden name. Deliberately never renders the real name
/// (not even blurred), so its length or shape can't give it away.
class _HiddenName extends StatelessWidget {
  const _HiddenName();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.hiddenName,
      excludeSemantics: true,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Text(
          'Xxxxxx Xxxxxxx',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.ok, required this.text});

  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = ok ? scheme.primary : scheme.error;
    return Row(
      children: [
        Icon(ok ? Icons.verified_outlined : Icons.error_outline, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color))),
      ],
    );
  }
}
