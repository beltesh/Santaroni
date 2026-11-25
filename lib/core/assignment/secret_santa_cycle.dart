import 'dart:math';

/// Why an assignment could not be produced or modified.
enum AssignmentFailure {
  /// Fewer than [SecretSantaCycle.minParticipants] people.
  tooFewParticipants,

  /// The same participant appears more than once in the input list.
  duplicateParticipant,

  /// The exclusion groups make a single cycle impossible, e.g. one group
  /// holds more than half of all participants.
  exclusionsImpossible,

  /// A dropout could not be spliced out without breaking an exclusion rule,
  /// even after trying to relocate someone. The exchange must be regenerated.
  spliceViolatesExclusions,
}

class AssignmentException implements Exception {
  const AssignmentException(this.failure, [this.message]);

  final AssignmentFailure failure;
  final String? message;

  @override
  String toString() => 'AssignmentException(${failure.name})'
      '${message == null ? '' : ': $message'}';
}

/// A problem found by [SecretSantaCycle.validate].
enum AssignmentIssueType {
  tooFewParticipants,

  /// A participant has no one to give to.
  missingGiver,

  /// Nobody is giving to this participant.
  missingRecipient,

  /// This participant is assigned as recipient by more than one giver.
  duplicateRecipient,

  /// The assignment mentions someone who isn't a participant.
  unknownParticipant,
  selfAssignment,

  /// Giver and recipient share an exclusion group.
  sameGroup,

  /// The assignments split into more than one loop.
  notSingleCycle,
}

class AssignmentIssue<T> {
  const AssignmentIssue(this.type, [this.participant]);

  final AssignmentIssueType type;
  final T? participant;

  @override
  String toString() => participant == null
      ? 'AssignmentIssue(${type.name})'
      : 'AssignmentIssue(${type.name}, $participant)';
}

/// Result of removing a participant from an existing exchange.
class SpliceResult<T> {
  const SpliceResult(this.assignment, this.changedGivers);

  /// The new giver → recipient map, still a single cycle.
  final Map<T, T> assignment;

  /// Givers whose recipient changed. Only these people need a new email.
  final Set<T> changedGivers;
}

/// Secret Santa assignment logic.
///
/// Assignments are a map from giver to recipient that always forms a single
/// cycle through every participant: following "who does X give to" from
/// anyone visits everybody exactly once before returning to the start.
///
/// Participants are identified by any value with proper `==`/`hashCode`
/// (database ids in the app). Exclusion groups are optional free-text tags;
/// two participants with the same non-empty tag (case-insensitive) never give
/// to each other.
abstract final class SecretSantaCycle {
  static const minParticipants = 3;

  /// Creates a random single-cycle assignment.
  ///
  /// Without exclusions this is a single shuffle and picks uniformly among
  /// all possible cycles. With exclusions it first retries shuffles (still
  /// uniform among valid cycles), then falls back to a randomized
  /// backtracking search, so it succeeds whenever a valid cycle exists.
  ///
  /// Throws [AssignmentException] when no valid assignment exists.
  static Map<T, T> generate<T>(
    List<T> participants, {
    Map<T, String?> groups = const {},
    Random? random,
    int maxShuffleAttempts = 500,
  }) {
    final rng = random ?? Random.secure();
    final n = participants.length;

    if (participants.toSet().length != n) {
      throw const AssignmentException(AssignmentFailure.duplicateParticipant);
    }
    if (n < minParticipants) {
      throw const AssignmentException(AssignmentFailure.tooFewParticipants);
    }

    final groupOf = _groupLookup(participants, groups);
    final hasExclusions = groupOf.isNotEmpty;

    if (hasExclusions) {
      // A single cycle exists iff no group holds more than half the people
      // (a complete multipartite graph is Hamiltonian iff its largest part
      // has at most n/2 vertices).
      final largest = _groupSizes(participants, groupOf).values.fold(0, max);
      if (largest > n ~/ 2) {
        throw AssignmentException(
          AssignmentFailure.exclusionsImpossible,
          'A group has $largest of $n participants; at most ${n ~/ 2} allowed.',
        );
      }
    }

    final order = List<T>.of(participants);
    for (var attempt = 0; attempt < maxShuffleAttempts; attempt++) {
      order.shuffle(rng);
      if (!hasExclusions || _cycleRespectsGroups(order, groupOf)) {
        return _cycleToMap(order);
      }
    }

    final found = _backtrack(participants, groupOf, rng);
    if (found == null) {
      // Unreachable given the feasibility check above, kept as a safety net.
      throw const AssignmentException(AssignmentFailure.exclusionsImpossible);
    }
    return _cycleToMap(found);
  }

