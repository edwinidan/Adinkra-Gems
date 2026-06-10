import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/cascade_resolver.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart' hide MatchFinder;

void main() {
  group('CascadeResolver', () {
    late BoardModel board;
    const available = GemType.values;

    setUp(() {
      board = BoardModel();
    });

    // Helper to fill the board with a repeating pattern (no matches)
    void fillAlternativeBoard() {
      int id = 0;
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          final gem = ((r + c) % 2 == 0)
              ? GemType.redFuntumfunefuDenkyemfunefu
              : GemType.silverNsoromma;
          board.set(GridPosition(r, c), TileModel(id: 'tile_$id', gemType: gem));
          id++;
        }
      }
    }

    test('resolveStep returns null if there are no matches', () {
      fillAlternativeBoard();
      final step = CascadeResolver.resolveStep(board, available);
      expect(step, isNull);
    });

    test('resolves a simple horizontal match-3, dropping tiles above and spawning new ones', () {
      fillAlternativeBoard();

      // Create a match-3 of yellowSankofa at bottom-left: (7, 0), (7, 1), (7, 2)
      board.set(const GridPosition(7, 0), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 1), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 2), TileModel(id: 'y3', gemType: GemType.yellowSankofa));

      // Record which tiles are at row 6 (directly above the match)
      final originalRow6Col0 = board.get(const GridPosition(6, 0))!;
      final originalRow6Col1 = board.get(const GridPosition(6, 1))!;
      final originalRow6Col2 = board.get(const GridPosition(6, 2))!;

      final step = CascadeResolver.resolveStep(board, available);

      expect(step, isNotNull);
      expect(step!.matches.length, 1);
      expect(step.matches.first.gemType, GemType.yellowSankofa);
      expect(step.matches.first.length, 3);

      // Verify that tiles at row 6 fell down to row 7
      expect(board.get(const GridPosition(7, 0))!.id, originalRow6Col0.id);
      expect(board.get(const GridPosition(7, 1))!.id, originalRow6Col1.id);
      expect(board.get(const GridPosition(7, 2))!.id, originalRow6Col2.id);

      // Verify that falls were recorded
      expect(step.falls.any((f) => f.from == const GridPosition(6, 0) && f.to == const GridPosition(7, 0)), isTrue);
      expect(step.falls.any((f) => f.from == const GridPosition(6, 1) && f.to == const GridPosition(7, 1)), isTrue);
      expect(step.falls.any((f) => f.from == const GridPosition(6, 2) && f.to == const GridPosition(7, 2)), isTrue);

      // Verify that spawns were recorded (one for each empty space at the top of col 0, 1, 2)
      expect(step.spawns.any((s) => s.to == const GridPosition(0, 0)), isTrue);
      expect(step.spawns.any((s) => s.to == const GridPosition(0, 1)), isTrue);
      expect(step.spawns.any((s) => s.to == const GridPosition(0, 2)), isTrue);

      // Verify no null tiles left on the board
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          expect(board.get(GridPosition(r, c)), isNotNull);
        }
      }
    });
  });
}
