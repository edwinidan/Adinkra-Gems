import 'gem_type.dart';

/// Defines what the player must achieve to win a level.
///
/// Levels can have one or more objectives. All must be satisfied
/// before the win condition is triggered.
sealed class LevelObjective {
  const LevelObjective();
}

// ─────────────────────────────────────────────────────────────────────────────
// Score objective
// ─────────────────────────────────────────────────────────────────────────────

/// Player must reach [targetScore] points before the level limit runs out.
final class ScoreObjective extends LevelObjective {
  /// Minimum score needed to complete this objective.
  final int targetScore;

  const ScoreObjective(this.targetScore);

  @override
  String toString() => 'ScoreObjective(target: $targetScore)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Collect objective
// ─────────────────────────────────────────────────────────────────────────────

/// Player must match and clear [count] tiles of [gemType].
final class CollectObjective extends LevelObjective {
  /// The gem colour the player must collect.
  final GemType gemType;

  /// How many tiles of [gemType] must be cleared.
  final int count;

  const CollectObjective({required this.gemType, required this.count});

  @override
  String toString() =>
      'CollectObjective(gemType: $gemType, count: $count)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Clear Mark objective
// ─────────────────────────────────────────────────────────────────────────────

/// Player must clear all marked cells on the board.
final class ClearMarkObjective extends LevelObjective {
  const ClearMarkObjective();

  @override
  String toString() => 'ClearMarkObjective()';
}

// ─────────────────────────────────────────────────────────────────────────────
// Clear Blocker objective
// ─────────────────────────────────────────────────────────────────────────────

/// Player must destroy all Clay Pot blockers.
final class ClearBlockerObjective extends LevelObjective {
  const ClearBlockerObjective();

  @override
  String toString() => 'ClearBlockerObjective()';
}