  /// Checks that [assignment] is a valid single cycle over [participants].
  /// Returns an empty list when everything is fine.
  static List<AssignmentIssue<T>> validate<T>(
    List<T> participants,
    Map<T, T> assignment, {
    Map<T, String?> groups = const {},
  }) {
    final issues = <AssignmentIssue<T>>[];
    final people = participants.toSet();

    if (people.length < minParticipants) {
      issues.add(const AssignmentIssue(AssignmentIssueType.tooFewParticipants));
    }

    final receivedBy = <T, int>{};
    for (final MapEntry(key: giver, value: recipient) in assignment.entries) {
      if (!people.contains(giver)) {
        issues.add(AssignmentIssue(AssignmentIssueType.unknownParticipant, giver));
      }
      if (!people.contains(recipient)) {
        issues.add(
            AssignmentIssue(AssignmentIssueType.unknownParticipant, recipient));
      }
      if (giver == recipient) {
        issues.add(AssignmentIssue(AssignmentIssueType.selfAssignment, giver));
      }
      receivedBy[recipient] = (receivedBy[recipient] ?? 0) + 1;
    }

    for (final p in people) {
      if (!assignment.containsKey(p)) {
        issues.add(AssignmentIssue(AssignmentIssueType.missingGiver, p));
      }
      final received = receivedBy[p] ?? 0;
      if (received == 0) {
        issues.add(AssignmentIssue(AssignmentIssueType.missingRecipient, p));
      } else if (received > 1) {
        issues.add(AssignmentIssue(AssignmentIssueType.duplicateRecipient, p));
      }
    }

    final groupOf = _groupLookup(participants, groups);
    for (final MapEntry(key: giver, value: recipient) in assignment.entries) {
      if (_sameGroup(giver, recipient, groupOf)) {
        issues.add(AssignmentIssue(AssignmentIssueType.sameGroup, giver));
      }
    }

    // Walk the chain from any participant; it must return home after exactly
    // n steps. Only meaningful once the map is a proper permutation.
    if (issues.isEmpty && people.isNotEmpty) {
      final start = participants.first;
      var current = start;
      var steps = 0;
      do {
        current = assignment[current] as T;
        steps++;
      } while (current != start && steps <= people.length);
      if (steps != people.length) {
        issues.add(const AssignmentIssue(AssignmentIssueType.notSingleCycle));
      }
    }

    return issues;
  }

  static bool isValid<T>(
    List<T> participants,
    Map<T, T> assignment, {
    Map<T, String?> groups = const {},
  }) =>
      validate(participants, assignment, groups: groups).isEmpty;

  /// Removes [leaving] from an existing exchange without regenerating it.
  ///
  /// Normally the person who gave to [leaving] now gives to whoever [leaving]
  /// was giving to, so one new email is enough. If that pairing would break
  /// an exclusion group, one other participant is moved into the gap instead,
  /// which changes three assignments but keeps everyone else's untouched.
  static SpliceResult<T> splice<T>(
    Map<T, T> assignment,
    T leaving, {
    Map<T, String?> groups = const {},
    Random? random,
  }) {
    if (!assignment.containsKey(leaving)) {
      throw ArgumentError.value(leaving, 'leaving', 'Not in this exchange');
    }
    if (assignment.length - 1 < minParticipants) {
      throw const AssignmentException(AssignmentFailure.tooFewParticipants);
    }

    final rng = random ?? Random.secure();
    final groupOf = _groupLookup(assignment.keys.toList(), groups);
    final giverOf = {for (final e in assignment.entries) e.value: e.key};

    final result = Map<T, T>.of(assignment)..remove(leaving);
    final giver = giverOf[leaving] as T;
    final recipient = assignment[leaving] as T;
    result[giver] = recipient;
    giverOf
      ..remove(leaving)
      ..[recipient] = giver;

    if (!_sameGroup(giver, recipient, groupOf)) {
      return SpliceResult(result, {giver});
    }

    // giver → recipient is forbidden. Move some y (p → y → q) into the gap:
    // giver → y → recipient, and p → q.
    final candidates = result.keys
        .where((y) => y != giver && y != recipient)
        .toList()
      ..shuffle(rng);
    for (final y in candidates) {
      final p = giverOf[y] as T;
      final q = result[y] as T;
      if (p == giver) continue; // y is already giver's recipient.
      if (_sameGroup(giver, y, groupOf) ||
          _sameGroup(y, recipient, groupOf) ||
          _sameGroup(p, q, groupOf)) {
        continue;
      }
      result
        ..[giver] = y
        ..[y] = recipient
        ..[p] = q;
      return SpliceResult(result, {giver, y, p});
    }

    throw const AssignmentException(AssignmentFailure.spliceViolatesExclusions);
  }

