import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/import/participant_csv.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';

/// Picks a CSV file, previews what will be imported, then imports it.
/// Pops with the number of participants imported.
class CsvImportScreen extends ConsumerStatefulWidget {
  const CsvImportScreen({super.key, required this.eventId});

  final int eventId;

  @override
  ConsumerState<CsvImportScreen> createState() => _CsvImportScreenState();
}

class _CsvImportScreenState extends ConsumerState<CsvImportScreen> {
  ParticipantCsvResult? _result;
  String? _fileName;
  bool _busy = false;

  Future<void> _pick() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'txt'],
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final existing = await ref
          .read(eventsRepositoryProvider)
          .emailsInEvent(widget.eventId);
      setState(() {
        _fileName = file.name;
        _result = ParticipantCsv.parseBytes(bytes, existingEmails: existing);
      });
    } catch (_) {
      if (mounted) showSnack(context, l10n.csvReadError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveExample() async {
    final l10n = AppLocalizations.of(context);
    final spanish = l10n.localeName.startsWith('es');
    final text = spanish
        ? 'nombre,correo,deseos,grupo\r\n'
            'Ana,ana@example.com,"Libro de cocina https://example.com/libro\r\n'
            'Calcetines navideños",familia-lopez\r\n'
            'Beto,beto@example.com,,familia-lopez\r\n'
            'Carla,carla@example.com,"Tarjeta de regalo | Taza https://example.com/taza",\r\n'
        : 'name,email,wishlist,group\r\n'
            'Alice,alice@example.com,"Saga Vol. 1 https://example.com/saga\r\n'
            'Any Moebius artbook",smith\r\n'
            'Bob,bob@example.com,,smith\r\n'
            'Carol,carol@example.com,"Gift card | Sandman Deluxe https://example.com/sandman",\r\n';
    try {
      final uri = await FilePicker.saveFile(
        fileName: spanish ? 'participantes-ejemplo.csv' : 'participants-example.csv',
        // BOM so Excel opens accented characters correctly.
        bytes: Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(text)]),
        mimeType: 'text/csv',
      );
      if (uri != null && mounted) showSnack(context, l10n.csvExampleSaved);
    } catch (_) {
      if (mounted) showSnack(context, l10n.csvSaveError);
    }
  }

  Future<void> _import() async {
    final result = _result!;
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final navigator = Navigator.of(context);
    try {
      await ref.read(eventsRepositoryProvider).importParticipants(
            widget.eventId,
            [
              for (final p in result.participants)
                ParticipantDraft(
                  name: p.name,
                  email: p.email,
                  groupTag: p.group,
                  wishlist: p.wishlist,
                ),
            ],
          );
      navigator.pop(result.participants.length);
    } on EventLockedException {
      if (mounted) showSnack(context, l10n.eventLockedError);
    } on DuplicateEmailException catch (e) {
      if (mounted) showSnack(context, l10n.csvProblemDuplicateEmail(e.email));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _result;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.csvImportTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (result == null) ...[
            _FormatHelp(onSaveExample: _saveExample),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _busy ? null : _pick,
              icon: const Icon(Icons.folder_open),
              label: Text(l10n.csvChooseFile),
            ),
          ] else ...[
            _FileHeader(
              fileName: _fileName ?? '',
              onChooseAnother: _busy ? null : _pick,
            ),
            const SizedBox(height: 16),
            ..._resultBody(context, result),
          ],
        ],
      ),
      bottomNavigationBar: result != null && result.isUsable
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _busy ? null : _import,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.csvImportButton(result.participants.length)),
                ),
              ),
            )
          : null,
    );
  }

  List<Widget> _resultBody(BuildContext context, ParticipantCsvResult result) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (result.missingColumns.isNotEmpty) {
      final names = result.missingColumns
          .map((c) => switch (c) {
                CsvColumn.name => l10n.csvColName,
                CsvColumn.email => l10n.csvColEmail,
                CsvColumn.wishlist => l10n.csvColWishlist,
                CsvColumn.group => l10n.csvColGroup,
              })
          .join(', ');
      return [
        _Message(
          icon: Icons.error_outline,
          color: theme.colorScheme.error,
          text: l10n.csvMissingColumns(names),
        ),
        const SizedBox(height: 16),
        _FormatHelp(onSaveExample: _saveExample),
      ];
    }

    return [
      if (result.participants.isEmpty)
        _Message(
          icon: Icons.error_outline,
          color: theme.colorScheme.error,
          text: l10n.csvNothingToImport,
        )
      else
        _Message(
          icon: Icons.check_circle_outline,
          color: theme.colorScheme.primary,
          text: l10n.csvReady(result.participants.length),
        ),
      if (result.errors.isNotEmpty) ...[
        const SizedBox(height: 8),
        Card(
          child: ExpansionTile(
            leading: Icon(Icons.warning_amber, color: theme.colorScheme.error),
            title: Text(l10n.csvSkipped(result.errors.length)),
            initiallyExpanded: result.errors.length <= 5,
            shape: const Border(),
            children: [
              for (final e in result.errors)
                ListTile(
                  dense: true,
                  title: Text(l10n.csvRowError(e.rowNumber, _problem(l10n, e))),
                ),
            ],
          ),
        ),
      ],
      if (result.participants.isNotEmpty) ...[
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (i, p) in result.participants.indexed) ...[
                if (i > 0) const Divider(height: 1),
                ListTile(
                  title: Text(p.name),
                  subtitle: Text(p.email),
                  trailing: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (p.group != null)
                        Chip(
                          avatar: const Icon(Icons.group_outlined, size: 16),
                          label: Text(p.group!),
                          visualDensity: VisualDensity.compact,
                        ),
                      if (p.wishlist.isNotEmpty)
                        Tooltip(
                          message: p.wishlist.map((w) => '• ${w.text}').join('\n'),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.card_giftcard,
                                  size: 18, color: theme.colorScheme.primary),
                              const SizedBox(width: 2),
                              Text('${p.wishlist.length}'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ];
  }

  String _problem(AppLocalizations l10n, CsvRowError e) => switch (e.problem) {
        CsvRowProblem.missingName => l10n.csvProblemMissingName,
        CsvRowProblem.missingEmail => l10n.csvProblemMissingEmail,
        CsvRowProblem.invalidEmail => l10n.csvProblemInvalidEmail(e.value ?? ''),
        CsvRowProblem.duplicateEmail =>
          l10n.csvProblemDuplicateEmail(e.value ?? ''),
      };
}

class _FormatHelp extends StatelessWidget {
  const _FormatHelp({required this.onSaveExample});

  final VoidCallback onSaveExample;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.csvIntro),
            const SizedBox(height: 12),
            Text(l10n.csvColumnsRequired, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(l10n.csvColumnsOptional, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            Text(l10n.csvWishlistTip),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton.icon(
                onPressed: onSaveExample,
                icon: const Icon(Icons.download),
                label: Text(l10n.csvSaveExample),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileHeader extends StatelessWidget {
  const _FileHeader({required this.fileName, required this.onChooseAnother});

  final String fileName;
  final VoidCallback? onChooseAnother;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        const Icon(Icons.description_outlined),
        const SizedBox(width: 8),
        Expanded(
          child: Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        TextButton(
          onPressed: onChooseAnother,
          child: Text(l10n.csvChooseAnother),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}
