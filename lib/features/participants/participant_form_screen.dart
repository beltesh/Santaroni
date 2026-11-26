import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/import/wishlist_parser.dart';
import '../../core/util/email.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';

/// Adds a participant to [eventId], or edits [existing].
class ParticipantFormScreen extends ConsumerStatefulWidget {
  const ParticipantFormScreen({
    super.key,
    required this.eventId,
    this.existing,
    this.knownGroups = const [],
  });

  final int eventId;
  final ParticipantWithWishlist? existing;

  /// Groups already used in this event, offered as quick picks.
  final List<String> knownGroups;

  @override
  ConsumerState<ParticipantFormScreen> createState() =>
      _ParticipantFormScreenState();
}

class _WishlistRow {
  _WishlistRow([String text = '', String? url])
    : text = TextEditingController(text: text),
      url = TextEditingController(text: url == text ? '' : url);

  final TextEditingController text;
  final TextEditingController url;
  final key = UniqueKey();

  void dispose() {
    text.dispose();
    url.dispose();
  }
}

class _ParticipantFormScreenState extends ConsumerState<ParticipantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _group;
  final _wishlist = <_WishlistRow>[];
  String? _emailError;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existing?.participant;
    _name = TextEditingController(text: p?.name);
    _email = TextEditingController(text: p?.email);
    _group = TextEditingController(text: p?.groupTag);
    for (final item in widget.existing?.wishlist ?? const []) {
      _wishlist.add(_WishlistRow(item.itemText, item.url));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _group.dispose();
    for (final row in _wishlist) {
      row.dispose();
    }
    super.dispose();
  }

  void _addWishlistRow() => setState(() => _wishlist.add(_WishlistRow()));

  void _removeWishlistRow(_WishlistRow row) {
    setState(() => _wishlist.remove(row));
    row.dispose();
  }

  /// Pasting "Book https://…" into the item field splits off the link.
  void _maybeSplitLink(_WishlistRow row) {
    if (row.url.text.isNotEmpty) return;
    final entry = parseWishlistItem(row.text.text.trim());
    if (entry.url != null && entry.text != entry.url) {
      row.text.text = entry.text;
      row.url.text = entry.url!;
    }
  }

  Future<void> _save() async {
    setState(() => _emailError = null);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final l10n = AppLocalizations.of(context);
    final draft = ParticipantDraft(
      name: _name.text,
      email: _email.text,
      groupTag: _group.text,
      wishlist: [
        for (final row in _wishlist)
          WishlistEntry(
            row.text.text.trim(),
            row.url.text.trim().isEmpty ? null : row.url.text.trim(),
          ),
      ],
    );
    final repo = ref.read(eventsRepositoryProvider);
    final navigator = Navigator.of(context);

    try {
      if (_isEditing) {
        await repo.updateParticipant(widget.existing!.participant.id, draft);
      } else {
        await repo.addParticipant(widget.eventId, draft);
      }
      navigator.pop();
    } on DuplicateEmailException {
      setState(() {
        _saving = false;
        _emailError = l10n.emailDuplicate;
      });
    } on EventLockedException {
      setState(() => _saving = false);
      if (mounted) showSnack(context, l10n.eventLockedError);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final p = widget.existing!.participant;
    final confirmed = await confirmDestructive(
      context,
      title: l10n.deleteParticipantTitle(p.name),
      body: l10n.deleteParticipantBody,
      confirmLabel: l10n.remove,
    );
    if (!confirmed || !mounted) return;
    final navigator = Navigator.of(context);
    try {
      await ref.read(eventsRepositoryProvider).deleteParticipant(p.id);
      navigator.pop();
    } on EventLockedException {
      if (mounted) showSnack(context, l10n.eventLockedError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.participantFormEditTitle : l10n.addParticipant,
        ),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: l10n.remove,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.participantName,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.nameRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.participantEmail,
                prefixIcon: const Icon(Icons.alternate_email),
                errorText: _emailError,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                if (!isValidEmail(v)) return l10n.emailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _group,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.participantGroup,
                hintText: l10n.optional,
                helperText: l10n.participantGroupHelp,
                helperMaxLines: 3,
                prefixIcon: const Icon(Icons.group_outlined),
              ),
            ),
            if (widget.knownGroups.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final g in widget.knownGroups)
                    ActionChip(
                      label: Text(g),
                      onPressed: () => setState(() => _group.text = g),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.wishlist,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addWishlistRow,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addWishlistItem),
                ),
              ],
            ),
            if (_wishlist.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.wishlistEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final row in _wishlist)
              Padding(
                key: row.key,
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Focus(
                            onFocusChange: (hasFocus) {
                              if (!hasFocus) _maybeSplitLink(row);
                            },
                            child: TextFormField(
                              controller: row.text,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: l10n.wishlistItem,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: row.url,
                            keyboardType: TextInputType.url,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: l10n.wishlistLink,
                              isDense: true,
                              prefixIcon: const Icon(Icons.link, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.remove,
                      icon: const Icon(Icons.close),
                      onPressed: () => _removeWishlistRow(row),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check),
              label: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
