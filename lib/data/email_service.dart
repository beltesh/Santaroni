import '../core/email/email_context.dart';
import '../core/email/email_renderer.dart';
import '../core/email/mail_transport.dart';
import 'database.dart';
import 'email_account_repository.dart';

/// The account isn't usable yet: missing address, server or password.
class AccountNotReadyException implements Exception {
  const AccountNotReadyException();
}

/// Sends emails through the organizer's account.
class EmailService {
  EmailService(this._accounts, this._transport);

  final EmailAccountRepository _accounts;
  final MailTransport _transport;

  /// Sends a sample email to the organizer's own address, filled in with
  /// made-up participants, so they can check the account works and see how
  /// a template really looks in their inbox. With [event], its real details
  /// (name, date, place, budget) are used; the people are still made up, so
  /// no assignment is revealed. For a cancellation email, [note] replaces
  /// the sample note. Returns the address used.
  Future<String> sendTest({
    required String subject,
    required BodyTemplate body,
    required String languageCode,
    TemplateKind kind = TemplateKind.assignment,
    Event? event,
    String? note,
    String testPrefix = '[Test] ',
  }) async {
    final account = await _accounts.load();
    final password = await _accounts.password();
    if (account == null ||
        !account.isComplete ||
        password == null ||
        password.isEmpty) {
      throw const AccountNotReadyException();
    }

    final sample = EmailContext.sample(languageCode);
    final details = event == null
        ? sample
        : EmailContext.forEvent(
            languageCode: event.languageCode,
            eventName: event.name,
            date: event.eventDate,
            time: event.eventTime,
            place: event.place,
            budgetMinor: event.budgetMinor,
            currency: event.currency,
            giverName: '',
            giverEmail: '',
            recipientName: '',
          );
    final me = account.senderName.isEmpty
        ? sample.giverName
        : account.senderName;
    final organizer = account.senderName.isEmpty ? null : account.senderName;
    final TemplateValues values = switch (kind) {
      TemplateKind.assignment => EmailContext(
        eventName: details.eventName,
        eventDate: details.eventDate,
        eventTime: details.eventTime,
        eventPlace: details.eventPlace,
        budget: details.budget,
        giverName: me,
        giverEmail: account.address,
        recipientName: sample.recipientName,
        organizerName: organizer,
        wishlist: sample.wishlist,
      ),
      TemplateKind.cancellation => CancellationContext(
        eventName: details.eventName,
        eventDate: details.eventDate,
        eventTime: details.eventTime,
        eventPlace: details.eventPlace,
        participantName: me,
        participantEmail: account.address,
        organizerName: organizer,
        note: event == null
            ? CancellationContext.sample(languageCode).note
            : note,
      ),
    };
    final email = renderEmail(subject: subject, body: body, context: values);

    await _transport.sendOne(
      account.smtpConfig,
      password,
      to: account.address,
      toName: account.senderName,
      email: RenderedEmail(
        subject: '$testPrefix${email.subject}',
        text: email.text,
        html: email.html,
      ),
    );
    return account.address;
  }
}
