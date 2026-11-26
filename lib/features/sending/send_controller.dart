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

  /// Whose email is going out right now.
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

/// Runs sending for one event. Kept alive (not auto-disposed) so a run
/// continues if the user leaves the screen. Per-person results live in the
/// database; this only tracks the run itself.
class SendController extends Notifier<SendRunState> {
  SendController(this.eventId);

  final int eventId;

  @override
  SendRunState build() => const SendRunState();

  Future<void> sendAll({bool includeFailed = true}) => _run(
    (service) => service.sendAll(
      eventId,
      includeFailed: includeFailed,
      onSending: _onSending,
      shouldStop: () => state.stopRequested,
    ),
  );

  Future<void> resend(int giverId) => _run(
    (service) => service.resend(eventId, giverId, onSending: _onSending),
  );

  void stop() {
    if (state.running) state = state.copyWith(stopRequested: true);
  }

  void _onSending(int giverId) =>
      state = state.copyWith(currentGiverId: () => giverId);

  Future<void> _run(Future<SendRunResult> Function(SendService) action) async {
    if (state.running) return;
    state = const SendRunState(running: true);
    try {
      final result = await action(ref.read(sendServiceProvider));
      state = SendRunState(lastResult: result);
    } catch (e) {
      state = SendRunState(lastError: e);
    }
  }
}

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
