import 'board_model.dart';
import 'grid_position.dart';
import 'match_finder.dart';
import '../models/special_gem_type.dart';

/// Validates whether a player's swap attempt is legal.
///
/// A swap is valid when:
///   1. The two positions are orthogonally adjacent.
///   2. After the swap, at least one of the swapped tiles participates
///      in a match-3 or longer, OR one of the swapped tiles is a color clear gem.
///
/// Invalid swaps do NOT consume moves and should animate a bounce-back.
class MoveValidator {
  final MatchFinder _matchFinder;

  MoveValidator({MatchFinder? matchFinder})
    : _matchFinder = matchFinder ?? MatchFinder();

  // ── Adjacency ─────────────────────────────────────────────────────────────

  /// Returns true if [a] and [b] are directly adjacent (no diagonals).
  bool isAdjacent(GridPosition a, GridPosition b) => a.isAdjacentTo(b);

  // ── Swap validity ─────────────────────────────────────────────────────────

  /// Returns true if swapping [a] and [b] on [board] would create a match or activate a power-up.
  ///
  /// Clones the board first so the real board is never mutated.
  bool isValidSwap(BoardModel board, GridPosition a, GridPosition b) {
    if (!isAdjacent(a, b)) return false;
    
    // Cannot swap blocked cells (e.g. Clay Pots)
    if (board.isBlocked(a) || board.isBlocked(b)) return false;

    final tileA = board.get(a);
    final tileB = board.get(b);
    if (tileA == null || tileB == null) return false;

    // Swapping a colorClear gem with any tile is always valid
    if (tileA.specialType == SpecialGemType.colorClear ||
        tileB.specialType == SpecialGemType.colorClear) {
      return true;
    }

    // Simulate on a clone — never touch the real board
    final simBoard = board.clone();
    simBoard.swap(a, b);

    return _matchFinder.hasAnyMatch(simBoard);
  }

  // ── Board-level helpers ───────────────────────────────────────────────────

  /// Returns true if the board currently has at least one valid swap available.
  ///
  /// Used by [BoardGenerator] and later by [ReshuffleService] to decide
  /// whether to reshuffle.
  bool hasAnyValidMove(BoardModel board) {
    for (int r = 0; r < board.rowCount; r++) {
      for (int c = 0; c < board.colCount; c++) {
        final pos = GridPosition(r, c);
        if (!board.isPlayable(pos)) continue;

        // Check the right neighbour
        if (c + 1 < board.colCount) {
          if (isValidSwap(board, pos, GridPosition(r, c + 1))) return true;
        }
        // Check the bottom neighbour
        if (r + 1 < board.rowCount) {
          if (isValidSwap(board, pos, GridPosition(r + 1, c))) return true;
        }
      }
    }
    return false;
  }
}
