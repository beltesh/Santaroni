import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../core/email/builtin_templates.dart';
import '../../core/email/email_renderer.dart';
import '../../core/languages.dart';
import '../../core/util/currency.dart';
import '../../data/database.dart';
import '../../data/events_repository.dart';
import '../../l10n/app_localizations.dart';
import '../common/dialogs.dart';
import '../common/format.dart';
import '../templates/template_picker.dart';
import '../templates/templates_screen.dart';
import 'event_dates.dart';
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
  String? _dateError;
  TimeOfDay? _time;
  late String _currency;
  String? _language;
  int? _templateId;
  final _subject = TextEditingController();
  bool _subjectInitialized = false;
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
      text: e?.budgetMinor == null
          ? ''
          : _budgetText(e!.budgetMinor!, _currency),
    );
    _date = e?.eventDate;
    _time = parseTime(e?.eventTime);
    _language = e?.languageCode;
    _templateId = e?.templateId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // New events default to the app's current language.
    _language ??= appLanguage(context);
    if (!_subjectInitialized) {
      _subjectInitialized = true;
      _subject.text = widget.event?.emailSubject ?? defaultSubject(_language!);
    }
  }

  /// Switching language also switches the subject, unless it was edited.
  void _setLanguage(String language) {
    setState(() {
      if (_subject.text.trim() == defaultSubject(_language!)) {
        _subject.text = defaultSubject(language);
      }
      _language = language;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    _budget.dispose();
    _subject.dispose();
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
    // Past days are greyed out: events can only be scheduled from today on.
    final range = eventDatePickerRange(DateTime.now(), _date);
    final picked = await showDatePicker(
      context: context,
      initialDate: range.initial,
      firstDate: range.first,
      lastDate: range.last,
    );
    if (picked != null) {
      setState(() {
        _date = picked;
        _dateError = null;
      });
    }
  }

  /// A past date is only allowed if it's the date the event already had
  /// (editing an event that has happened, e.g. to fix a typo).
  bool _dateAllowed() =>
      _date == null ||
      !isPastDate(_date!, DateTime.now()) ||
      isSameDay(_date, widget.event?.eventDate);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final dateOk = _dateAllowed();
    setState(
      () => _dateError = dateOk
          ? null
          : AppLocalizations.of(context).eventDatePast,
    );
    if (!_formKey.currentState!.validate() || !dateOk) return;
    setState(() => _saving = true);

    final draft = EventDraft(
      name: _name.text,
      date: _date,
      time: _time == null ? null : timeToString(_time!),
      place: _place.text,
      budgetMinor: parseBudget(_budget.text, _currency),
      currency: _currency,
      languageCode: _language!,
      templateId: _templateId,
      // Store null for the default so it follows later language changes.
      emailSubject: _subject.text.trim() == defaultSubject(_language!)
          ? null
          : _subject.text,
    );
    final repo = ref.read(eventsRepositoryProvider);
    final navigator = Navigator.of(context);

    if (_isEditing) {
      try {
        await repo.updateEvent(widget.event!.id, draft);
      } on EventCompletedException {
        if (!mounted) return;
        setState(() => _saving = false);
        showSnack(context, AppLocalizations.of(context).eventCompletedError);
        return;
      }
      navigator.pop();
    } else {
      final id = await repo.createEvent(draft);
      navigator.pushReplacement(
        MaterialPageRoute<void>(builder: (_) => EventDetailScreen(eventId: id)),
      );
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
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.eventNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: l10n.eventDate,
                    icon: Icons.event_outlined,
                    help: l10n.eventDateHelp,
                    value: _date == null ? null : formatDate(context, _date!),
                    errorText: _dateError,
                    onTap: _pickDate,
                    onClear: () => setState(() {
                      _date = null;
                      _dateError = null;
                    }),
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
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.eventBudget,
                      hintText: l10n.optional,
                      prefixText: '${currencySymbol(_currency)} ',
                    ),
                    validator: (v) =>
                        (v != null &&
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
            DropdownButtonFormField<String>(
              initialValue: _language,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.emailLanguage,
                prefixIcon: const Icon(Icons.translate),
              ),
              items: [
                for (final code in supportedLanguages)
                  DropdownMenuItem(
                    value: code,
                    child: Text(languageEndonym(code)),
                  ),
              ],
              onChanged: (code) {
                if (code != null) _setLanguage(code);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subject,
              decoration: InputDecoration(
                labelText: l10n.emailSubject,
                prefixIcon: const Icon(Icons.subject),
                suffixIcon: Tooltip(
                  message: l10n.emailSubjectTooltip('{{EventName}}'),
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 6),
                  child: const Icon(Icons.help_outline),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return l10n.emailSubjectRequired;
                }
                final problem = checkSubject(v);
                return problem == null ? null : describeProblem(l10n, problem);
              },
            ),
            const SizedBox(height: 16),
            TemplatePicker(
              kind: TemplateKind.assignment,
              languageCode: _language!,
              value: _templateId,
              onChanged: (id) => setState(() => _templateId = id),
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
    this.errorText,
    this.help,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final IconData icon;
  final String? value;
  final String? errorText;

  /// Optional explanation, shown from a small help icon next to the label.
  final String? help;
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
          label: help == null
              ? Text(label)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(label, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 4),
                    Tooltip(
                      message: help,
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: const Duration(seconds: 6),
                      child: const Icon(Icons.help_outline, size: 16),
                    ),
                  ],
                ),
          hintText: l10n.optional,
          prefixIcon: Icon(icon),
          errorText: errorText,
          errorMaxLines: 2,
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
