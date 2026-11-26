import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/templates_repository.dart';
import '../../l10n/app_localizations.dart';
import 'templates_screen.dart';

/// Chooses a [kind] of email template: the built-in one for the event's
/// language (null) or an imported one of that kind. Templates with problems can be picked (they
/// may get fixed later) but are flagged, and sending refuses them.
class TemplatePicker extends ConsumerWidget {
  const TemplatePicker({
    super.key,
    required this.kind,
    required this.languageCode,
    required this.value,
    required this.onChanged,
  });

  final TemplateKind kind;
  final String languageCode;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final templates = ref.watch(templatesProvider);
    final custom = [
      for (final t in templates.value ?? const <EmailTemplate>[])
        if (t.kind == kind) t,
    ];
    // A deleted template falls back to the built-in one. Tell the form too,
    // so it doesn't save an id that no longer exists.
    final selected = custom.any((t) => t.id == value) ? value : null;
    if (templates.hasValue && value != null && selected == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onChanged(null));
    }
    final selectedHasProblem = custom
        .where((t) => t.id == selected)
        .any((t) => t.problem != null);

    return DropdownButtonFormField<int?>(
      key: ValueKey(Object.hash(selected, custom.length, languageCode)),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.emailTemplate,
        prefixIcon: const Icon(Icons.mail_outline),
        errorText: selectedHasProblem ? l10n.templateNeedsFixingLong : null,
        errorMaxLines: 3,
      ),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(builtinTemplateLabel(l10n, languageCode)),
        ),
        for (final t in custom)
          DropdownMenuItem(
            value: t.id,
            child: Text(
              t.problem == null
                  ? t.name
                  : '${t.name} — ${l10n.templateNeedsFixing}',
            ),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
