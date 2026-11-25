// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Santaroni';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get edit => 'Edit';

  @override
  String get clear => 'Clear';

  @override
  String get optional => 'Optional';

  @override
  String get homeEmptyTitle => 'No events yet';

  @override
  String get homeEmptyBody => 'Create your first Secret Santa to get started.';

  @override
  String get newEvent => 'New Secret Santa';

  @override
  String participantCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
      zero: 'No participants',
    );
    return '$_temp0';
  }

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusGenerated => 'Names drawn';

  @override
  String get statusSending => 'Sending';

  @override
  String get statusSent => 'Sent';

  @override
  String get settings => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get eventFormEditTitle => 'Edit event';

  @override
  String get eventName => 'Event name';

  @override
  String get eventNameHint => 'e.g. Comic Book Group Secret Santa 2026';

  @override
  String get eventNameRequired => 'Please enter a name';

  @override
  String get eventDate => 'Date';

  @override
  String get eventTime => 'Time';

  @override
  String get eventPlace => 'Place';

  @override
  String get eventBudget => 'Max budget';

  @override
  String get eventCurrency => 'Currency';

  @override
  String get invalidAmount => 'Enter a valid amount';

  @override
  String get emailLanguage => 'Email language';

  @override
  String budgetUpTo(String amount) {
    return 'Budget: up to $amount';
  }

  @override
  String get eventDetailsEmpty => 'No date, place or budget yet.';

  @override
  String get deleteEventTitle => 'Delete this event?';

  @override
  String deleteEventBody(String name) {
    return '“$name” and all its participants will be permanently deleted.';
  }

  @override
  String get eventLockedBanner =>
      'Emails have been sent, so people can\'t be added or removed.';

  @override
  String get eventLockedError => 'Emails were already sent for this event.';

  @override
  String get participants => 'Participants';

  @override
  String get addParticipant => 'Add participant';

  @override
  String get importCsv => 'Import CSV';

  @override
  String get participantsEmpty => 'Add people one by one or import a CSV file.';

  @override
  String needMoreParticipants(int count) {
    return 'You need at least $count participants to draw names.';
  }

  @override
  String wishlistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wishes',
      one: '1 wish',
    );
    return '$_temp0';
  }

  @override
  String get participantFormEditTitle => 'Edit participant';

  @override
  String get participantName => 'Name';

  @override
  String get participantEmail => 'Email';

  @override
  String get participantGroup => 'Exclusion group';

  @override
  String get participantGroupHelp =>
      'People in the same group never draw each other, e.g. couples or roommates.';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get emailRequired => 'Please enter an email address';

  @override
  String get emailInvalid => 'That doesn\'t look like an email address';

  @override
  String get emailDuplicate => 'Someone in this event already uses this email';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get wishlistEmpty => 'No wishes yet.';

  @override
  String get wishlistItem => 'Item';

  @override
  String get wishlistLink => 'Link (optional)';

  @override
  String get addWishlistItem => 'Add item';

  @override
  String deleteParticipantTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get deleteParticipantBody => 'Their wishlist will be deleted too.';

  @override
  String get csvImportTitle => 'Import participants';

  @override
  String get csvIntro =>
      'Choose a CSV file with one participant per row. The first row must contain the column names. You can export one from Excel, Google Sheets or Google Forms.';

  @override
  String get csvColumnsRequired => 'Required columns: name, email';

  @override
  String get csvColumnsOptional => 'Optional columns: wishlist, group';

  @override
  String get csvWishlistTip =>
      'Put each wish on its own line inside the cell (Alt+Enter in most spreadsheets), or separate them with \" | \". Links at the end of a wish are detected automatically.';

  @override
  String get csvChooseFile => 'Choose CSV file';

  @override
  String get csvChooseAnother => 'Choose another';

  @override
  String get csvSaveExample => 'Save example file';

  @override
  String get csvExampleSaved => 'Example file saved';

  @override
  String get csvSaveError => 'Couldn\'t save the file.';

  @override
  String get csvReadError => 'Couldn\'t read that file.';

  @override
  String get csvColName => 'name';

  @override
  String get csvColEmail => 'email';

  @override
  String get csvColWishlist => 'wishlist';

  @override
  String get csvColGroup => 'group';

  @override
  String csvMissingColumns(String columns) {
    return 'This file is missing required columns: $columns';
  }

  @override
  String get csvNothingToImport => 'No participants found in this file.';

  @override
  String csvReady(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants ready to import',
      one: '1 participant ready to import',
    );
    return '$_temp0';
  }

  @override
  String csvSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rows skipped',
      one: '1 row skipped',
    );
    return '$_temp0';
  }

  @override
  String csvRowError(int row, String problem) {
    return 'Row $row: $problem';
  }

  @override
  String get csvProblemMissingName => 'missing name';

  @override
  String get csvProblemMissingEmail => 'missing email';

  @override
  String csvProblemInvalidEmail(String value) {
    return 'invalid email “$value”';
  }

  @override
  String csvProblemDuplicateEmail(String value) {
    return '“$value” is already in this event';
  }

  @override
  String csvImportButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count participants',
      one: 'Import 1 participant',
    );
    return '$_temp0';
  }

  @override
  String csvImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count participants',
      one: 'Imported 1 participant',
    );
    return '$_temp0';
  }
}
