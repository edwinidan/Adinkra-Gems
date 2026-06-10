import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/board/move_validator.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart' hide MatchFinder;

void main() {
  group('MoveValidator', () {
    late MoveValidator validator;
    late BoardModel board;

    setUp(() {
      validator = MoveValidator();
      board = BoardModel();
    });

    // Helper to fill the board with a repeating pattern that guarantees:
    // 1. No starting matches
    // 2. Zero valid moves
    void fillEmptyBoard() {
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

    test('isAdjacent correctly flags orthogonal adjacency', () {
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(2, 3)), isTrue);
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(3, 2)), isTrue);
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(2, 1)), isTrue);
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(1, 2)), isTrue);

      // Diagonal
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(3, 3)), isFalse);
      // Same cell
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(2, 2)), isFalse);
      // Distant cell
      expect(validator.isAdjacent(const GridPosition(2, 2), const GridPosition(2, 4)), isFalse);
    });

    test('isValidSwap rejects non-adjacent cells', () {
      fillEmptyBoard();
      // Put matching gem types that are far apart
      board.set(const GridPosition(0, 0), TileModel(id: 't1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(0, 2), TileModel(id: 't2', gemType: GemType.yellowSankofa));

      expect(
        validator.isValidSwap(board, const GridPosition(0, 0), const GridPosition(0, 2)),
        isFalse,
      );
    });

    test('isValidSwap rejects adjacent cells that do not create a match', () {
      fillEmptyBoard();
      // Swapping (0, 0) and (0, 1) on alternating board won't produce a match
      expect(
        validator.isValidSwap(board, const GridPosition(0, 0), const GridPosition(0, 1)),
        isFalse,
      );
    });

    test('isValidSwap accepts adjacent cells that create a match', () {
      fillEmptyBoard();
      // Setup a board state where swapping (0, 2) and (0, 3) makes a match
      // At (0, 0) and (0, 1): yellowSankofa
      // At (0, 2): redFuntumfunefuDenkyemfunefu (needs to be swapped out)
      // At (0, 3): yellowSankofa (needs to be swapped in)
      board.set(const GridPosition(0, 0), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(0, 1), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(0, 2), TileModel(id: 'r1', gemType: GemType.redFuntumfunefuDenkyemfunefu));
      board.set(const GridPosition(0, 3), TileModel(id: 'y3', gemType: GemType.yellowSankofa));

      expect(
        validator.isValidSwap(board, const GridPosition(0, 2), const GridPosition(0, 3)),
        isTrue,
      );
    });

    test('hasAnyValidMove detects when a move is available', () {
      fillEmptyBoard();
      // Currently alternating, no moves
      expect(validator.hasAnyValidMove(board), isFalse);

      // Create one valid swap at row 4
      board.set(const GridPosition(4, 0), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(4, 1), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(4, 2), TileModel(id: 'r1', gemType: GemType.redFuntumfunefuDenkyemfunefu));
      board.set(const GridPosition(4, 3), TileModel(id: 'y3', gemType: GemType.yellowSankofa));

      expect(validator.hasAnyValidMove(board), isTrue);
    });
  });
}
