import '../core/email/email_context.dart';
import '../core/email/email_renderer.dart';
import '../core/email/mail_transport.dart';
import 'database.dart';
import 'email_account_repository.dart';
import 'events_repository.dart';
import 'send_service.dart';
import 'templates_repository.dart';

/// Cancels events and tells every participant by email.
class CancellationService {
  CancellationService({
    required this.events,
    required this.templates,
    required this.accounts,
    required this.transport,
    this.pause = const Duration(milliseconds: 400),
  });

  final EventsRepository events;
  final TemplatesRepository templates;
  final EmailAccountRepository accounts;
  final MailTransport transport;

  /// Small gap between emails, to stay well within provider rate limits.
  final Duration pause;

  /// The email [request] would send for [event].
  Future<EventEmailTemplate> templateFor(Event event, CancelRequest request) =>
      templates.resolve(
        TemplateKind.cancellation,
        languageCode: event.languageCode,
        templateId: request.templateId,
        subject: request.subject,
      );

  /// What stops [request] from going through. Without notifying, only an
  /// already completed event does.
  Future<Set<SendBlocker>> cancelBlockers(
    int eventId,
    CancelRequest request,
  ) async {
    final event = (await events.watchEvent(eventId).first)!;
    return {
      if (event.isCompletedAt(DateTime.now())) SendBlocker.eventCompleted,
      if (request.notify)
        ...await _emailBlockers(await templateFor(event, request)),
    };
  }

  /// Cancels the event (final; it becomes read-only) and, with
  /// [CancelRequest.notify], queues an email for every participant. Call
  /// [sendNotices] next to send them.
  Future<void> cancel(int eventId, CancelRequest request) async {
    final blocked = await cancelBlockers(eventId, request);
    if (blocked.isNotEmpty) throw SendBlockedException(blocked);
    await events.cancelEvent(eventId, request);
  }

  /// What stops the cancellation emails of a cancelled event from going
  /// out (e.g. the account was removed, or the template has a problem).
  Future<Set<SendBlocker>> noticeBlockers(int eventId) async {
    final event = (await events.watchEvent(eventId).first)!;
    return _emailBlockers(await templates.forCancellation(event));
  }

  Future<Set<SendBlocker>> _emailBlockers(EventEmailTemplate template) async =>
      {
        if (!(await accounts.status()).isReady) SendBlocker.accountNotReady,
        if (template.problem != null) SendBlocker.templateProblem,
      };

  /// Sends every cancellation email that hasn't gone out yet (pending, and
  /// failed unless [includeFailed] is false).
  Future<SendRunResult> sendNotices(
    int eventId, {
    bool includeFailed = true,
    void Function(int participantId)? onSending,
    bool Function()? shouldStop,
  }) async {
    final all = await events.notices(eventId);
    final todo = all.where(
      (n) =>
          n.notice.sendStatus == SendStatus.pending ||
          (includeFailed && n.notice.sendStatus == SendStatus.failed),
    );
    return _run(
      eventId,
      todo.toList(),
      onSending: onSending,
      shouldStop: shouldStop,
    );
  }

  /// Sends [participantId]'s cancellation email again, whatever its status.
  Future<SendRunResult> resendNotice(
    int eventId,
    int participantId, {
    void Function(int participantId)? onSending,
  }) async {
    final all = await events.notices(eventId);
    return _run(eventId, [
      for (final n in all)
        if (n.participant.id == participantId) n,
    ], onSending: onSending);
  }

  Future<SendRunResult> _run(
    int eventId,
    List<NoticeView> todo, {
    void Function(int participantId)? onSending,
    bool Function()? shouldStop,
  }) async {
    final blocked = await noticeBlockers(eventId);
    if (blocked.isNotEmpty) throw SendBlockedException(blocked);

    final event = (await events.watchEvent(eventId).first)!;
    final account = (await accounts.status()).account!;
    final password = (await accounts.password())!;
    final template = await templates.forCancellation(event);
    final organizer = account.senderName.trim();

    return runEmailBatch(
      transport: transport,
      account: account,
      password: password,
      pause: pause,
      items: [
        for (final n in todo)
          OutgoingEmail(
            id: n.participant.id,
            to: n.participant.email,
            toName: n.participant.name,
            render: () => renderEmail(
              subject: template.subject,
              body: template.body,
              context: CancellationContext.forEvent(
                languageCode: event.languageCode,
                eventName: event.name,
                date: event.eventDate,
                time: event.eventTime,
                place: event.place,
                participantName: n.participant.name,
                participantEmail: n.participant.email,
                organizerName: organizer.isEmpty ? null : organizer,
                note: event.cancelNote,
              ),
            ),
          ),
      ],
      markSent: (id) => events.markNoticeSent(id),
      markFailed: events.markNoticeFailed,
      onSending: onSending,
      shouldStop: shouldStop,
    );
  }
}
