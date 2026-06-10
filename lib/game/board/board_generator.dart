import 'dart:math';

import '../models/gem_type.dart';
import '../models/tile_model.dart';
import 'board_model.dart';
import 'grid_position.dart';
import 'match_finder.dart';
import 'move_validator.dart';

/// Generates a fully populated 8×8 [BoardModel] with two guarantees:
///
///   1. **No initial matches** — no row or column starts with 3+ identical gems.
///   2. **At least one valid move** — at least one adjacent swap creates a match.
///
/// Uses a seeded [Random] for deterministic generation in tests.
class BoardGenerator {
  static int _idCounter = 0;

  /// Generates an 8×8 board using the gem types in [availableGems].
  ///
  /// Pass [random] for deterministic output (useful in tests).
  static BoardModel generate(
    List<GemType> availableGems, {
    Random? random,
  }) {
    assert(availableGems.isNotEmpty, 'availableGems must not be empty');

    final rng = random ?? Random();
    final finder = MatchFinder();
    final validator = MoveValidator(matchFinder: finder);

    late BoardModel board;

    // Attempt up to 20 full board generations (the no-match fill is fast,
    // and the valid-move guarantee rarely needs more than 1-2 attempts)
    for (int attempt = 0; attempt < 20; attempt++) {
      board = _fillNoMatch(availableGems, rng);

      if (validator.hasAnyValidMove(board)) return board;

      // No valid move — try patching rather than regenerating from scratch
      if (_patchValidMove(board, availableGems, rng, finder, validator)) {
        return board;
      }
    }

    // Absolute fallback: force a known valid pattern into the top-left corner.
    // Layout: [A][A][B][A] at row 0, cols 0-3
    //   → swapping col 2 ↔ col 3 creates A A A B (match at 0-2).
    //   → no starting match since col 2 differs from its neighbours.
    _forceTopLeftPattern(board, availableGems);
    return board;
  }

  // ── Fill phase ────────────────────────────────────────────────────────────

  /// Fills the board cell-by-cell, skipping any gem type that would
  /// immediately create a horizontal or vertical 3-match.
  static BoardModel _fillNoMatch(List<GemType> gems, Random rng) {
    final board = BoardModel();

    for (int r = 0; r < BoardModel.rows; r++) {
      for (int c = 0; c < BoardModel.cols; c++) {
        final pos = GridPosition(r, c);
        final forbidden = _forbiddenAt(board, pos);

        final candidates =
            gems.where((g) => !forbidden.contains(g)).toList();

        // Fall back to all gems if every type is forbidden (extremely rare
        // with 6+ gem types, but handled for robustness)
        final pool = candidates.isEmpty ? gems : candidates;
        final gem = pool[rng.nextInt(pool.length)];

        board.set(pos, TileModel(id: _nextId(r, c), gemType: gem));
      }
    }

    return board;
  }

  /// Returns gem types that would create an immediate 3-match at [pos].
  static Set<GemType> _forbiddenAt(BoardModel board, GridPosition pos) {
    final forbidden = <GemType>{};
    final r = pos.row;
    final c = pos.col;

    // Horizontal: the two cells to the left are the same type?
    if (c >= 2) {
      final l1 = board.get(GridPosition(r, c - 1));
      final l2 = board.get(GridPosition(r, c - 2));
      if (l1 != null && l2 != null && l1.gemType == l2.gemType) {
        forbidden.add(l1.gemType);
      }
    }

    // Vertical: the two cells above are the same type?
    if (r >= 2) {
      final u1 = board.get(GridPosition(r - 1, c));
      final u2 = board.get(GridPosition(r - 2, c));
      if (u1 != null && u2 != null && u1.gemType == u2.gemType) {
        forbidden.add(u1.gemType);
      }
    }

    return forbidden;
  }

  // ── Patch phase ───────────────────────────────────────────────────────────

  /// Tries up to 200 random single-cell gem-type changes to create a
  /// valid move without introducing a new match.
  ///
  /// Returns true if a valid board was achieved.
  static bool _patchValidMove(
    BoardModel board,
    List<GemType> gems,
    Random rng,
    MatchFinder finder,
    MoveValidator validator,
  ) {
    for (int attempt = 0; attempt < 200; attempt++) {
      final r = rng.nextInt(BoardModel.rows);
      final c = rng.nextInt(BoardModel.cols);
      final pos = GridPosition(r, c);
      final original = board.get(pos);
      if (original == null) continue;

      // Try a different gem type at this position
      final newGem = gems[rng.nextInt(gems.length)];
      if (newGem == original.gemType) continue;

      board.set(pos, original.copyWith(gemType: newGem));

      // Accept only if it doesn't introduce a new match AND creates a valid move
      if (!finder.hasAnyMatch(board) && validator.hasAnyValidMove(board)) {
        return true;
      }

      board.set(pos, original); // revert
    }
    return false;
  }

  // ── Absolute fallback ─────────────────────────────────────────────────────

  /// Places [A][A][B][A] in row 0, cols 0–3.
  ///
  /// Swapping col 2 ↔ col 3 → [A][A][A][B] = valid 3-match at 0,1,2.
  /// There is no starting match since position 2 breaks the A-A run.
  static void _forceTopLeftPattern(
      BoardModel board, List<GemType> gems) {
    final gemA = gems[0];
    final gemB = gems.length > 1 ? gems[1] : gems[0];

    board.set(GridPosition(0, 0), TileModel(id: _nextId(0, 0), gemType: gemA));
    board.set(GridPosition(0, 1), TileModel(id: _nextId(0, 1), gemType: gemA));
    board.set(GridPosition(0, 2), TileModel(id: _nextId(0, 2), gemType: gemB));
    board.set(GridPosition(0, 3), TileModel(id: _nextId(0, 3), gemType: gemA));
  }

  // ── ID helper ─────────────────────────────────────────────────────────────

  static String _nextId(int r, int c) {
    _idCounter++;
    return 'tile_${r}_${c}_$_idCounter';
  }
}
