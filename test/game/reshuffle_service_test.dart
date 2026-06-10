import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/board/match_finder.dart';
import 'package:adinkra_gems/game/board/move_validator.dart';
import 'package:adinkra_gems/game/board/reshuffle_service.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart' hide MatchFinder;

void main() {
  group('ReshuffleService', () {
    late BoardModel board;
    final validator = MoveValidator();
    final finder = MatchFinder();

    setUp(() {
      board = BoardModel();
    });

    // Fills the board with a repeating pattern that guarantees no matches and zero valid moves
    void fillZeroValidMovesBoard() {
      int id = 0;
      final gems = GemType.values;
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          final gemIndex = (r % 2 == 0) ? (c % 3) : (3 + (c % 3));
          final gem = gems[gemIndex];
          board.set(GridPosition(r, c), TileModel(id: 'tile_$id', gemType: gem));
          id++;
        }
      }
    }

    test('successfully shuffles a deadlocked board to a playable state and preserves gem counts', () {
      fillZeroValidMovesBoard();

      // Verify initial deadlock
      expect(finder.hasAnyMatch(board), isFalse);
      expect(validator.hasAnyValidMove(board), isFalse);

      // Record counts of each gem type before shuffling
      final preCounts = <GemType, int>{};
      for (final type in GemType.values) {
        preCounts[type] = board.allTiles.where((t) => t?.gemType == type).length;
      }

      // Shuffle
      final success = ReshuffleService.reshuffle(board);

      expect(success, isTrue);

      // Verify new state constraints
      expect(finder.hasAnyMatch(board), isFalse, reason: 'Shuffled board should have no immediate matches');
      expect(validator.hasAnyValidMove(board), isTrue, reason: 'Shuffled board should have at least one valid move');

      // Verify that gem type counts are perfectly preserved
      for (final type in GemType.values) {
        final postCount = board.allTiles.where((t) => t?.gemType == type).length;
        expect(postCount, preCounts[type], reason: 'Count of gem type $type should be preserved');
      }
    });
  });
}
