import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/cascade_resolver.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/special_gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CascadeResolver - Special Tiles', () {
    late BoardModel board;
    const available = GemType.values;

    setUp(() {
      board = BoardModel();
    });

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

    test('Match 4 horizontal creates a horizontal blast', () {
      fillAlternativeBoard();
      // Match 4 yellowSankofa at row 7, cols 0..3
      board.set(const GridPosition(7, 0), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 1), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 2), TileModel(id: 'y3', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 3), TileModel(id: 'y4', gemType: GemType.yellowSankofa));

      final step = CascadeResolver.resolveStep(
        board,
        available,
        swapA: const GridPosition(7, 1),
        swapB: const GridPosition(6, 1), // Swap coordinate
      );

      expect(step, isNotNull);
      expect(step!.createdSpecials.containsKey(const GridPosition(7, 1)), isTrue);
      expect(step.createdSpecials[const GridPosition(7, 1)], SpecialGemType.horizontalBlast);

      // Check board model state after resolveStep: spawn location must have the special tile!
      final targetTile = board.get(const GridPosition(7, 1));
      expect(targetTile, isNotNull);
      expect(targetTile!.specialType, SpecialGemType.horizontalBlast);
      expect(targetTile.gemType, GemType.yellowSankofa);
    });

    test('Match 5 creates a colorClear tile', () {
      fillAlternativeBoard();
      // Match 5 yellowSankofa at row 7, cols 0..4
      for (int c = 0; c < 5; c++) {
        board.set(GridPosition(7, c), TileModel(id: 'y$c', gemType: GemType.yellowSankofa));
      }

      final step = CascadeResolver.resolveStep(
        board,
        available,
        swapA: const GridPosition(7, 2),
        swapB: const GridPosition(6, 2),
      );

      expect(step, isNotNull);
      expect(step!.createdSpecials.containsKey(const GridPosition(7, 2)), isTrue);
      expect(step.createdSpecials[const GridPosition(7, 2)], SpecialGemType.colorClear);

      final targetTile = board.get(const GridPosition(7, 2));
      expect(targetTile, isNotNull);
      expect(targetTile!.specialType, SpecialGemType.colorClear);
    });

    test('L-shape match creates a bomb tile', () {
      fillAlternativeBoard();
      // L shape: horizontal 3 at row 7 cols 0..2, vertical 3 at col 2 rows 5..7
      // YellowSankofa at: (7,0), (7,1), (7,2), (6,2), (5,2)
      board.set(const GridPosition(7, 0), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 1), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 2), TileModel(id: 'y3', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(6, 2), TileModel(id: 'y4', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(5, 2), TileModel(id: 'y5', gemType: GemType.yellowSankofa));

      final step = CascadeResolver.resolveStep(board, available);

      expect(step, isNotNull);
      // Bomb should spawn at the intersection: (7, 2)
      expect(step!.createdSpecials.containsKey(const GridPosition(7, 2)), isTrue);
      expect(step.createdSpecials[const GridPosition(7, 2)], SpecialGemType.bomb);

      final targetTile = board.get(const GridPosition(7, 2));
      expect(targetTile, isNotNull);
      expect(targetTile!.specialType, SpecialGemType.bomb);
    });

    test('ColorClear swap clears all gems of the swapped color', () {
      fillAlternativeBoard();
      // Put a colorClear at (7, 0)
      board.set(
        const GridPosition(7, 0),
        TileModel(id: 'cc', gemType: GemType.redFuntumfunefuDenkyemfunefu, specialType: SpecialGemType.colorClear),
      );
      // Explicitly set (7, 1) to silverNsoromma
      board.set(
        const GridPosition(7, 1),
        TileModel(id: 'swap_target', gemType: GemType.silverNsoromma),
      );
      // Swapped with silverNsoromma at (7, 1)
      final step = CascadeResolver.resolveStep(
        board,
        available,
        swapA: const GridPosition(7, 0),
        swapB: const GridPosition(7, 1),
      );

      expect(step, isNotNull);
      // The colorClear gem itself and all silverNsoromma gems should be cleared.
      expect(step!.specialClears.isNotEmpty, isTrue);
      expect(step.specialClears.any((sc) => sc.tile.gemType == GemType.silverNsoromma), isTrue);
    });

    test('Blast activation clears the whole row recursively', () {
      fillAlternativeBoard();
      // Put a horizontal blast at (7, 2)
      final blastTile = TileModel(
        id: 'blast',
        gemType: GemType.yellowSankofa,
        specialType: SpecialGemType.horizontalBlast,
      );
      board.set(const GridPosition(7, 2), blastTile);

      // Create a match-3 involving the blast tile: (7, 2), (7, 3), (7, 4)
      board.set(const GridPosition(7, 3), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 4), TileModel(id: 'y2', gemType: GemType.yellowSankofa));

      final step = CascadeResolver.resolveStep(board, available);

      expect(step, isNotNull);
      // Should clear the whole row 7
      for (int c = 0; c < BoardModel.cols; c++) {
        final pos = GridPosition(7, c);
        // All original tiles at row 7 should be cleared (meaning they either fall or new ones spawn)
        if (c != 2 && c != 3 && c != 4) {
          expect(step!.specialClears.any((sc) => sc.position == pos), isTrue);
        }
      }
    });

    test('Chain reaction: horizontal blast triggers bomb recursively', () {
      fillAlternativeBoard();
      // Put a horizontal blast at (7, 0) and a bomb at (7, 4)
      board.set(
        const GridPosition(7, 0),
        TileModel(id: 'blast', gemType: GemType.yellowSankofa, specialType: SpecialGemType.horizontalBlast),
      );
      board.set(
        const GridPosition(7, 4),
        TileModel(id: 'bomb', gemType: GemType.silverNsoromma, specialType: SpecialGemType.bomb),
      );

      // Match-3 at row 7, cols 0..2
      board.set(const GridPosition(7, 1), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(7, 2), TileModel(id: 'y2', gemType: GemType.yellowSankofa));

      final step = CascadeResolver.resolveStep(board, available);

      expect(step, isNotNull);
      // Row 7 is cleared by the blast. Row 7 col 4 (the bomb) is triggered.
      // Bomb should clear 3x3 surrounding it: row 6 col 3..5, row 7 col 3..5
      expect(step!.specialClears.any((sc) => sc.position == const GridPosition(6, 3)), isTrue);
      expect(step.specialClears.any((sc) => sc.position == const GridPosition(6, 4)), isTrue);
      expect(step.specialClears.any((sc) => sc.position == const GridPosition(6, 5)), isTrue);
    });
  });
}
