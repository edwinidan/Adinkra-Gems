import '../models/cell_state.dart';
import '../models/tile_model.dart';
import 'grid_position.dart';

/// The core rectangular board data structure.
///
/// Holds a 2D grid of [TileModel]s and provides low-level access,
/// mutation, and cloning. Contains no game logic — all rules live
/// in MatchFinder, MoveValidator, and CascadeResolver.
class BoardModel {
  /// Legacy default dimensions used by existing tests and levels.
  static const int rows = 8;
  static const int cols = 8;

  final int rowCount;
  final int colCount;
  final Set<GridPosition> inactiveCells;
  final List<List<TileModel?>> _grid;
  final List<List<CellState>> _cellStates;

  /// Creates an empty board with optional inactive cells.
  BoardModel({
    this.rowCount = rows,
    this.colCount = cols,
    Iterable<GridPosition> inactiveCells = const [],
  }) : inactiveCells = Set.unmodifiable(inactiveCells),
       _grid = List.generate(
         rowCount,
         (_) => List<TileModel?>.filled(colCount, null, growable: false),
       ),
       _cellStates = List.generate(
         rowCount,
         (_) => List.generate(colCount, (_) => CellState(), growable: false),
       );

  /// Internal constructor used by [clone].
  BoardModel._internal({
    required this.rowCount,
    required this.colCount,
    required this.inactiveCells,
    required List<List<TileModel?>> grid,
    required List<List<CellState>> cellStates,
  }) : _grid = List.generate(
         rowCount,
         (row) => List<TileModel?>.from(grid[row], growable: false),
         growable: false,
       ),
       _cellStates = cellStates;

  // ── Cell access ───────────────────────────────────────────────────────────

  /// Returns the tile at [pos], or null if the cell is empty or out of bounds.
  TileModel? get(GridPosition pos) {
    if (!isPlayable(pos)) return null;
    return _grid[pos.row][pos.col];
  }

  /// Sets the tile at [pos]. Silently ignores out-of-bounds positions.
  void set(GridPosition pos, TileModel? tile) {
    if (!isPlayable(pos)) return;
    _grid[pos.row][pos.col] = tile;
  }
  
  /// Returns the terrain state of the cell at [pos], or null if out of bounds.
  CellState? getCellState(GridPosition pos) {
    if (!isPlayable(pos)) return null;
    return _cellStates[pos.row][pos.col];
  }
  
  /// Sets the terrain state of the cell at [pos].
  void setCellState(GridPosition pos, CellState state) {
    if (!isPlayable(pos)) return;
    _cellStates[pos.row][pos.col] = state;
  }

  /// Returns true if [pos] is within the rectangular board boundaries.
  bool isInBounds(GridPosition pos) =>
      pos.row >= 0 && pos.row < rowCount && pos.col >= 0 && pos.col < colCount;

  bool isPlayable(GridPosition pos) =>
      isInBounds(pos) && !inactiveCells.contains(pos);
      
  /// Returns true if the cell is blocked by a blocker like a Clay Pot.
  bool isBlocked(GridPosition pos) {
    final state = getCellState(pos);
    return state != null && state.isBlocker;
  }

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
      rowCount,
      (r) => List<TileModel?>.generate(
        colCount,
        (c) => _grid[r][c]?.copyWith(),
        growable: false,
      ),
    );
    final newCellStates = List.generate(
      rowCount,
      (r) => List<CellState>.generate(
        colCount,
        (c) => _cellStates[r][c].copyWith(),
        growable: false,
      ),
    );
    return BoardModel._internal(
      rowCount: rowCount,
      colCount: colCount,
      inactiveCells: inactiveCells,
      grid: newGrid,
      cellStates: newCellStates,
    );
  }

  // ── Utility ───────────────────────────────────────────────────────────────

  /// Flat list of every tile, in row-major order (row 0 first).
  List<TileModel?> get allTiles => [for (final row in _grid) ...row];

  /// All grid positions that currently contain a non-null tile.
  List<GridPosition> get filledPositions {
    final result = <GridPosition>[];
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < colCount; c++) {
        if (_grid[r][c] != null) result.add(GridPosition(r, c));
      }
    }
    return result;
  }

  List<GridPosition> get playablePositions => [
    for (int r = 0; r < rowCount; r++)
      for (int c = 0; c < colCount; c++)
        if (isPlayable(GridPosition(r, c))) GridPosition(r, c),
  ];
  
  List<GridPosition> get markPositions => [
    for (int r = 0; r < rowCount; r++)
      for (int c = 0; c < colCount; c++)
        if (isPlayable(GridPosition(r, c)) && _cellStates[r][c].hasMark) GridPosition(r, c),
  ];
  
  List<GridPosition> get potPositions => [
    for (int r = 0; r < rowCount; r++)
      for (int c = 0; c < colCount; c++)
        if (isPlayable(GridPosition(r, c)) && _cellStates[r][c].hasPot) GridPosition(r, c),
  ];

  int get playableCellCount => rowCount * colCount - inactiveCells.length;

  @override
  String toString() {
    final buffer = StringBuffer();
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < colCount; c++) {
        if (!isPlayable(GridPosition(r, c))) {
          buffer.write('#');
          if (c < colCount - 1) buffer.write(' ');
          continue;
        }
        if (isBlocked(GridPosition(r, c))) {
           buffer.write('O');
           if (c < colCount - 1) buffer.write(' ');
           continue;
        }
        final t = _grid[r][c];
        buffer.write(t == null ? '.' : t.gemType.name[0].toUpperCase());
        if (c < colCount - 1) buffer.write(' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
