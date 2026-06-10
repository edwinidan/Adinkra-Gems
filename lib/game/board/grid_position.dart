/// A value-type representing a cell position on the 8×8 board.
///
/// [row] is 0-indexed from the top; [col] is 0-indexed from the left.
class GridPosition {
  final int row;
  final int col;

  const GridPosition(this.row, this.col);

  // ── Adjacency ─────────────────────────────────────────────────────────────

  /// Returns true if [other] is directly adjacent (up/down/left/right).
  /// Diagonal positions are NOT considered adjacent.
  bool isAdjacentTo(GridPosition other) {
    final rowDiff = (row - other.row).abs();
    final colDiff = (col - other.col).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  // ── Neighbours ────────────────────────────────────────────────────────────

  /// Returns a list of the 4 orthogonal neighbour positions.
  /// Does NOT validate board bounds — callers must check.
  List<GridPosition> get neighbours => [
        GridPosition(row - 1, col), // up
        GridPosition(row + 1, col), // down
        GridPosition(row, col - 1), // left
        GridPosition(row, col + 1), // right
      ];

  // ── Equality ──────────────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) =>
      other is GridPosition && row == other.row && col == other.col;

  @override
  int get hashCode => Object.hash(row, col);

  @override
  String toString() => 'GridPosition($row, $col)';
}
