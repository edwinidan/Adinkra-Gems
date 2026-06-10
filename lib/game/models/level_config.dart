import 'gem_type.dart';
import 'level_objective.dart';
import 'star_thresholds.dart';

/// Complete configuration for a single level.
///
/// Passed to [LevelController] (Phase 8) to drive all gameplay rules.
class LevelConfig {
  /// 1-indexed level number.
  final int levelNumber;

  /// Human-readable name shown in the level select (optional).
  final String name;

  /// One or more objectives the player must complete to win.
  /// All objectives must be satisfied simultaneously.
  final List<LevelObjective> objectives;

  /// Maximum number of player swaps allowed.
  /// Null means the level is purely time-based (no move limit).
  final int? moveLimit;

  /// Time limit in seconds.
  /// Null means the level has no timer (move-based only).
  final int? timeLimitSeconds;

  /// Which gem types appear on the board for this level.
  /// For all 10 initial levels we use all 6 gem types.
  final List<GemType> availableGems;

  /// Score thresholds used to award 1–3 stars at level end.
  final StarThresholds starThresholds;

  const LevelConfig({
    required this.levelNumber,
    required this.name,
    required this.objectives,
    required this.availableGems,
    required this.starThresholds,
    this.moveLimit,
    this.timeLimitSeconds,
  }) : assert(
          moveLimit != null || timeLimitSeconds != null,
          'A level must have at least one limit: moves or time.',
        );

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// True if the level has a move limit.
  bool get hasMoveLimit => moveLimit != null;

  /// True if the level has a countdown timer.
  bool get hasTimer => timeLimitSeconds != null;

  @override
  String toString() =>
      'LevelConfig(level: $levelNumber, moves: $moveLimit, '
      'time: ${timeLimitSeconds}s, objectives: $objectives)';
}
