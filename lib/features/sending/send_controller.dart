import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/send_service.dart';

class SendRunState {
  const SendRunState({
    this.running = false,
    this.stopRequested = false,
    this.currentGiverId,
    this.lastResult,
    this.lastError,
  });

  final bool running;
  final bool stopRequested;

  /// Whose email is going out right now (participant id).
  final int? currentGiverId;

  /// How the last run ended.
  final SendRunResult? lastResult;

  /// Why the last run couldn't start (e.g. [SendBlockedException]).
  final Object? lastError;

  SendRunState copyWith({
    bool? running,
    bool? stopRequested,
    int? Function()? currentGiverId,
    SendRunResult? Function()? lastResult,
    Object? Function()? lastError,
  }) => SendRunState(
    running: running ?? this.running,
    stopRequested: stopRequested ?? this.stopRequested,
    currentGiverId: currentGiverId != null
        ? currentGiverId()
        : this.currentGiverId,
    lastResult: lastResult != null ? lastResult() : this.lastResult,
    lastError: lastError != null ? lastError() : this.lastError,
  );
}

/// Runs a batch of emails, tracking only the run itself (per-person
/// results live in the database). Kept alive (not auto-disposed) so a run
/// continues if the user leaves the screen.
abstract class EmailRunController extends Notifier<SendRunState> {
  @override
  SendRunState build() => const SendRunState();

  void stop() {
    if (state.running) state = state.copyWith(stopRequested: true);
  }

  bool get stopRequested => state.stopRequested;

  void onSending(int id) => state = state.copyWith(currentGiverId: () => id);

  Future<void> run(Future<SendRunResult> Function() action) async {
    if (state.running) return;
    state = const SendRunState(running: true);
    try {
      state = SendRunState(lastResult: await action());
    } catch (e) {
      state = SendRunState(lastError: e);
    }
  }
}

/// Sends one event's assignments.
class SendController extends EmailRunController {
  SendController(this.eventId);

  final int eventId;

  Future<void> sendAll({bool includeFailed = true}) => run(
    () => ref
        .read(sendServiceProvider)
        .sendAll(
          eventId,
          includeFailed: includeFailed,
          onSending: onSending,
          shouldStop: () => stopRequested,
        ),
  );

  Future<void> resend(int giverId) => run(
    () => ref
        .read(sendServiceProvider)
        .resend(eventId, giverId, onSending: onSending),
  );
}

/// Sends one cancelled event's cancellation emails.
class CancelNoticesController extends EmailRunController {
  CancelNoticesController(this.eventId);

  final int eventId;

  Future<void> sendAll() => run(
    () => ref
        .read(cancellationServiceProvider)
        .sendNotices(
          eventId,
          onSending: onSending,
          shouldStop: () => stopRequested,
        ),
  );

  Future<void> resend(int participantId) => run(
    () => ref
        .read(cancellationServiceProvider)
        .resendNotice(eventId, participantId, onSending: onSending),
  );
}

final cancelNoticesControllerProvider =
    NotifierProvider.family<CancelNoticesController, SendRunState, int>(
      CancelNoticesController.new,
    );

/// What stops a cancelled event's emails from going out.
final noticeBlockersProvider = FutureProvider.autoDispose
    .family<Set<SendBlocker>, int>((ref, eventId) {
      ref.watch(eventProvider(eventId));
      ref.watch(accountStatusProvider);
      ref.watch(templatesProvider);
      return ref.read(cancellationServiceProvider).noticeBlockers(eventId);
    });

final sendControllerProvider =
    NotifierProvider.family<SendController, SendRunState, int>(
      SendController.new,
    );

/// What still stands in the way of sending for an event. Re-evaluated
/// whenever the event, its assignments, the account or templates change.
final sendBlockersProvider = FutureProvider.autoDispose
    .family<Set<SendBlocker>, int>((ref, eventId) {
      ref.watch(eventProvider(eventId));
      ref.watch(assignmentsProvider(eventId));
      ref.watch(accountStatusProvider);
      ref.watch(templatesProvider);
      return ref.read(sendServiceProvider).blockers(eventId);
    });
