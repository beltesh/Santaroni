import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/format.dart';
import '../events/event_detail_screen.dart';
import '../events/event_form_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final events = ref.watch(eventSummariesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: switch (events) {
        AsyncData(value: final list) when list.isEmpty => const _EmptyState(),
        AsyncData(value: final list) => ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _EventCard(summary: list[i]),
          ),
        AsyncError(:final error) => Center(child: Text('$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.newEvent),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const EventFormScreen()),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.card_giftcard, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(l10n.homeEmptyTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l10n.homeEmptyBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.summary});

  final EventSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final event = summary.event;
    final when = formatEventWhen(context, event);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => EventDetailScreen(eventId: event.id),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(event.name, style: theme.textTheme.titleMedium),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(statusLabel(l10n, event.status)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              if (when != null) ...[
                const SizedBox(height: 4),
                Text(when, style: theme.textTheme.bodyMedium),
              ],
              const SizedBox(height: 4),
              Text(
                l10n.participantCount(summary.participantCount),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
