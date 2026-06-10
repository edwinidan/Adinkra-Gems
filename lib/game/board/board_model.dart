import '../models/tile_model.dart';
import 'grid_position.dart';

/// The core 8×8 board data structure.
///
/// Holds a 2D grid of [TileModel]s and provides low-level access,
/// mutation, and cloning. Contains no game logic — all rules live
/// in MatchFinder, MoveValidator, and CascadeResolver.
class BoardModel {
  /// Number of rows on the board.
  static const int rows = 8;

  /// Number of columns on the board.
  static const int cols = 8;

  final List<List<TileModel?>> _grid;

  /// Creates an empty 8×8 board (all cells null).
  BoardModel()
      : _grid = List.generate(
          rows,
          (_) => List<TileModel?>.filled(cols, null, growable: false),
        );

  /// Internal constructor used by [clone].
  BoardModel._internal(this._grid);

  // ── Cell access ───────────────────────────────────────────────────────────

  /// Returns the tile at [pos], or null if the cell is empty or out of bounds.
  TileModel? get(GridPosition pos) {
    if (!isInBounds(pos)) return null;
    return _grid[pos.row][pos.col];
  }

  /// Sets the tile at [pos]. Silently ignores out-of-bounds positions.
  void set(GridPosition pos, TileModel? tile) {
    if (!isInBounds(pos)) return;
    _grid[pos.row][pos.col] = tile;
  }

  /// Returns true if [pos] is within the 8×8 grid boundaries.
  bool isInBounds(GridPosition pos) =>
      pos.row >= 0 &&
      pos.row < rows &&
      pos.col >= 0 &&
      pos.col < cols;

  // ── Mutation ──────────────────────────────────────────────────────────────

  /// Swaps the tiles at positions [a] and [b].
  /// Out-of-bounds positions are silently ignored.
  void swap(GridPosition a, GridPosition b) {
    final temp = get(a);
    set(a, get(b));
    set(b, temp);
  }

  // ── Clone ─────────────────────────────────────────────────────────────────

  /// Returns a full deep copy of the board.
  /// Used by [MoveValidator] to simulate moves without mutating the real board.
  BoardModel clone() {
    final newGrid = List.generate(
      rows,
      (r) => List<TileModel?>.generate(
        cols,
        (c) => _grid[r][c]?.copyWith(),
        growable: false,
      ),
    );
    return BoardModel._internal(newGrid);
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  /// Flat list of every tile, in row-major order (row 0 first).
  List<TileModel?> get allTiles =>
      [for (final row in _grid) ...row];

  /// All grid positions that currently contain a non-null tile.
  List<GridPosition> get filledPositions {
    final result = <GridPosition>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (_grid[r][c] != null) result.add(GridPosition(r, c));
      }
    }
    return result;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final t = _grid[r][c];
        buffer.write(t == null ? '.' : t.gemType.name[0].toUpperCase());
        if (c < cols - 1) buffer.write(' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
