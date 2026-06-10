import 'dart:math';

import '../models/tile_model.dart';
import 'board_model.dart';
import 'grid_position.dart';
import 'match_finder.dart';
import 'move_validator.dart';

/// Handles board reshuffling when no valid moves remain.
///
/// Shuffles the existing set of tiles in-place to preserve the color counts,
/// ensuring the player's collect objectives and board state remain fair.
class ReshuffleService {
  ReshuffleService._();

  /// Shuffles the existing non-null tiles on [board] until:
  ///   1. No automatic 3-matches are formed.
  ///   2. At least one valid move is available.
  ///
  /// Returns true if a valid board configuration was successfully generated
  /// from the existing tiles within 200 attempts.
  static bool reshuffle(
    BoardModel board, {
    Random? random,
  }) {
    final rng = random ?? Random();
    final finder = MatchFinder();
    final validator = MoveValidator(matchFinder: finder);

    // Extract all tiles currently on the board
    final tiles = board.allTiles.whereType<TileModel>().toList();
    if (tiles.length < BoardModel.rows * BoardModel.cols) {
      // Board is incomplete (e.g. empty slots)
      return false;
    }

    for (int attempt = 0; attempt < 200; attempt++) {
      tiles.shuffle(rng);

      // Distribute shuffled tiles back onto the grid
      int index = 0;
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          board.set(GridPosition(r, c), tiles[index]);
          index++;
        }
      }

      // Validate constraints
      if (!finder.hasAnyMatch(board) && validator.hasAnyValidMove(board)) {
        return true;
      }
    }

    return false;
  }
}
