import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The application name. Not translated.
  ///
  /// In en, this message translates to:
  /// **'Santaroni'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No events yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create your first Secret Santa to get started.'**
  String get homeEmptyBody;

  /// No description provided for @newEvent.
  ///
  /// In en, this message translates to:
  /// **'New Secret Santa'**
  String get newEvent;

  /// No description provided for @participantCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No participants} =1{1 participant} other{{count} participants}}'**
  String participantCount(int count);

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusGenerated.
  ///
  /// In en, this message translates to:
  /// **'Names drawn'**
  String get statusGenerated;

  /// No description provided for @statusSending.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get statusSending;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @eventFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get eventFormEditTitle;

  /// No description provided for @eventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get eventName;

  /// No description provided for @eventNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Comic Book Group Secret Santa 2026'**
  String get eventNameHint;

  /// No description provided for @eventNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get eventNameRequired;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDate;

  /// No description provided for @eventTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get eventTime;

  /// No description provided for @eventPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get eventPlace;

  /// No description provided for @eventBudget.
  ///
  /// In en, this message translates to:
  /// **'Max budget'**
  String get eventBudget;

  /// No description provided for @eventCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get eventCurrency;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidAmount;

  /// No description provided for @emailLanguage.
  ///
  /// In en, this message translates to:
  /// **'Email language'**
  String get emailLanguage;

  /// No description provided for @budgetUpTo.
  ///
  /// In en, this message translates to:
  /// **'Budget: up to {amount}'**
  String budgetUpTo(String amount);

  /// No description provided for @eventDetailsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No date, place or budget yet.'**
  String get eventDetailsEmpty;

  /// No description provided for @deleteEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this event?'**
  String get deleteEventTitle;

  /// No description provided for @deleteEventBody.
  ///
  /// In en, this message translates to:
  /// **'“{name}” and all its participants will be permanently deleted.'**
  String deleteEventBody(String name);

  /// No description provided for @eventLockedBanner.
  ///
  /// In en, this message translates to:
  /// **'Emails have been sent, so people can\'t be added or removed.'**
  String get eventLockedBanner;

  /// No description provided for @eventLockedError.
  ///
  /// In en, this message translates to:
  /// **'Emails were already sent for this event.'**
  String get eventLockedError;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @addParticipant.
  ///
  /// In en, this message translates to:
  /// **'Add participant'**
  String get addParticipant;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import CSV'**
  String get importCsv;

  /// No description provided for @participantsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add people one by one or import a CSV file.'**
  String get participantsEmpty;

  /// No description provided for @needMoreParticipants.
  ///
  /// In en, this message translates to:
  /// **'You need at least {count} participants to draw names.'**
  String needMoreParticipants(int count);

  /// No description provided for @wishlistCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 wish} other{{count} wishes}}'**
  String wishlistCount(int count);

  /// No description provided for @participantFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit participant'**
  String get participantFormEditTitle;

  /// No description provided for @participantName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get participantName;

  /// No description provided for @participantEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get participantEmail;

  /// No description provided for @participantGroup.
  ///
  /// In en, this message translates to:
  /// **'Exclusion group'**
  String get participantGroup;

  /// No description provided for @participantGroupHelp.
  ///
  /// In en, this message translates to:
  /// **'People in the same group never draw each other, e.g. couples or roommates.'**
  String get participantGroupHelp;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'That doesn\'t look like an email address'**
  String get emailInvalid;

  /// No description provided for @emailDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Someone in this event already uses this email'**
  String get emailDuplicate;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No wishes yet.'**
  String get wishlistEmpty;

  /// No description provided for @wishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get wishlistItem;

  /// No description provided for @wishlistLink.
  ///
  /// In en, this message translates to:
  /// **'Link (optional)'**
  String get wishlistLink;

  /// No description provided for @addWishlistItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addWishlistItem;

  /// No description provided for @deleteParticipantTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String deleteParticipantTitle(String name);

  /// No description provided for @deleteParticipantBody.
  ///
  /// In en, this message translates to:
  /// **'Their wishlist will be deleted too.'**
  String get deleteParticipantBody;

  /// No description provided for @csvImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import participants'**
  String get csvImportTitle;

  /// No description provided for @csvIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose a CSV file with one participant per row. The first row must contain the column names. You can export one from Excel, Google Sheets or Google Forms.'**
  String get csvIntro;

  /// No description provided for @csvColumnsRequired.
  ///
  /// In en, this message translates to:
  /// **'Required columns: name, email'**
  String get csvColumnsRequired;

  /// No description provided for @csvColumnsOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional columns: wishlist, group'**
  String get csvColumnsOptional;

  /// No description provided for @csvWishlistTip.
  ///
  /// In en, this message translates to:
  /// **'Put each wish on its own line inside the cell (Alt+Enter in most spreadsheets), or separate them with \" | \". Links at the end of a wish are detected automatically.'**
  String get csvWishlistTip;

  /// No description provided for @csvChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose CSV file'**
  String get csvChooseFile;

  /// No description provided for @csvChooseAnother.
  ///
  /// In en, this message translates to:
  /// **'Choose another'**
  String get csvChooseAnother;

  /// No description provided for @csvSaveExample.
  ///
  /// In en, this message translates to:
  /// **'Save example file'**
  String get csvSaveExample;

  /// No description provided for @csvExampleSaved.
  ///
  /// In en, this message translates to:
  /// **'Example file saved'**
  String get csvExampleSaved;

  /// No description provided for @csvSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the file.'**
  String get csvSaveError;

  /// No description provided for @csvReadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read that file.'**
  String get csvReadError;

  /// No description provided for @csvColName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get csvColName;

  /// No description provided for @csvColEmail.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get csvColEmail;

  /// No description provided for @csvColWishlist.
  ///
  /// In en, this message translates to:
  /// **'wishlist'**
  String get csvColWishlist;

  /// No description provided for @csvColGroup.
  ///
  /// In en, this message translates to:
  /// **'group'**
  String get csvColGroup;

  /// No description provided for @csvMissingColumns.
  ///
  /// In en, this message translates to:
  /// **'This file is missing required columns: {columns}'**
  String csvMissingColumns(String columns);

  /// No description provided for @csvNothingToImport.
  ///
  /// In en, this message translates to:
  /// **'No participants found in this file.'**
  String get csvNothingToImport;

  /// No description provided for @csvReady.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant ready to import} other{{count} participants ready to import}}'**
  String csvReady(int count);

  /// No description provided for @csvSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 row skipped} other{{count} rows skipped}}'**
  String csvSkipped(int count);

  /// No description provided for @csvRowError.
  ///
  /// In en, this message translates to:
  /// **'Row {row}: {problem}'**
  String csvRowError(int row, String problem);

  /// No description provided for @csvProblemMissingName.
  ///
  /// In en, this message translates to:
  /// **'missing name'**
  String get csvProblemMissingName;

  /// No description provided for @csvProblemMissingEmail.
  ///
  /// In en, this message translates to:
  /// **'missing email'**
  String get csvProblemMissingEmail;

  /// No description provided for @csvProblemInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'invalid email “{value}”'**
  String csvProblemInvalidEmail(String value);

  /// No description provided for @csvProblemDuplicateEmail.
  ///
  /// In en, this message translates to:
  /// **'“{value}” is already in this event'**
  String csvProblemDuplicateEmail(String value);

  /// No description provided for @csvImportButton.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 participant} other{Import {count} participants}}'**
  String csvImportButton(int count);

  /// No description provided for @csvImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported 1 participant} other{Imported {count} participants}}'**
  String csvImported(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
