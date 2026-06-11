import 'dart:math';

import '../models/tile_model.dart';
import 'board_model.dart';
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
  static bool reshuffle(BoardModel board, {Random? random}) {
    final rng = random ?? Random();
    final finder = MatchFinder();
    final validator = MoveValidator(matchFinder: finder);

    // Extract all tiles currently on the board from unblocked playable positions
    final unblockedPositions = board.playablePositions.where((p) => !board.isBlocked(p)).toList();
    final tiles = unblockedPositions.map((p) => board.get(p)).whereType<TileModel>().toList();
    
    if (tiles.length < unblockedPositions.length) {
      // Board is incomplete (e.g. empty slots)
      return false;
    }

    for (int attempt = 0; attempt < 200; attempt++) {
      tiles.shuffle(rng);

      // Distribute shuffled tiles back onto the grid
      for (int index = 0; index < unblockedPositions.length; index++) {
        board.set(unblockedPositions[index], tiles[index]);
      }

      // Validate constraints
      if (!finder.hasAnyMatch(board) && validator.hasAnyValidMove(board)) {
        return true;
      }
    }

    return false;
  }
}
