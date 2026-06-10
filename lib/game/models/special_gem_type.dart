/// Special power-up types that a gem tile can hold.
///
/// Tiles start as [none]. Special types are assigned by the
/// MatchClassifier in a later phase when a match of 4+ is detected.
enum SpecialGemType {
  /// Regular gem — no special ability.
  none,

  /// Created by a match of 4 in a row.
  /// Clears the entire row when activated.
  horizontalBlast,

  /// Created by a match of 4 in a column.
  /// Clears the entire column when activated.
  verticalBlast,

  /// Created by a match of 5 in a line.
  /// Clears all gems of a chosen colour from the board.
  colorClear,

  /// Created by an L-shape or T-shape match.
  /// Clears a 3×3 area around itself.
  bomb,
}
