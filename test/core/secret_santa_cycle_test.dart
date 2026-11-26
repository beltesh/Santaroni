import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:santaroni/core/assignment/secret_santa_cycle.dart';

List<int> people(int n) => List.generate(n, (i) => i + 1);

void expectValid(List<int> ps, Map<int, int> a, {Map<int, String?>? groups}) {
  expect(SecretSantaCycle.validate(ps, a, groups: groups ?? const {}), isEmpty);
}

void main() {
  group('generate', () {
    test('produces a valid single cycle for many sizes and seeds', () {
      for (var n = 3; n <= 40; n++) {
        for (var seed = 0; seed < 20; seed++) {
          final ps = people(n);
          final a = SecretSantaCycle.generate(ps, random: Random(seed));
          expectValid(ps, a);
        }
      }
    });

    test('rejects fewer than 3 participants', () {
      for (final n in [0, 1, 2]) {
        expect(
          () => SecretSantaCycle.generate(people(n)),
          throwsA(
            isA<AssignmentException>().having(
              (e) => e.failure,
              'failure',
              AssignmentFailure.tooFewParticipants,
            ),
          ),
        );
      }
    });

    test('rejects duplicate participants', () {
      expect(
        () => SecretSantaCycle.generate([1, 2, 3, 3]),
        throwsA(
          isA<AssignmentException>().having(
            (e) => e.failure,
            'failure',
            AssignmentFailure.duplicateParticipant,
          ),
        ),
      );
    });

    test('is roughly uniform over the (n-1)! cycles', () {
      // 4 people have 3! = 6 distinct single cycles.
      final counts = <String, int>{};
      final rng = Random(42);
      const runs = 6000;
      for (var i = 0; i < runs; i++) {
        final a = SecretSantaCycle.generate(people(4), random: rng);
        final key = [1, 2, 3, 4].map((g) => a[g]).join();
        counts[key] = (counts[key] ?? 0) + 1;
      }
      expect(counts, hasLength(6));
      for (final c in counts.values) {
        expect(c, inInclusiveRange(800, 1200));
      }
    });

    test('respects exclusion groups', () {
      final ps = people(10);
      final groups = {1: 'smith', 2: 'Smith ', 3: 'lee', 4: 'lee', 5: ''};
      for (var seed = 0; seed < 200; seed++) {
        final a = SecretSantaCycle.generate(
          ps,
          groups: groups,
          random: Random(seed),
        );
        expectValid(ps, a, groups: groups);
        expect(a[1], isNot(2));
        expect(a[2], isNot(1));
        expect(a[3], isNot(4));
        expect(a[4], isNot(3));
      }
    });

    test('rejects a group larger than half the participants', () {
      final ps = people(5);
      final groups = {1: 'a', 2: 'a', 3: 'a'};
      expect(
        () => SecretSantaCycle.generate(ps, groups: groups),
        throwsA(
          isA<AssignmentException>().having(
            (e) => e.failure,
            'failure',
            AssignmentFailure.exclusionsImpossible,
          ),
        ),
      );
    });

    test('solves tight cases via backtracking', () {
      // Two groups of exactly half: the only valid cycles alternate, which
      // random shuffles almost never hit for n = 30.
      final ps = people(30);
      final groups = {for (final p in ps) p: p.isEven ? 'even' : 'odd'};
      for (var seed = 0; seed < 20; seed++) {
        final a = SecretSantaCycle.generate(
          ps,
          groups: groups,
          random: Random(seed),
          maxShuffleAttempts: 5,
        );
        expectValid(ps, a, groups: groups);
      }
    });

    test('solves three-group and mixed tight cases', () {
      final cases = <(List<int>, Map<int, String?>)>[
        // 3 groups of 10.
        (people(30), {for (final p in people(30)) p: 'g${p % 3}'}),
        // One group of 15 out of 30 plus a few couples.
        (
          people(30),
          {
            for (final p in people(15)) p: 'big',
            16: 'c1', 17: 'c1', 18: 'c2', 19: 'c2', //
          },
        ),
        // Odd total (15) with a group of exactly floor(n/2) = 7.
        (people(15), {for (final p in people(7)) p: 'big', 8: 'x', 9: 'x'}),
      ];
      for (final (ps, groups) in cases) {
        for (var seed = 0; seed < 10; seed++) {
          final a = SecretSantaCycle.generate(
            ps,
            groups: groups,
            random: Random(seed),
            maxShuffleAttempts: 0,
          );
          expectValid(ps, a, groups: groups);
        }
      }
    });
  });

  group('validate', () {
    test('accepts a correct cycle', () {
      expectValid([1, 2, 3], {1: 2, 2: 3, 3: 1});
    });

    test('detects two separate loops', () {
      final issues = SecretSantaCycle.validate(people(6), {
        1: 2,
        2: 3,
        3: 1,
        4: 5,
        5: 6,
        6: 4,
      });
      expect(
        issues.map((i) => i.type),
        contains(AssignmentIssueType.notSingleCycle),
      );
    });

    test('detects self-assignment, duplicates and missing people', () {
      final issues = SecretSantaCycle.validate(people(4), {1: 1, 2: 3, 3: 3});
      final types = issues.map((i) => i.type).toSet();
      expect(
        types,
        containsAll([
          AssignmentIssueType.selfAssignment,
          AssignmentIssueType.duplicateRecipient,
          AssignmentIssueType.missingGiver,
          AssignmentIssueType.missingRecipient,
        ]),
      );
    });

    test('detects unknown participants', () {
      final issues = SecretSantaCycle.validate(
        [1, 2, 3],
        {1: 2, 2: 3, 3: 1, 9: 1},
      );
      expect(
        issues.map((i) => i.type),
        contains(AssignmentIssueType.unknownParticipant),
      );
    });

    test('detects same-group pairs', () {
      final issues = SecretSantaCycle.validate(
        [1, 2, 3, 4],
        {1: 2, 2: 3, 3: 4, 4: 1},
        groups: {1: 'x', 2: 'X'},
      );
      expect(
        issues.map((i) => i.type),
        contains(AssignmentIssueType.sameGroup),
      );
    });
  });

  group('splice', () {
    test('reroutes the dropout\'s giver and changes only one email', () {
      final a = {1: 2, 2: 3, 3: 4, 4: 5, 5: 1};
      final result = SecretSantaCycle.splice(a, 3);
      expect(result.assignment, {1: 2, 2: 4, 4: 5, 5: 1});
      expect(result.changedGivers, {2});
      expectValid([1, 2, 4, 5], result.assignment);
    });

    test('refuses to go below 3 participants', () {
      expect(
        () => SecretSantaCycle.splice({1: 2, 2: 3, 3: 1}, 1),
        throwsA(isA<AssignmentException>()),
      );
    });

    test('throws for someone not in the exchange', () {
      expect(
        () => SecretSantaCycle.splice({1: 2, 2: 3, 3: 1}, 9),
        throwsArgumentError,
      );
    });

    test('relocates someone when the direct splice breaks an exclusion', () {
      // 1 and 3 are a couple; removing 2 would make 1 give to 3.
      final a = {1: 2, 2: 3, 3: 4, 4: 5, 5: 6, 6: 1};
      final groups = {1: 'couple', 3: 'couple'};
      for (var seed = 0; seed < 20; seed++) {
        final result = SecretSantaCycle.splice(
          a,
          2,
          groups: groups,
          random: Random(seed),
        );
        expectValid([1, 3, 4, 5, 6], result.assignment, groups: groups);
        expect(result.changedGivers, hasLength(3));
        // Everyone not listed as changed keeps their recipient.
        for (final giver in result.assignment.keys) {
          if (!result.changedGivers.contains(giver)) {
            expect(result.assignment[giver], a[giver]);
          }
        }
      }
    });

    test('keeps a valid cycle after repeated random dropouts', () {
      final rng = Random(7);
      final ps = people(25);
      final groups = {for (final p in ps) p: p <= 8 ? 'g${p % 4}' : null};
      var a = SecretSantaCycle.generate(ps, groups: groups, random: rng);
      final remaining = List.of(ps);
      while (remaining.length > 3) {
        final leaving = remaining.removeAt(rng.nextInt(remaining.length));
        try {
          a = SecretSantaCycle.splice(
            a,
            leaving,
            groups: groups,
            random: rng,
          ).assignment;
        } on AssignmentException catch (e) {
          expect(e.failure, AssignmentFailure.spliceViolatesExclusions);
          return; // Acceptable: the organizer would regenerate.
        }
        expectValid(remaining, a, groups: groups);
      }
    });
  });
}
