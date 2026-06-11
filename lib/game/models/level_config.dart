import 'board_layout.dart';
import '../board/grid_position.dart';
import 'gem_type.dart';
import 'initial_tile_definition.dart';
import 'level_difficulty.dart';
import 'level_objective.dart';
import 'star_thresholds.dart';
import 'cell_blocker_definition.dart';

/// Complete configuration for a single level.
///
/// Passed to [LevelController] (Phase 8) to drive all gameplay rules.
class LevelConfig {
  final String? levelId;

  final String episodeId;

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

  final LevelDifficulty difficulty;

  final BoardLayout boardLayout;

  final List<InitialTileDefinition> initialTiles;

  /// List of grid positions that have a clear mark beneath them.
  final List<GridPosition> clearMarkCells;

  /// List of clay pot blockers to place on the board.
  final List<CellBlockerDefinition> clayPotCells;

  final String? tutorialHint;

  final String? inGameHint;

  final double? targetPassRate;

  const LevelConfig({
    required this.levelNumber,
    required this.name,
    required this.objectives,
    required this.availableGems,
    required this.starThresholds,
    this.levelId,
    this.episodeId = 'episode_1',
    this.difficulty = LevelDifficulty.normal,
    this.boardLayout = const BoardLayout(),
    this.initialTiles = const [],
    this.clearMarkCells = const [],
    this.clayPotCells = const [],
    this.tutorialHint,
    this.inGameHint,
    this.targetPassRate,
    this.moveLimit,
    this.timeLimitSeconds,
  }) : assert(
         moveLimit != null || timeLimitSeconds != null,
         'A level must have at least one limit: moves or time.',
       );

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get id => levelId ?? 'level_$levelNumber';

  int get boardWidth => boardLayout.width;

  int get boardHeight => boardLayout.height;

  /// True if the level has a move limit.
  bool get hasMoveLimit => moveLimit != null;

  /// True if the level has a countdown timer.
  bool get hasTimer => timeLimitSeconds != null;

  List<String> validate() {
    final errors = <String>[];
    final prefix = 'Level $levelNumber ($id)';

    if (id.trim().isEmpty) {
      errors.add('$prefix must have a non-empty id.');
    }
    if (levelNumber < 1) {
      errors.add('$prefix must have a positive level number.');
    }
    if (objectives.isEmpty) {
      errors.add('$prefix must have at least one objective.');
    }
    if (moveLimit == null && timeLimitSeconds == null) {
      errors.add('$prefix must have a move or time limit.');
    }
    if (availableGems.toSet().length < 3) {
      errors.add('$prefix must provide at least three unique gem types.');
    }
    if (boardWidth < 3 || boardHeight < 3) {
      errors.add('$prefix board dimensions must be at least 3x3.');
    }
    if (boardLayout.activeCellCount < 9) {
      errors.add('$prefix must have at least nine active cells.');
    }
    for (final position in boardLayout.inactiveCells) {
      final insideBounds =
          position.row >= 0 &&
          position.row < boardHeight &&
          position.col >= 0 &&
          position.col < boardWidth;
      if (!insideBounds) {
        errors.add(
          '$prefix has an inactive cell outside the board: $position.',
        );
      }
    }
    if (boardLayout.inactiveCells.toSet().length !=
        boardLayout.inactiveCells.length) {
      errors.add('$prefix contains duplicate inactive cells.');
    }
    if (!(starThresholds.oneStar <= starThresholds.twoStar &&
        starThresholds.twoStar <= starThresholds.threeStar)) {
      errors.add('$prefix star thresholds must be ordered.');
    }
    if (targetPassRate != null &&
        (targetPassRate! <= 0 || targetPassRate! > 1)) {
      errors.add(
        '$prefix target pass rate must be greater than 0 and at most 1.',
      );
    }

    final occupied = <GridPosition>{};
    for (final tile in initialTiles) {
      if (!boardLayout.isActive(tile.position)) {
        errors.add(
          '$prefix initial tile is outside an active cell: ${tile.position}.',
        );
      }
      if (!availableGems.contains(tile.gemType)) {
        errors.add(
          '$prefix initial tile uses unavailable gem ${tile.gemType.name}.',
        );
      }
      if (!occupied.add(tile.position)) {
        errors.add('$prefix has duplicate initial tile at ${tile.position}.');
      }
    }

    final marked = <GridPosition>{};
    for (final pos in clearMarkCells) {
      if (!boardLayout.isActive(pos)) {
        errors.add('$prefix clear mark is outside an active cell: $pos.');
      }
      if (!marked.add(pos)) {
        errors.add('$prefix has duplicate clear mark at $pos.');
      }
    }

    final blocked = <GridPosition>{};
    for (final blocker in clayPotCells) {
      if (!boardLayout.isActive(blocker.position)) {
        errors.add('$prefix clay pot is outside an active cell: ${blocker.position}.');
      }
      if (blocker.layers < 1 || blocker.layers > 2) {
        errors.add('$prefix clay pot at ${blocker.position} has invalid layers: ${blocker.layers}.');
      }
      if (!blocked.add(blocker.position)) {
        errors.add('$prefix has duplicate clay pot at ${blocker.position}.');
      }
      if (occupied.contains(blocker.position)) {
        errors.add('$prefix has both an initial tile and a clay pot at ${blocker.position}.');
      }
    }

    return errors;
  }

  @override
  String toString() =>
      'LevelConfig(id: $id, level: $levelNumber, moves: $moveLimit, '
      'time: ${timeLimitSeconds}s, objectives: $objectives)';
}
