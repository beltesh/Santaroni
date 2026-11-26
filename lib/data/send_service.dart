import '../core/assignment/secret_santa_cycle.dart';
import '../core/email/email_context.dart';
import '../core/email/email_renderer.dart';
import '../core/email/mail_transport.dart';
import '../core/model/wishlist_entry.dart';
import 'database.dart';
import 'email_account_repository.dart';
import 'events_repository.dart';
import 'templates_repository.dart';

/// Something that must be fixed before emails can go out.
enum SendBlocker {
  /// No complete account with a saved password.
  accountNotReady,

  /// The subject or template has a problem (e.g. an unknown variable).
  templateProblem,

  /// Names haven't been drawn yet.
  notDrawn,

  /// The stored draw fails verification.
  drawInvalid,
}

class SendBlockedException implements Exception {
  const SendBlockedException(this.blockers);
  final Set<SendBlocker> blockers;
}

enum SendOutcome {
  /// Every email in this run was attempted.
  finished,

  /// The user pressed Stop; the rest stay pending.
  stopped,

  /// A login or connection problem would make every email fail, so the
  /// run stopped at the first one. The rest stay pending.
  aborted,
}

class SendRunResult {
  const SendRunResult(
    this.outcome, {
    this.sent = 0,
    this.failed = 0,
    this.error,
  });

  final SendOutcome outcome;
  final int sent;
  final int failed;

  /// Why the run was aborted.
  final SendException? error;
}

/// Sends each participant their assignment, one email at a time, recording
/// the outcome per person so a run can be stopped and resumed, and only
/// failures retried.
class SendService {
  SendService({
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

  Future<Set<SendBlocker>> blockers(int eventId) async {
    final result = <SendBlocker>{};
    if (!(await accounts.status()).isReady) {
      result.add(SendBlocker.accountNotReady);
    }

    final event = (await events.watchEvent(eventId).first)!;
    if ((await templates.forEvent(event)).problem != null) {
      result.add(SendBlocker.templateProblem);
    }

    final views = await events.assignments(eventId);
    if (event.status == EventStatus.draft || views.isEmpty) {
      result.add(SendBlocker.notDrawn);
    } else {
      final people = await events.watchParticipants(eventId).first;
      final ok = SecretSantaCycle.isValid(
        [for (final p in people) p.participant.id],
        {for (final v in views) v.giver.id: v.recipient.id},
        groups: {
          for (final p in people) p.participant.id: p.participant.groupTag,
        },
      );
      if (!ok) result.add(SendBlocker.drawInvalid);
    }
    return result;
  }

  /// Sends every email that hasn't gone out yet (pending, and failed unless
  /// [includeFailed] is false). [onSending] is told whose email is going out
  /// next; [shouldStop] is checked between emails.
  Future<SendRunResult> sendAll(
    int eventId, {
    bool includeFailed = true,
    void Function(int giverId)? onSending,
    bool Function()? shouldStop,
  }) async {
    final prepared = await _prepare(eventId);
    final todo = prepared.views.where(
      (v) =>
          v.assignment.sendStatus == SendStatus.pending ||
          (includeFailed && v.assignment.sendStatus == SendStatus.failed),
    );
    return _run(
      prepared,
      todo.toList(),
      onSending: onSending,
      shouldStop: shouldStop,
    );
  }

  /// Sends [giverId]'s email again, whatever its status ("I lost my email").
  Future<SendRunResult> resend(
    int eventId,
    int giverId, {
    void Function(int giverId)? onSending,
  }) async {
    final prepared = await _prepare(eventId);
    final view = prepared.views.where((v) => v.giver.id == giverId).toList();
    return _run(prepared, view, onSending: onSending);
  }

  Future<_Prepared> _prepare(int eventId) async {
    final blocked = await blockers(eventId);
    if (blocked.isNotEmpty) throw SendBlockedException(blocked);

    final event = (await events.watchEvent(eventId).first)!;
    final status = await accounts.status();
    final password = (await accounts.password())!;
    final template = await templates.forEvent(event);
    final people = await events.watchParticipants(eventId).first;
    final wishlists = {
      for (final p in people)
        p.participant.id: [
          for (final w in p.wishlist) WishlistEntry(w.itemText, w.url),
        ],
    };
    return _Prepared(
      event: event,
      account: status.account!,
      password: password,
      template: template,
      views: await events.assignments(eventId),
      wishlists: wishlists,
    );
  }

  Future<SendRunResult> _run(
    _Prepared p,
    List<AssignmentView> todo, {
    void Function(int giverId)? onSending,
    bool Function()? shouldStop,
  }) async {
    if (todo.isEmpty) return const SendRunResult(SendOutcome.finished);

    var sent = 0;
    var failed = 0;
    final session = await transport.open(p.account.smtpConfig, p.password);
    try {
      for (final (i, view) in todo.indexed) {
        if (shouldStop?.call() ?? false) {
          return SendRunResult(SendOutcome.stopped, sent: sent, failed: failed);
        }
        if (i > 0 && pause > Duration.zero) await Future<void>.delayed(pause);

        onSending?.call(view.giver.id);
        final email = renderEmail(
          subject: p.template.subject,
          body: p.template.body,
          context: _contextFor(p, view),
        );
        try {
          await session.send(
            to: view.giver.email,
            toName: view.giver.name,
            email: email,
          );
          await events.markSent(p.event.id, view.giver.id);
          sent++;
        } on SendException catch (e) {
          await events.markFailed(p.event.id, view.giver.id, e.detail);
          failed++;
          // Every later email would fail the same way: stop and let the user
          // fix the account or connection, then resume.
          if (e.failure == SendFailure.authentication ||
              e.failure == SendFailure.connection) {
            return SendRunResult(
              SendOutcome.aborted,
              sent: sent,
              failed: failed,
              error: e,
            );
          }
        }
      }
      return SendRunResult(SendOutcome.finished, sent: sent, failed: failed);
    } finally {
      try {
        await session.close();
      } catch (_) {
        // A connection that never opened can fail to close; the run's
        // outcome (or the original error) is what matters.
      }
    }
  }

  EmailContext _contextFor(_Prepared p, AssignmentView view) {
    final e = p.event;
    final organizer = p.account.senderName.trim();
    return EmailContext.forEvent(
      languageCode: e.languageCode,
      eventName: e.name,
      date: e.eventDate,
      time: e.eventTime,
      place: e.place,
      budgetMinor: e.budgetMinor,
      currency: e.currency,
      giverName: view.giver.name,
      giverEmail: view.giver.email,
      recipientName: view.recipient.name,
      organizerName: organizer.isEmpty ? null : organizer,
      wishlist: p.wishlists[view.recipient.id] ?? const [],
    );
  }
}

class _Prepared {
  const _Prepared({
    required this.event,
    required this.account,
    required this.password,
    required this.template,
    required this.views,
    required this.wishlists,
  });

  final Event event;
  final EmailAccount account;
  final String password;
  final EventEmailTemplate template;
  final List<AssignmentView> views;
  final Map<int, List<WishlistEntry>> wishlists;
}
