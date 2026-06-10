import 'gem_type.dart';
import 'special_gem_type.dart';

/// Data model for a single gem tile on the board.
///
/// This is a pure logic model — all rendering is handled separately
/// by TileComponent (added in Phase 5).
class TileModel {
  /// Unique identifier used to track this tile across animations.
  final String id;

  /// The visual/logical gem colour.
  GemType gemType;

  /// The special power-up type. Defaults to [SpecialGemType.none].
  SpecialGemType specialType;

  /// True while this tile is part of a detected match (awaiting removal).
  bool isMatched;

  /// True while this tile is falling into a gap below.
  bool isFalling;

  TileModel({
    required this.id,
    required this.gemType,
    this.specialType = SpecialGemType.none,
    this.isMatched = false,
    this.isFalling = false,
  });

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns true if this tile has any special type assigned.
  bool get isSpecial => specialType != SpecialGemType.none;

  /// Returns a shallow copy with selected fields overridden.
  TileModel copyWith({
    String? id,
    GemType? gemType,
    SpecialGemType? specialType,
    bool? isMatched,
    bool? isFalling,
  }) {
    return TileModel(
      id: id ?? this.id,
      gemType: gemType ?? this.gemType,
      specialType: specialType ?? this.specialType,
      isMatched: isMatched ?? this.isMatched,
      isFalling: isFalling ?? this.isFalling,
    );
  }

  @override
  String toString() =>
      'TileModel(id: $id, gem: $gemType, special: $specialType)';
}
