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
  String get themeModeSystem => 'System';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeDark => 'Dark theme';

  @override
  String get themeLight => 'Light theme';

  @override
  String get themeFestiveDark => 'Festive Dark';

  @override
  String get themeFestiveLight => 'Festive Light';

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
  String get removeAllParticipants => 'Remove all';

  @override
  String get removeAllParticipantsTitle => 'Remove all participants?';

  @override
  String removeAllParticipantsBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'All $count participants and their wishlists will be removed.',
      one: '1 participant and their wishlist will be removed.',
    );
    return '$_temp0';
  }

  @override
  String get removeAllCancelsDraw => 'The current draw will be cancelled too.';

  @override
  String get rosterChangeCancelsDraw =>
      'Adding or removing people, or changing groups, will cancel the current draw.';

  @override
  String get ok => 'OK';

  @override
  String get drawNames => 'Draw names';

  @override
  String get drawReadyTitle => 'Ready to draw names';

  @override
  String get drawReadyBody =>
      'Everyone will be linked in one single loop, so each person gives one gift and gets one gift. No emails are sent yet.';

  @override
  String get drawDoneTitle => 'Names drawn';

  @override
  String get drawDoneBody =>
      'Review the draw or save a backup. No emails have been sent yet.';

  @override
  String get drawDoneSnack => 'Names drawn';

  @override
  String get reviewDraw => 'Review';

  @override
  String get redraw => 'Redraw';

  @override
  String get redrawTitle => 'Draw names again?';

  @override
  String get redrawBody =>
      'The current draw will be replaced with a completely new one.';

  @override
  String get drawErrorTitle => 'Can\'t draw names';

  @override
  String get drawErrorExclusions =>
      'These exclusion groups make a draw impossible. A group can include at most half of the participants.';

  @override
  String get reviewTitle => 'Review draw';

  @override
  String get reviewHiddenHint =>
      'Names are hidden so you can take part too. Tap a row or its eye icon to reveal it.';

  @override
  String get drawVerified =>
      'Verified: everyone gives and receives exactly once, in a single loop.';

  @override
  String get drawInvalid => 'This draw failed verification. Please redraw.';

  @override
  String get givesTo => 'gives to';

  @override
  String get hiddenName => 'Hidden name';

  @override
  String get show => 'Show';

  @override
  String get hide => 'Hide';

  @override
  String get showAll => 'Show all';

  @override
  String get hideAll => 'Hide all';

  @override
  String get emailTemplates => 'Email templates';

  @override
  String get emailTemplatesSubtitle => 'Use your own text or HTML email design';

  @override
  String get emailTemplate => 'Email template';

  @override
  String get emailSubject => 'Email subject';

  @override
  String emailSubjectTooltip(String tag) {
    return 'Use $tag anywhere in the subject to insert the event name.';
  }

  @override
  String get emailSubjectRequired => 'Please enter a subject';

  @override
  String get templatesIntro =>
      'Every email is built from a template. Import your own .html or .txt file with variables like the ones listed below; Santaroni fills them in for each participant.';

  @override
  String get templatesBuiltIn => 'Built-in';

  @override
  String get templatesImported => 'Imported';

  @override
  String get templatesImportedEmpty => 'No imported templates yet.';

  @override
  String builtinTemplateName(String language) {
    return 'Default ($language)';
  }

  @override
  String get builtinTemplateSubtitle =>
      'HTML email, used unless an event picks another template';

  @override
  String get builtinTemplateDescription =>
      'A festive HTML email with all the event details and the recipient\'s wishlist. A plain-text version is sent along with it, for email apps that can\'t show HTML and to help keep it out of spam. Save a copy to use it as the starting point for your own design.';

  @override
  String get saveTemplateCopy => 'Save a copy to customize';

  @override
  String get templateCopySaved =>
      'Template saved. Edit it, then import it here.';

  @override
  String get importTemplate => 'Import template';

  @override
  String get formatHtml => 'HTML';

  @override
  String get formatText => 'Plain text';

  @override
  String templateImportedOn(String date) {
    return 'imported $date';
  }

  @override
  String templateImported(String name) {
    return 'Imported “$name”';
  }

  @override
  String templateImportedWithProblem(String name) {
    return 'Imported “$name”, but it needs fixing before it can be used.';
  }

  @override
  String get templateReplaced => 'Template updated';

  @override
  String get templateUnsupportedFile => 'Choose a .html or .txt file.';

  @override
  String get replaceFile => 'Replace with a new file';

  @override
  String get templateNeedsFixing => 'needs fixing';

  @override
  String get templateNeedsFixingLong =>
      'This template has a problem, so emails can\'t be sent until it\'s fixed. See Settings › Email templates.';

  @override
  String get templateCannotSend => 'Can\'t be used to send emails until fixed';

  @override
  String templateUnknownVariable(String tag, int line) {
    return '$tag on line $line isn\'t a variable Santaroni knows. Check the spelling against the list of variables.';
  }

  @override
  String templateSyntaxError(String message) {
    return 'The template couldn\'t be read: $message';
  }

  @override
  String templateSyntaxErrorAt(int line, String message) {
    return 'Line $line: $message';
  }

  @override
  String get previewSample => 'Sample';

  @override
  String get previewPlainVersion => 'Plain-text version';

  @override
  String get previewHtmlNote =>
      'This is the text sent alongside the HTML. To see the HTML itself, send yourself a test email.';

  @override
  String get templateVariablesTitle => 'Variables you can use';

  @override
  String get templateVariablesSubtitle => 'Write these in your template file';

  @override
  String get varEventName => 'Event name';

  @override
  String get varEventWhen => 'Date and time together, whichever are set';

  @override
  String get varEventDate => 'Date';

  @override
  String get varEventTime => 'Time';

  @override
  String get varEventPlace => 'Place';

  @override
  String get varBudget => 'Budget, with currency symbol';

  @override
  String get varGiverName => 'Name of the person this email is for';

  @override
  String get varGiverEmail => 'Their email address';

  @override
  String get varRecipientName => 'Who they\'re giving a gift to';

  @override
  String get varOrganizerName => 'Your sender name';

  @override
  String get varHasDetails =>
      'Section shown when there\'s a date, place or budget';

  @override
  String get varHasWishlist =>
      'Section shown when the recipient has a wishlist';

  @override
  String get varWishlist => 'Repeats for each wishlist item, with Text and Url';

  @override
  String get deleteTemplateTitle => 'Delete this template?';

  @override
  String get deleteTemplateBody =>
      'Events using it will go back to the default template.';

  @override
  String get emailAccount => 'Email account';

  @override
  String get emailAccountNotSetUp => 'Not set up yet';

  @override
  String get emailProvider => 'Email provider';

  @override
  String get providerGmail => 'Gmail';

  @override
  String get providerCustom => 'Other (SMTP server)';

  @override
  String get gmailHelpTitle => 'Gmail needs an app password';

  @override
  String get gmailHelpStep1 =>
      '1. Turn on 2-Step Verification for your Google account.';

  @override
  String get gmailHelpStep2 =>
      '2. Create an app password (name it “Santaroni”) at:';

  @override
  String get gmailHelpStep3 =>
      '3. Paste the 16-letter code below. Your normal Gmail password won\'t work.';

  @override
  String get sentFolderWarningTitle => 'Taking part yourself?';

  @override
  String get sentFolderWarningBody =>
      'Gmail keeps a copy of every email in your Sent folder, so you\'d see everyone\'s assignments there. Use a separate free Gmail account just for the exchange.';

  @override
  String get senderName => 'Your name';

  @override
  String get senderNameHelp =>
      'Shown as the sender, and in templates as the organizer name';

  @override
  String get senderAddress => 'Email address';

  @override
  String get appPassword => 'App password';

  @override
  String get password => 'Password';

  @override
  String get passwordSavedHint => 'Saved. Leave empty to keep it.';

  @override
  String get passwordStorageNote =>
      'Stored securely in this device\'s keychain, never in the app\'s database or backups.';

  @override
  String get passwordRequired => 'Please enter the password';

  @override
  String get serverSettings => 'Server';

  @override
  String get smtpHost => 'SMTP server';

  @override
  String get smtpHostRequired => 'Please enter the server name';

  @override
  String get smtpPort => 'Port';

  @override
  String get smtpPortInvalid => 'Invalid port';

  @override
  String get smtpSecurity => 'Security';

  @override
  String get securityStartTls => 'STARTTLS (port 587)';

  @override
  String get securitySsl => 'SSL/TLS (port 465)';

  @override
  String get accountSaved => 'Email account saved';

  @override
  String get forgetAccount => 'Remove account';

  @override
  String get forgetAccountTitle => 'Remove this email account?';

  @override
  String get forgetAccountBody =>
      'Its settings and saved password will be deleted from this device. Your events are not affected.';

  @override
  String get sendTestEmail => 'Send me a test email';

  @override
  String get sendingTestEmail => 'Sending test email…';

  @override
  String get testEmailPrefix => '[Test] ';

  @override
  String get testEmailSentTitle => 'Test email sent';

  @override
  String testEmailSentBody(String address) {
    return 'Check the inbox of $address. It can take a minute to arrive.';
  }

  @override
  String get testEmailFailedTitle => 'Couldn\'t send the email';

  @override
  String get accountNotReadyTitle => 'Email account needed';

  @override
  String get accountNotReadyBody =>
      'Set up the account to send from first: your email address and its password.';

  @override
  String get setUpAccount => 'Set up account';

  @override
  String get sendErrorAuthGmail =>
      'Gmail didn\'t accept the password. Make sure it\'s an app password (not your normal Gmail password) and that 2-Step Verification is on.';

  @override
  String get sendErrorAuth =>
      'The server didn\'t accept the email address or password.';

  @override
  String get sendErrorConnection =>
      'Couldn\'t reach the email server. Check your internet connection, and the server name and port if you entered them.';

  @override
  String sendErrorRejected(String detail) {
    return 'The server refused the email: $detail';
  }

  @override
  String sendErrorOther(String detail) {
    return 'Something went wrong while sending: $detail';
  }

  @override
  String get accountReadyTitle => 'Ready to send';

  @override
  String get accountSetUpTitle => 'Set up email';

  @override
  String get accountSetUpSubtitle => 'Needed to send assignments';

  @override
  String get accountNeededBanner =>
      'Set up the email account you\'ll send these assignments from.';

  @override
  String get templatesShortcutDefault => 'Using the default design';

  @override
  String templatesShortcutImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imported',
      one: '1 imported',
    );
    return '$_temp0';
  }

  @override
  String get sendEmails => 'Send emails';

  @override
  String get emailStatus => 'Email status';

  @override
  String get sendPartlyTitle => 'Some emails haven\'t gone out';

  @override
  String get sendPartlyBody =>
      'Open Email status to send the rest or retry the ones that failed.';

  @override
  String get allEmailsSent => 'All emails sent';

  @override
  String get sentBody =>
      'Everyone has their assignment. If someone lost their email, you can resend it from Email status.';

  @override
  String get sendTitle => 'Send assignments';

  @override
  String get checkAccountReady => 'Email account is ready';

  @override
  String get checkAccountMissing => 'Email account isn\'t set up';

  @override
  String get checkTemplateReady => 'Subject and template are ready';

  @override
  String get checkTemplateProblem => 'The subject or template needs fixing';

  @override
  String get checkDrawReady => 'Names drawn and verified';

  @override
  String sentOfTotal(int sent, int total) {
    return '$sent of $total sent';
  }

  @override
  String failedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count emails failed',
      one: '1 email failed',
    );
    return '$_temp0';
  }

  @override
  String get sendingInProgress =>
      'Sending… you can leave this screen; it keeps going.';

  @override
  String sendAllButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send $count emails',
      one: 'Send 1 email',
    );
    return '$_temp0';
  }

  @override
  String sendRemainingButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send the remaining $count',
      one: 'Send the remaining email',
    );
    return '$_temp0';
  }

  @override
  String retryFailedButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Retry $count failed',
      one: 'Retry the failed email',
    );
    return '$_temp0';
  }

  @override
  String get sendMePreview => 'Send me a preview';

  @override
  String get sendPrivacyNote =>
      'The preview uses this event\'s details with made-up names, so it doesn\'t reveal anyone\'s assignment. Only who receives each email is listed below.';

  @override
  String sendConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Send $count emails?',
      one: 'Send 1 email?',
    );
    return '$_temp0';
  }

  @override
  String sendConfirmBody(String from) {
    return 'Each participant gets their assignment from $from. Once emails go out, people can no longer be added or removed.';
  }

  @override
  String get sendNow => 'Send';

  @override
  String get stop => 'Stop';

  @override
  String get stopping => 'Stopping…';

  @override
  String get sendBlocked => 'Fix the items marked in the checklist first.';

  @override
  String sendFinished(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count emails sent',
      one: '1 email sent',
    );
    return '$_temp0';
  }

  @override
  String sendFinishedWithFailures(int sent, int failed) {
    return '$sent sent, $failed failed. You can retry the failed ones.';
  }

  @override
  String sendStopped(int count) {
    return 'Stopped after $count sent. The rest are waiting.';
  }

  @override
  String get resend => 'Resend';

  @override
  String resendTitle(String name) {
    return 'Resend to $name?';
  }

  @override
  String resendBody(String email) {
    return 'They\'ll get their assignment again at $email. You won\'t see who it is.';
  }

  @override
  String get statusSendingNow => 'Sending…';

  @override
  String get statusEmailPending => 'Not sent yet';

  @override
  String get statusEmailSent => 'Sent';

  @override
  String statusEmailSentAt(String when) {
    return 'Sent $when';
  }

  @override
  String statusEmailFailed(String error) {
    return 'Failed: $error';
  }

  @override
  String get exportJson => 'Export JSON';

  @override
  String get exportTitle => 'Save a backup';

  @override
  String get exportBody =>
      'A full backup includes who gives to whom, in plain text. Anyone who opens the file will see every assignment, including yours.';

  @override
  String get exportWithAssignments => 'Full backup';

  @override
  String get exportWithoutAssignments => 'Without assignments';

  @override
  String get exportSaved => 'Backup saved';

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
  String get fileSaveError => 'Couldn\'t save the file.';

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
