import '../board/grid_position.dart';
import 'gem_type.dart';
import 'special_gem_type.dart';

/// Represents a group of matching tiles detected on the board.
///
/// A match is valid when [positions] contains 3 or more entries
/// of the same [gemType] in a row or column.
///
/// Can optionally declare that the match creates a [SpecialGemType]
/// at a specific [specialSpawnPosition].
class MatchGroup {
  /// All board positions that belong to this match.
  final List<GridPosition> positions;

  /// The gem type shared by all tiles in this match.
  final GemType gemType;

  /// The type of special gem this match creates, if any.
  final SpecialGemType specialCreated;

  /// The board coordinate where the new special tile should spawn.
  final GridPosition? specialSpawnPosition;

  const MatchGroup({
    required this.positions,
    required this.gemType,
    this.specialCreated = SpecialGemType.none,
    this.specialSpawnPosition,
  });

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Number of tiles in this match.
  int get length => positions.length;

  /// True when this group contains the minimum 3 tiles for a valid match.
  bool get isValid => length >= 3;

  /// True for a 4-in-a-line match (triggers a blast special gem).
  bool get isFour => length == 4;

  /// True for a 5-in-a-line match (triggers a color-clear special gem).
  bool get isFive => length >= 5;

  @override
  String toString() =>
      'MatchGroup(gemType: $gemType, count: $length, positions: $positions, '
      'specialCreated: $specialCreated, spawn: $specialSpawnPosition)';
}
