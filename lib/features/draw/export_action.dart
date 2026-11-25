import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/event_export.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';

enum _ExportChoice { full, withoutAssignments }

/// Saves [event] as a JSON file. When names have been drawn, first asks
/// whether to include the assignments, since the file shows them in plain
/// text.
Future<void> exportEvent(
  BuildContext context,
  WidgetRef ref,
  Event event,
) async {
  final l10n = AppLocalizations.of(context);
  final repo = ref.read(eventsRepositoryProvider);
  final hasDraw = event.status != EventStatus.draft;

  var includeAssignments = false;
  if (hasDraw) {
    final choice = await showDialog<_ExportChoice>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber),
        title: Text(l10n.exportTitle),
        content: Text(l10n.exportBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(_ExportChoice.withoutAssignments),
            child: Text(l10n.exportWithoutAssignments),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_ExportChoice.full),
            child: Text(l10n.exportWithAssignments),
          ),
        ],
      ),
    );
    if (choice == null) return;
    includeAssignments = choice == _ExportChoice.full;
  }

  final participants = await repo.watchParticipants(event.id).first;
  final assignments =
      includeAssignments ? await repo.assignments(event.id) : null;
  final json = buildEventJson(
    event: event,
    participants: participants,
    assignments: assignments,
    exportedAt: DateTime.now(),
  );

  try {
    final uri = await FilePicker.saveFile(
      fileName: exportFileName(event),
      bytes: Uint8List.fromList(utf8.encode(json)),
      mimeType: 'application/json',
    );
    if (uri != null && context.mounted) showSnack(context, l10n.exportSaved);
  } catch (_) {
    if (context.mounted) showSnack(context, l10n.fileSaveError);
  }
}
