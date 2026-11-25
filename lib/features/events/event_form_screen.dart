import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/util/currency.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/format.dart';
import 'event_detail_screen.dart';

/// Creates a new event, or edits [event] when given.
class EventFormScreen extends ConsumerStatefulWidget {
  const EventFormScreen({super.key, this.event});

  final Event? event;

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _place;
  late final TextEditingController _budget;
  DateTime? _date;
  TimeOfDay? _time;
  late String _currency;
  String? _language;
  bool _saving = false;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _name = TextEditingController(text: e?.name);
    _place = TextEditingController(text: e?.place);
    _currency = e?.currency ?? defaultCurrency;
    _budget = TextEditingController(
      text: e?.budgetMinor == null ? '' : _budgetText(e!.budgetMinor!, _currency),
    );
    _date = e?.eventDate;
    _time = parseTime(e?.eventTime);
    _language = e?.languageCode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // New events default to the app's current language.
    _language ??= Localizations.localeOf(context).languageCode == 'es' ? 'es' : 'en';
  }

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    _budget.dispose();
    super.dispose();
  }

  /// Plain number for editing, e.g. 2550 → "25.50", 2500 → "25".
  static String _budgetText(int minor, String currency) {
    final digits = currencyDecimalDigits(currency);
    var scale = 1;
    for (var i = 0; i < digits; i++) {
      scale *= 10;
    }
    if (minor % scale == 0) return '${minor ~/ scale}';
    return (minor / scale).toStringAsFixed(digits);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final christmasEve = DateTime(now.year, 12, 24);
    final initial = _date ?? (christmasEve.isBefore(now) ? now : christmasEve);
    var first = DateTime(now.year - 1);
    if (initial.isBefore(first)) first = initial;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final draft = EventDraft(
      name: _name.text,
      date: _date,
      time: _time == null ? null : timeToString(_time!),
      place: _place.text,
      budgetMinor: parseBudget(_budget.text, _currency),
      currency: _currency,
      languageCode: _language!,
    );
    final repo = ref.read(eventsRepositoryProvider);
    final navigator = Navigator.of(context);

    if (_isEditing) {
      await repo.updateEvent(widget.event!.id, draft);
      navigator.pop();
    } else {
      final id = await repo.createEvent(draft);
      navigator.pushReplacement(MaterialPageRoute<void>(
        builder: (_) => EventDetailScreen(eventId: id),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currencies = {...commonCurrencies, _currency}.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.eventFormEditTitle : l10n.newEvent),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.eventName,
                hintText: l10n.eventNameHint,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.eventNameRequired : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: l10n.eventDate,
                    icon: Icons.event_outlined,
                    value: _date == null ? null : formatDate(context, _date!),
                    onTap: _pickDate,
                    onClear: () => setState(() => _date = null),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerField(
                    label: l10n.eventTime,
                    icon: Icons.schedule_outlined,
                    value: _time == null ? null : formatTime(context, _time!),
                    onTap: _pickTime,
                    onClear: () => setState(() => _time = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _place,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.eventPlace,
                hintText: l10n.optional,
                prefixIcon: const Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _budget,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.eventBudget,
                      hintText: l10n.optional,
                      prefixText: '${currencySymbol(_currency)} ',
                    ),
                    validator: (v) => (v != null &&
                            v.trim().isNotEmpty &&
                            parseBudget(v, _currency) == null)
                        ? l10n.invalidAmount
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.eventCurrency),
                    items: [
                      for (final code in currencies)
                        DropdownMenuItem(
                          value: code,
                          child: Text('$code  ${currencySymbol(code)}'),
                        ),
                    ],
                    onChanged: (code) {
                      if (code != null) setState(() => _currency = code);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.emailLanguage, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
                ButtonSegment(value: 'es', label: Text(l10n.languageSpanish)),
              ],
              selected: {_language!},
              onSelectionChanged: (s) => setState(() => _language = s.first),
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

/// A tappable field that opens a picker, with a clear button once set.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final IconData icon;
  final String? value;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        isEmpty: value == null,
        decoration: InputDecoration(
          labelText: label,
          hintText: l10n.optional,
          prefixIcon: Icon(icon),
          suffixIcon: value == null
              ? null
              : IconButton(
                  tooltip: l10n.clear,
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
        ),
        child: Text(value ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