  // ---------------------------------------------------------------------------

  /// Normalized group per participant, omitting people with no group.
  static Map<T, String> _groupLookup<T>(
    List<T> participants,
    Map<T, String?> groups,
  ) {
    final result = <T, String>{};
    for (final p in participants) {
      final tag = groups[p]?.trim().toLowerCase();
      if (tag != null && tag.isNotEmpty) result[p] = tag;
    }
    return result;
  }

  static Map<String, int> _groupSizes<T>(
    Iterable<T> people,
    Map<T, String> groupOf,
  ) {
    final sizes = <String, int>{};
    for (final p in people) {
      final g = groupOf[p];
      if (g != null) sizes[g] = (sizes[g] ?? 0) + 1;
    }
    return sizes;
  }

  static bool _sameGroup<T>(T a, T b, Map<T, String> groupOf) {
    final ga = groupOf[a];
    return ga != null && ga == groupOf[b];
  }

  static bool _cycleRespectsGroups<T>(List<T> order, Map<T, String> groupOf) {
    for (var i = 0; i < order.length; i++) {
      if (_sameGroup(order[i], order[(i + 1) % order.length], groupOf)) {
        return false;
      }
    }
    return true;
  }

  static Map<T, T> _cycleToMap<T>(List<T> order) => {
        for (var i = 0; i < order.length; i++)
          order[i]: order[(i + 1) % order.length],
      };

  /// Randomized depth-first search for a cycle order, pruned by counting:
  /// a group with c remaining members needs c non-adjacent free slots.
  static List<T>? _backtrack<T>(
    List<T> participants,
    Map<T, String> groupOf,
    Random rng,
  ) {
    final sizes = _groupSizes(participants, groupOf);
    // Starting with a member of the largest group makes tight cases easy.
    final start = (List<T>.of(participants)..shuffle(rng)).reduce((a, b) =>
        (sizes[groupOf[b]] ?? 0) > (sizes[groupOf[a]] ?? 0) ? b : a);

    final remaining = participants.where((p) => p != start).toSet();
    final remainingSizes = Map<String, int>.of(sizes);
    final startGroup = groupOf[start];
    if (startGroup != null) remainingSizes[startGroup] = sizes[startGroup]! - 1;

    final path = <T>[start];

    bool feasible(T current) {
      final r = remaining.length;
      final currentGroup = groupOf[current];
      if (r == 0) return !_sameGroup(current, start, groupOf);
      for (final MapEntry(key: g, value: count) in remainingSizes.entries) {
        if (count == 0) continue;
        final slots = r -
            (g == currentGroup ? 1 : 0) -
            (g == startGroup ? 1 : 0);
        if (count > (slots + 1) ~/ 2) return false;
      }
      return true;
    }

    bool extend() {
      if (remaining.isEmpty) return true;
      final current = path.last;
      final options = remaining
          .where((next) => !_sameGroup(current, next, groupOf))
          .toList()
        ..shuffle(rng);
      for (final next in options) {
        final g = groupOf[next];
        remaining.remove(next);
        if (g != null) remainingSizes[g] = remainingSizes[g]! - 1;
        path.add(next);

        if (feasible(next) && extend()) return true;

        path.removeLast();
        if (g != null) remainingSizes[g] = remainingSizes[g]! + 1;
        remaining.add(next);
      }
      return false;
    }

    return extend() ? path : null;
  }
}
