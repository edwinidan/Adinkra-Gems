import '../board/grid_position.dart';

/// Describes the playable cells inside a rectangular board boundary.
///
/// Cells listed in [inactiveCells] are holes: they cannot contain gems and
/// break matches, but gravity can continue through other active cells in the
/// same column.
class BoardLayout {
  final int width;
  final int height;
  final List<GridPosition> inactiveCells;

  const BoardLayout({
    this.width = 8,
    this.height = 8,
    this.inactiveCells = const [],
  });

  bool isActive(GridPosition position) =>
      position.row >= 0 &&
      position.row < height &&
      position.col >= 0 &&
      position.col < width &&
      !inactiveCells.contains(position);

  int get activeCellCount => width * height - inactiveCells.toSet().length;
}
