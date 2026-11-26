import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
    Locale('pt'),
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

  /// No description provided for @homeOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get homeOngoing;

  /// No description provided for @homeOngoingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing coming up. Create a new Secret Santa to get started.'**
  String get homeOngoingEmpty;

  /// No description provided for @homeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeCompleted;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markCompleted;

  /// No description provided for @markOngoing.
  ///
  /// In en, this message translates to:
  /// **'Move back to ongoing'**
  String get markOngoing;

  /// No description provided for @movedToCompleted.
  ///
  /// In en, this message translates to:
  /// **'Moved to Completed'**
  String get movedToCompleted;

  /// No description provided for @movedToOngoing.
  ///
  /// In en, this message translates to:
  /// **'Moved back to Ongoing'**
  String get movedToOngoing;

  /// No description provided for @completedReadOnlyDated.
  ///
  /// In en, this message translates to:
  /// **'This event is completed because its date has passed, so it can no longer be changed. You can still review the draw, export a backup or delete it.'**
  String get completedReadOnlyDated;

  /// No description provided for @completedReadOnlyArchived.
  ///
  /// In en, this message translates to:
  /// **'This event is marked as completed, so it can\'t be changed. To make changes, move it back to ongoing from the ⋮ menu.'**
  String get completedReadOnlyArchived;

  /// No description provided for @completedDrawBody.
  ///
  /// In en, this message translates to:
  /// **'The draw is kept for reference. You can still review it or export a backup.'**
  String get completedDrawBody;

  /// No description provided for @eventCompletedError.
  ///
  /// In en, this message translates to:
  /// **'This event is completed and can\'t be changed.'**
  String get eventCompletedError;

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

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get themeLight;

  /// No description provided for @themeFestiveDark.
  ///
  /// In en, this message translates to:
  /// **'Festive Dark'**
  String get themeFestiveDark;

  /// No description provided for @themeFestiveLight.
  ///
  /// In en, this message translates to:
  /// **'Festive Light'**
  String get themeFestiveLight;

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

  /// No description provided for @eventDatePast.
  ///
  /// In en, this message translates to:
  /// **'Pick today or a later date.'**
  String get eventDatePast;

  /// No description provided for @eventDateHelp.
  ///
  /// In en, this message translates to:
  /// **'Events move to Completed automatically once this date has passed.'**
  String get eventDateHelp;

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

  /// No description provided for @removeAllParticipants.
  ///
  /// In en, this message translates to:
  /// **'Remove all'**
  String get removeAllParticipants;

  /// No description provided for @removeAllParticipantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove all participants?'**
  String get removeAllParticipantsTitle;

  /// No description provided for @removeAllParticipantsBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant and their wishlist will be removed.} other{All {count} participants and their wishlists will be removed.}}'**
  String removeAllParticipantsBody(int count);

  /// No description provided for @removeAllCancelsDraw.
  ///
  /// In en, this message translates to:
  /// **'The current draw will be cancelled too.'**
  String get removeAllCancelsDraw;

  /// No description provided for @rosterChangeCancelsDraw.
  ///
  /// In en, this message translates to:
  /// **'Adding or removing people, or changing groups, will cancel the current draw.'**
  String get rosterChangeCancelsDraw;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @drawNames.
  ///
  /// In en, this message translates to:
  /// **'Draw names'**
  String get drawNames;

  /// No description provided for @drawReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to draw names'**
  String get drawReadyTitle;

  /// No description provided for @drawReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone will be linked in one single loop, so each person gives one gift and gets one gift. No emails are sent yet.'**
  String get drawReadyBody;

  /// No description provided for @drawDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Names drawn'**
  String get drawDoneTitle;

  /// No description provided for @drawDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Review the draw or save a backup. No emails have been sent yet.'**
  String get drawDoneBody;

  /// No description provided for @drawDoneSnack.
  ///
  /// In en, this message translates to:
  /// **'Names drawn'**
  String get drawDoneSnack;

  /// No description provided for @reviewDraw.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewDraw;

  /// No description provided for @redraw.
  ///
  /// In en, this message translates to:
  /// **'Redraw'**
  String get redraw;

  /// No description provided for @redrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw names again?'**
  String get redrawTitle;

  /// No description provided for @redrawBody.
  ///
  /// In en, this message translates to:
  /// **'The current draw will be replaced with a completely new one.'**
  String get redrawBody;

  /// No description provided for @drawErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Can\'t draw names'**
  String get drawErrorTitle;

  /// No description provided for @drawErrorExclusions.
  ///
  /// In en, this message translates to:
  /// **'These exclusion groups make a draw impossible. A group can include at most half of the participants.'**
  String get drawErrorExclusions;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review draw'**
  String get reviewTitle;

  /// No description provided for @reviewHiddenHint.
  ///
  /// In en, this message translates to:
  /// **'Names are hidden so you can take part too. Tap a row or its eye icon to reveal it.'**
  String get reviewHiddenHint;

  /// No description provided for @drawVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified: everyone gives and receives exactly once, in a single loop.'**
  String get drawVerified;

  /// No description provided for @drawInvalid.
  ///
  /// In en, this message translates to:
  /// **'This draw failed verification. Please redraw.'**
  String get drawInvalid;

  /// No description provided for @givesTo.
  ///
  /// In en, this message translates to:
  /// **'gives to'**
  String get givesTo;

  /// No description provided for @hiddenName.
  ///
  /// In en, this message translates to:
  /// **'Hidden name'**
  String get hiddenName;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @hideAll.
  ///
  /// In en, this message translates to:
  /// **'Hide all'**
  String get hideAll;

  /// No description provided for @emailTemplates.
  ///
  /// In en, this message translates to:
  /// **'Email templates'**
  String get emailTemplates;

  /// No description provided for @emailTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your own text or HTML email design'**
  String get emailTemplatesSubtitle;

  /// No description provided for @emailTemplate.
  ///
  /// In en, this message translates to:
  /// **'Email template'**
  String get emailTemplate;

  /// No description provided for @emailSubject.
  ///
  /// In en, this message translates to:
  /// **'Email subject'**
  String get emailSubject;

  /// No description provided for @emailSubjectTooltip.
  ///
  /// In en, this message translates to:
  /// **'Use {tag} anywhere in the subject to insert the event name.'**
  String emailSubjectTooltip(String tag);

  /// No description provided for @emailSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject'**
  String get emailSubjectRequired;

  /// No description provided for @templatesIntro.
  ///
  /// In en, this message translates to:
  /// **'Every email is built from a template. Import your own .html or .txt file with variables like the ones listed below; Santaroni fills them in for each participant.'**
  String get templatesIntro;

  /// No description provided for @templatesBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get templatesBuiltIn;

  /// No description provided for @templatesImported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get templatesImported;

  /// No description provided for @templatesImportedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No imported templates yet.'**
  String get templatesImportedEmpty;

  /// No description provided for @builtinTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Default ({language})'**
  String builtinTemplateName(String language);

  /// No description provided for @builtinTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'HTML email, used unless an event picks another template'**
  String get builtinTemplateSubtitle;

  /// No description provided for @builtinTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'A festive HTML email with all the event details and the recipient\'s wishlist. A plain-text version is sent along with it, for email apps that can\'t show HTML and to help keep it out of spam. Save a copy to use it as the starting point for your own design.'**
  String get builtinTemplateDescription;

  /// No description provided for @saveTemplateCopy.
  ///
  /// In en, this message translates to:
  /// **'Save a copy to customize'**
  String get saveTemplateCopy;

  /// No description provided for @templateCopySaved.
  ///
  /// In en, this message translates to:
  /// **'Template saved. Edit it, then import it here.'**
  String get templateCopySaved;

  /// No description provided for @importTemplate.
  ///
  /// In en, this message translates to:
  /// **'Import template'**
  String get importTemplate;

  /// No description provided for @formatHtml.
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get formatHtml;

  /// No description provided for @formatText.
  ///
  /// In en, this message translates to:
  /// **'Plain text'**
  String get formatText;

  /// No description provided for @templateImportedOn.
  ///
  /// In en, this message translates to:
  /// **'imported {date}'**
  String templateImportedOn(String date);

  /// No description provided for @templateImported.
  ///
  /// In en, this message translates to:
  /// **'Imported “{name}”'**
  String templateImported(String name);

  /// No description provided for @templateImportedWithProblem.
  ///
  /// In en, this message translates to:
  /// **'Imported “{name}”, but it needs fixing before it can be used.'**
  String templateImportedWithProblem(String name);

  /// No description provided for @templateReplaced.
  ///
  /// In en, this message translates to:
  /// **'Template updated'**
  String get templateReplaced;

  /// No description provided for @templateUnsupportedFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a .html or .txt file.'**
  String get templateUnsupportedFile;

  /// No description provided for @replaceFile.
  ///
  /// In en, this message translates to:
  /// **'Replace with a new file'**
  String get replaceFile;

  /// No description provided for @templateNeedsFixing.
  ///
  /// In en, this message translates to:
  /// **'needs fixing'**
  String get templateNeedsFixing;

  /// No description provided for @templateNeedsFixingLong.
  ///
  /// In en, this message translates to:
  /// **'This template has a problem, so emails can\'t be sent until it\'s fixed. See Settings › Email templates.'**
  String get templateNeedsFixingLong;

  /// No description provided for @templateCannotSend.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be used to send emails until fixed'**
  String get templateCannotSend;

  /// No description provided for @templateUnknownVariable.
  ///
  /// In en, this message translates to:
  /// **'{tag} on line {line} isn\'t a variable Santaroni knows. Check the spelling against the list of variables.'**
  String templateUnknownVariable(String tag, int line);

  /// No description provided for @templateSyntaxError.
  ///
  /// In en, this message translates to:
  /// **'The template couldn\'t be read: {message}'**
  String templateSyntaxError(String message);

  /// No description provided for @templateSyntaxErrorAt.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: {message}'**
  String templateSyntaxErrorAt(int line, String message);

  /// No description provided for @previewSample.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get previewSample;

  /// No description provided for @previewPlainVersion.
  ///
  /// In en, this message translates to:
  /// **'Plain-text version'**
  String get previewPlainVersion;

  /// No description provided for @previewHtmlNote.
  ///
  /// In en, this message translates to:
  /// **'This is the text sent alongside the HTML. To see the HTML itself, send yourself a test email.'**
  String get previewHtmlNote;

  /// No description provided for @templateVariablesTitle.
  ///
  /// In en, this message translates to:
  /// **'Variables you can use'**
  String get templateVariablesTitle;

  /// No description provided for @templateVariablesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write these in your template file'**
  String get templateVariablesSubtitle;

  /// No description provided for @varEventName.
  ///
  /// In en, this message translates to:
  /// **'Event name'**
  String get varEventName;

  /// No description provided for @varEventWhen.
  ///
  /// In en, this message translates to:
  /// **'Date and time together, whichever are set'**
  String get varEventWhen;

  /// No description provided for @varEventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get varEventDate;

  /// No description provided for @varEventTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get varEventTime;

  /// No description provided for @varEventPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get varEventPlace;

  /// No description provided for @varBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget, with currency symbol'**
  String get varBudget;

  /// No description provided for @varGiverName.
  ///
  /// In en, this message translates to:
  /// **'Name of the person this email is for'**
  String get varGiverName;

  /// No description provided for @varGiverEmail.
  ///
  /// In en, this message translates to:
  /// **'Their email address'**
  String get varGiverEmail;

  /// No description provided for @varRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Who they\'re giving a gift to'**
  String get varRecipientName;

  /// No description provided for @varOrganizerName.
  ///
  /// In en, this message translates to:
  /// **'Your sender name'**
  String get varOrganizerName;

  /// No description provided for @varHasDetails.
  ///
  /// In en, this message translates to:
  /// **'Section shown when there\'s a date, place or budget'**
  String get varHasDetails;

  /// No description provided for @varHasWishlist.
  ///
  /// In en, this message translates to:
  /// **'Section shown when the recipient has a wishlist'**
  String get varHasWishlist;

  /// No description provided for @varWishlist.
  ///
  /// In en, this message translates to:
  /// **'Repeats for each wishlist item, with Text and Url'**
  String get varWishlist;

  /// No description provided for @deleteTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this template?'**
  String get deleteTemplateTitle;

  /// No description provided for @deleteTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'Events using it will go back to the default template.'**
  String get deleteTemplateBody;

  /// No description provided for @emailAccount.
  ///
  /// In en, this message translates to:
  /// **'Email account'**
  String get emailAccount;

  /// No description provided for @emailAccountNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Not set up yet'**
  String get emailAccountNotSetUp;

  /// No description provided for @emailProvider.
  ///
  /// In en, this message translates to:
  /// **'Email provider'**
  String get emailProvider;

  /// No description provided for @providerGmail.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get providerGmail;

  /// No description provided for @providerCustom.
  ///
  /// In en, this message translates to:
  /// **'Other (SMTP server)'**
  String get providerCustom;

  /// No description provided for @gmailHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Gmail needs an app password'**
  String get gmailHelpTitle;

  /// No description provided for @gmailHelpStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Turn on 2-Step Verification for your Google account.'**
  String get gmailHelpStep1;

  /// No description provided for @gmailHelpStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Create an app password (name it “Santaroni”) at:'**
  String get gmailHelpStep2;

  /// No description provided for @gmailHelpStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Paste the 16-letter code below. Your normal Gmail password won\'t work.'**
  String get gmailHelpStep3;

  /// No description provided for @sentFolderWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Taking part yourself?'**
  String get sentFolderWarningTitle;

  /// No description provided for @sentFolderWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Gmail keeps a copy of every email in your Sent folder, so you\'d see everyone\'s assignments there. Use a separate free Gmail account just for the exchange.'**
  String get sentFolderWarningBody;

  /// No description provided for @senderName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get senderName;

  /// No description provided for @senderNameHelp.
  ///
  /// In en, this message translates to:
  /// **'Shown as the sender, and in templates as the organizer name'**
  String get senderNameHelp;

  /// No description provided for @senderAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get senderAddress;

  /// No description provided for @appPassword.
  ///
  /// In en, this message translates to:
  /// **'App password'**
  String get appPassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Saved. Leave empty to keep it.'**
  String get passwordSavedHint;

  /// No description provided for @passwordStorageNote.
  ///
  /// In en, this message translates to:
  /// **'Stored securely in this device\'s keychain, never in the app\'s database or backups.'**
  String get passwordStorageNote;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the password'**
  String get passwordRequired;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get serverSettings;

  /// No description provided for @smtpHost.
  ///
  /// In en, this message translates to:
  /// **'SMTP server'**
  String get smtpHost;

  /// No description provided for @smtpHostRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the server name'**
  String get smtpHostRequired;

  /// No description provided for @smtpPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get smtpPort;

  /// No description provided for @smtpPortInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid port'**
  String get smtpPortInvalid;

  /// No description provided for @smtpSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get smtpSecurity;

  /// No description provided for @securityStartTls.
  ///
  /// In en, this message translates to:
  /// **'STARTTLS (port 587)'**
  String get securityStartTls;

  /// No description provided for @securitySsl.
  ///
  /// In en, this message translates to:
  /// **'SSL/TLS (port 465)'**
  String get securitySsl;

  /// No description provided for @accountSaved.
  ///
  /// In en, this message translates to:
  /// **'Email account saved'**
  String get accountSaved;

  /// No description provided for @forgetAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get forgetAccount;

  /// No description provided for @forgetAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this email account?'**
  String get forgetAccountTitle;

  /// No description provided for @forgetAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Its settings and saved password will be deleted from this device. Your events are not affected.'**
  String get forgetAccountBody;

  /// No description provided for @sendTestEmail.
  ///
  /// In en, this message translates to:
  /// **'Send me a test email'**
  String get sendTestEmail;

  /// No description provided for @sendingTestEmail.
  ///
  /// In en, this message translates to:
  /// **'Sending test email…'**
  String get sendingTestEmail;

  /// No description provided for @testEmailPrefix.
  ///
  /// In en, this message translates to:
  /// **'[Test] '**
  String get testEmailPrefix;

  /// No description provided for @testEmailSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Test email sent'**
  String get testEmailSentTitle;

  /// No description provided for @testEmailSentBody.
  ///
  /// In en, this message translates to:
  /// **'Check the inbox of {address}. It can take a minute to arrive.'**
  String testEmailSentBody(String address);

  /// No description provided for @testEmailFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the email'**
  String get testEmailFailedTitle;

  /// No description provided for @accountNotReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Email account needed'**
  String get accountNotReadyTitle;

  /// No description provided for @accountNotReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Set up the account to send from first: your email address and its password.'**
  String get accountNotReadyBody;

  /// No description provided for @setUpAccount.
  ///
  /// In en, this message translates to:
  /// **'Set up account'**
  String get setUpAccount;

  /// No description provided for @sendErrorAuthGmail.
  ///
  /// In en, this message translates to:
  /// **'Gmail didn\'t accept the password. Make sure it\'s an app password (not your normal Gmail password) and that 2-Step Verification is on.'**
  String get sendErrorAuthGmail;

  /// No description provided for @sendErrorAuth.
  ///
  /// In en, this message translates to:
  /// **'The server didn\'t accept the email address or password.'**
  String get sendErrorAuth;

  /// No description provided for @sendErrorConnection.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the email server. Check your internet connection, and the server name and port if you entered them.'**
  String get sendErrorConnection;

  /// No description provided for @sendErrorRejected.
  ///
  /// In en, this message translates to:
  /// **'The server refused the email: {detail}'**
  String sendErrorRejected(String detail);

  /// No description provided for @sendErrorOther.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while sending: {detail}'**
  String sendErrorOther(String detail);

  /// No description provided for @accountReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to send'**
  String get accountReadyTitle;

  /// No description provided for @accountSetUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up email'**
  String get accountSetUpTitle;

  /// No description provided for @accountSetUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Needed to send assignments'**
  String get accountSetUpSubtitle;

  /// No description provided for @accountNeededBanner.
  ///
  /// In en, this message translates to:
  /// **'Set up the email account you\'ll send these assignments from.'**
  String get accountNeededBanner;

  /// No description provided for @templatesShortcutDefault.
  ///
  /// In en, this message translates to:
  /// **'Using the default design'**
  String get templatesShortcutDefault;

  /// No description provided for @templatesShortcutImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 imported} other{{count} imported}}'**
  String templatesShortcutImported(int count);

  /// No description provided for @sendEmails.
  ///
  /// In en, this message translates to:
  /// **'Send emails'**
  String get sendEmails;

  /// No description provided for @emailStatus.
  ///
  /// In en, this message translates to:
  /// **'Email status'**
  String get emailStatus;

  /// No description provided for @sendPartlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Some emails haven\'t gone out'**
  String get sendPartlyTitle;

  /// No description provided for @sendPartlyBody.
  ///
  /// In en, this message translates to:
  /// **'Open Email status to send the rest or retry the ones that failed.'**
  String get sendPartlyBody;

  /// No description provided for @allEmailsSent.
  ///
  /// In en, this message translates to:
  /// **'All emails sent'**
  String get allEmailsSent;

  /// No description provided for @sentBody.
  ///
  /// In en, this message translates to:
  /// **'Everyone has their assignment. If someone lost their email, you can resend it from Email status.'**
  String get sentBody;

  /// No description provided for @sendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send assignments'**
  String get sendTitle;

  /// No description provided for @checkAccountReady.
  ///
  /// In en, this message translates to:
  /// **'Email account is ready'**
  String get checkAccountReady;

  /// No description provided for @checkAccountMissing.
  ///
  /// In en, this message translates to:
  /// **'Email account isn\'t set up'**
  String get checkAccountMissing;

  /// No description provided for @checkTemplateReady.
  ///
  /// In en, this message translates to:
  /// **'Subject and template are ready'**
  String get checkTemplateReady;

  /// No description provided for @checkTemplateProblem.
  ///
  /// In en, this message translates to:
  /// **'The subject or template needs fixing'**
  String get checkTemplateProblem;

  /// No description provided for @checkDrawReady.
  ///
  /// In en, this message translates to:
  /// **'Names drawn and verified'**
  String get checkDrawReady;

  /// No description provided for @sentOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{sent} of {total} sent'**
  String sentOfTotal(int sent, int total);

  /// No description provided for @failedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 email failed} other{{count} emails failed}}'**
  String failedCount(int count);

  /// No description provided for @sendingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Sending… you can leave this screen; it keeps going.'**
  String get sendingInProgress;

  /// No description provided for @sendAllButton.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send 1 email} other{Send {count} emails}}'**
  String sendAllButton(int count);

  /// No description provided for @sendRemainingButton.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send the remaining email} other{Send the remaining {count}}}'**
  String sendRemainingButton(int count);

  /// No description provided for @retryFailedButton.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Retry the failed email} other{Retry {count} failed}}'**
  String retryFailedButton(int count);

  /// No description provided for @sendMePreview.
  ///
  /// In en, this message translates to:
  /// **'Send me a preview'**
  String get sendMePreview;

  /// No description provided for @sendPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'The preview uses this event\'s details with made-up names, so it doesn\'t reveal anyone\'s assignment. Only who receives each email is listed below.'**
  String get sendPrivacyNote;

  /// No description provided for @sendConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Send 1 email?} other{Send {count} emails?}}'**
  String sendConfirmTitle(int count);

  /// No description provided for @sendConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Each participant gets their assignment from {from}. Once emails go out, people can no longer be added or removed.'**
  String sendConfirmBody(String from);

  /// No description provided for @sendNow.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendNow;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @stopping.
  ///
  /// In en, this message translates to:
  /// **'Stopping…'**
  String get stopping;

  /// No description provided for @sendBlocked.
  ///
  /// In en, this message translates to:
  /// **'Fix the items marked in the checklist first.'**
  String get sendBlocked;

  /// No description provided for @sendFinished.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 email sent} other{{count} emails sent}}'**
  String sendFinished(int count);

  /// No description provided for @sendFinishedWithFailures.
  ///
  /// In en, this message translates to:
  /// **'{sent} sent, {failed} failed. You can retry the failed ones.'**
  String sendFinishedWithFailures(int sent, int failed);

  /// No description provided for @sendStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped after {count} sent. The rest are waiting.'**
  String sendStopped(int count);

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendTitle.
  ///
  /// In en, this message translates to:
  /// **'Resend to {name}?'**
  String resendTitle(String name);

  /// No description provided for @resendBody.
  ///
  /// In en, this message translates to:
  /// **'They\'ll get their assignment again at {email}. You won\'t see who it is.'**
  String resendBody(String email);

  /// No description provided for @statusSendingNow.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get statusSendingNow;

  /// No description provided for @statusEmailPending.
  ///
  /// In en, this message translates to:
  /// **'Not sent yet'**
  String get statusEmailPending;

  /// No description provided for @statusEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusEmailSent;

  /// No description provided for @statusEmailSentAt.
  ///
  /// In en, this message translates to:
  /// **'Sent {when}'**
  String statusEmailSentAt(String when);

  /// No description provided for @statusEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String statusEmailFailed(String error);

  /// No description provided for @exportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportJson;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Save a backup'**
  String get exportTitle;

  /// No description provided for @exportBody.
  ///
  /// In en, this message translates to:
  /// **'A full backup includes who gives to whom, in plain text. Anyone who opens the file will see every assignment, including yours.'**
  String get exportBody;

  /// No description provided for @exportWithAssignments.
  ///
  /// In en, this message translates to:
  /// **'Full backup'**
  String get exportWithAssignments;

  /// No description provided for @exportWithoutAssignments.
  ///
  /// In en, this message translates to:
  /// **'Without assignments'**
  String get exportWithoutAssignments;

  /// No description provided for @exportSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get exportSaved;

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

  /// No description provided for @fileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the file.'**
  String get fileSaveError;

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

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @cancelEventMenu.
  ///
  /// In en, this message translates to:
  /// **'Cancel event…'**
  String get cancelEventMenu;

  /// No description provided for @cancelEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel “{name}”?'**
  String cancelEventTitle(String name);

  /// No description provided for @cancelEventBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelling is final: the event moves to Completed and can no longer be changed.'**
  String get cancelEventBody;

  /// No description provided for @cancelNotify.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Email the participant} other{Email all {count} participants}}'**
  String cancelNotify(int count);

  /// No description provided for @cancelNotifyNone.
  ///
  /// In en, this message translates to:
  /// **'There are no participants to email.'**
  String get cancelNotifyNone;

  /// No description provided for @cancelNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get cancelNoteLabel;

  /// No description provided for @cancelNoteHelp.
  ///
  /// In en, this message translates to:
  /// **'Included in the email, e.g. why, or what happens next.'**
  String get cancelNoteHelp;

  /// No description provided for @cancelAccountNeeded.
  ///
  /// In en, this message translates to:
  /// **'To email participants, set up your email account first, or turn off the emails.'**
  String get cancelAccountNeeded;

  /// No description provided for @cancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel event'**
  String get cancelConfirm;

  /// No description provided for @keepEvent.
  ///
  /// In en, this message translates to:
  /// **'Keep event'**
  String get keepEvent;

  /// No description provided for @eventCancelledSnack.
  ///
  /// In en, this message translates to:
  /// **'Event cancelled'**
  String get eventCancelledSnack;

  /// No description provided for @cancelledReadOnly.
  ///
  /// In en, this message translates to:
  /// **'This event was cancelled on {date}, so it can no longer be changed. You can still review it, export a backup or delete it.'**
  String cancelledReadOnly(String date);

  /// No description provided for @cancelNoticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation emails'**
  String get cancelNoticesTitle;

  /// No description provided for @cancelNoticesNone.
  ///
  /// In en, this message translates to:
  /// **'Participants weren’t emailed about the cancellation.'**
  String get cancelNoticesNone;

  /// No description provided for @cancelResendBody.
  ///
  /// In en, this message translates to:
  /// **'They’ll get the cancellation email again at {email}.'**
  String cancelResendBody(String email);

  /// No description provided for @templatesTabAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get templatesTabAssignment;

  /// No description provided for @templatesTabCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get templatesTabCancellation;

  /// No description provided for @templateKindAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment email'**
  String get templateKindAssignment;

  /// No description provided for @templateKindCancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation email'**
  String get templateKindCancellation;

  /// No description provided for @templatesIntroCancellation.
  ///
  /// In en, this message translates to:
  /// **'Sent to every participant when you cancel an event. Import your own .html or .txt file with variables like the ones listed below, then pick it when cancelling.'**
  String get templatesIntroCancellation;

  /// No description provided for @builtinCancellationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'HTML email, used unless you pick another one when cancelling'**
  String get builtinCancellationSubtitle;

  /// No description provided for @builtinCancellationDescription.
  ///
  /// In en, this message translates to:
  /// **'The same festive design, letting everyone know the event was cancelled, with the event details and your note if you write one. A plain-text version is sent along with it. Save a copy to use it as the starting point for your own design.'**
  String get builtinCancellationDescription;

  /// No description provided for @varNote.
  ///
  /// In en, this message translates to:
  /// **'Your note about the cancellation, when you write one'**
  String get varNote;

  /// No description provided for @varHasDetailsCancellation.
  ///
  /// In en, this message translates to:
  /// **'Section shown when there’s a date or place'**
  String get varHasDetailsCancellation;
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

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
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
