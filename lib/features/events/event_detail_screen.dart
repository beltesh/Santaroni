import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/assignment/secret_santa_cycle.dart';
import '../../core/email/builtin_templates.dart';
import '../../core/languages.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../data/templates_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/account_status_widgets.dart';
import '../common/dialogs.dart';
import '../common/format.dart';
import '../draw/draw_card.dart';
import '../draw/export_action.dart';
import '../participants/csv_import_screen.dart';
import '../participants/participant_form_screen.dart';
import '../templates/templates_screen.dart';
import 'event_form_screen.dart';

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final int eventId;

  bool _isLocked(Event e) =>
      e.status == EventStatus.sending || e.status == EventStatus.sent;

  Future<void> _delete(BuildContext context, WidgetRef ref, Event event) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmDestructive(
      context,
      title: l10n.deleteEventTitle,
      body: l10n.deleteEventBody(event.name),
      confirmLabel: l10n.delete,
    );
    if (!confirmed || !context.mounted) return;
    final navigator = Navigator.of(context);
    await ref.read(eventsRepositoryProvider).deleteEvent(event.id);
    navigator.pop();
  }

  void _openParticipant(
    BuildContext context,
    List<ParticipantWithWishlist> all, [
    ParticipantWithWishlist? existing,
  ]) {
    final groups = {
      for (final p in all)
        if (p.participant.groupTag != null) p.participant.groupTag!,
    }.toList()..sort();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ParticipantFormScreen(
          eventId: eventId,
          existing: existing,
          knownGroups: groups,
        ),
      ),
    );
  }

  Future<void> _removeAll(
    BuildContext context,
    WidgetRef ref,
    Event event,
    int count,
  ) async {
    final l10n = AppLocalizations.of(context);
    final body = l10n.removeAllParticipantsBody(count);
    final confirmed = await confirmDestructive(
      context,
      title: l10n.removeAllParticipantsTitle,
      body: event.status == EventStatus.generated
          ? '$body ${l10n.removeAllCancelsDraw}'
          : body,
      confirmLabel: l10n.removeAllParticipants,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(eventsRepositoryProvider).deleteAllParticipants(event.id);
    } on EventLockedException {
      if (context.mounted) showSnack(context, l10n.eventLockedError);
    }
  }

  Future<void> _import(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final count = await Navigator.of(context).push<int>(
      MaterialPageRoute(builder: (_) => CsvImportScreen(eventId: eventId)),
    );
    if (count != null && context.mounted) {
      showSnack(context, l10n.csvImported(count));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final event = ref.watch(eventProvider(eventId)).value;
    final participants = ref.watch(participantsProvider(eventId));

    if (event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final locked = _isLocked(event);
    final list = participants.value ?? const <ParticipantWithWishlist>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        actions: [
          IconButton(
            tooltip: l10n.exportJson,
            icon: const Icon(Icons.save_alt),
            onPressed: () => exportEvent(context, ref, event),
          ),
          IconButton(
            tooltip: l10n.edit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EventFormScreen(event: event),
              ),
            ),
          ),
          PopupMenuButton<void>(
            // Use the screen's context, not the menu's: the menu is gone by
            // the time the confirmation dialog opens.
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => _delete(context, ref, event),
                child: ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(l10n.delete),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          _EventInfoCard(event: event),
          if (event.status != EventStatus.sent) const AccountNeededBanner(),
          if (locked) ...[
            const SizedBox(height: 12),
            _Banner(icon: Icons.lock_outline, text: l10n.eventLockedBanner),
          ],
          const SizedBox(height: 12),
          DrawCard(event: event, participantCount: list.length),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.participants} (${list.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (!locked)
                TextButton.icon(
                  onPressed: () => _import(context),
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.importCsv),
                ),
              if (!locked && list.isNotEmpty)
                IconButton(
                  tooltip: l10n.removeAllParticipants,
                  icon: Icon(
                    Icons.delete_sweep_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => _removeAll(context, ref, event, list.length),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (participants.isLoading && list.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (list.isEmpty)
            _EmptyParticipants(
              onAdd: () => _openParticipant(context, list),
              onImport: () => _import(context),
            )
          else ...[
            if (event.status == EventStatus.generated)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Banner(
                  icon: Icons.info_outline,
                  text: l10n.rosterChangeCancelsDraw,
                ),
              ),
            if (list.length < SecretSantaCycle.minParticipants)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _Banner(
                  icon: Icons.info_outline,
                  text: l10n.needMoreParticipants(
                    SecretSantaCycle.minParticipants,
                  ),
                ),
              ),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final (i, p) in list.indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    _ParticipantTile(
                      entry: p,
                      onTap: () => _openParticipant(context, list, p),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: locked
          ? null
          : FloatingActionButton.extended(
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.addParticipant),
              onPressed: () => _openParticipant(context, list),
            ),
    );
  }
}

class _EventInfoCard extends ConsumerWidget {
  const _EventInfoCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final when = formatEventWhen(context, event);
    final budget = formatEventBudget(context, event);

    final templates = ref.watch(templatesProvider).value ?? const [];
    final custom = templates.where((t) => t.id == event.templateId).firstOrNull;
    final templateHasProblem = custom != null && custom.problem != null;
    final subject = (event.emailSubject ?? defaultSubject(event.languageCode))
        // Per-person variables stay as written; the event name is known.
        .replaceAll(RegExp(r'\{\{\s*EventName\s*\}\}'), event.name);

    final rows = <(IconData, String, bool)>[
      if (when != null) (Icons.event_outlined, when, false),
      if (event.place != null) (Icons.place_outlined, event.place!, false),
      if (budget != null)
        (Icons.savings_outlined, l10n.budgetUpTo(budget), false),
      (Icons.translate, languageEndonym(event.languageCode), false),
      (Icons.subject, subject, false),
      (
        Icons.mail_outline,
        custom == null
            ? builtinTemplateLabel(l10n, event.languageCode)
            : templateHasProblem
            ? '${custom.name} — ${l10n.templateNeedsFixing}'
            : custom.name,
        templateHasProblem,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(statusLabel(l10n, event.status)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (when == null && event.place == null && budget == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.eventDetailsEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final (icon, text, isProblem) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      isProblem ? Icons.error_outline : icon,
                      size: 20,
                      color: isProblem
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: isProblem
                            ? TextStyle(color: theme.colorScheme.error)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({required this.entry, required this.onTap});

  final ParticipantWithWishlist entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = entry.participant;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Text(initials(p.name))),
      title: Text(p.name),
      subtitle: Text(p.email),
      trailing: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (p.groupTag != null)
            Chip(
              avatar: const Icon(Icons.group_outlined, size: 16),
              label: Text(p.groupTag!),
              visualDensity: VisualDensity.compact,
            ),
          if (entry.wishlist.isNotEmpty)
            Tooltip(
              message: l10n.wishlistCount(entry.wishlist.length),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 2),
                  Text('${entry.wishlist.length}'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyParticipants extends StatelessWidget {
  const _EmptyParticipants({required this.onAdd, required this.onImport});

  final VoidCallback onAdd;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.groups_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(l10n.participantsEmpty, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.person_add_alt),
                  label: Text(l10n.addParticipant),
                ),
                OutlinedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.importCsv),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: scheme.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
