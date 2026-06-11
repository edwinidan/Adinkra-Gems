import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/cascade_resolver.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/models/combo_type.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/special_gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CascadeResolver - Special Combos', () {
    late BoardModel board;
    final availableGems = <GemType>[GemType.redFuntumfunefuDenkyemfunefu, GemType.blueDwennimmen];

    setUp(() {
      board = BoardModel(rowCount: 8, colCount: 8);
      // Fill the board with alternating gems to avoid natural matches
      for (int r = 0; r < board.rowCount; r++) {
        for (int c = 0; c < board.colCount; c++) {
          final gem = ((r + c) % 2 == 0) ? GemType.redFuntumfunefuDenkyemfunefu : GemType.blueDwennimmen;
          board.set(GridPosition(r, c), TileModel(id: 't_${r}_$c', gemType: gem));
        }
      }
    });

    test('Line + Line combo clears the row and column of the swap target', () {
      final posA = GridPosition(3, 3);
      final posB = GridPosition(3, 4);

      board.get(posA)!.specialType = SpecialGemType.horizontalBlast;
      board.get(posB)!.specialType = SpecialGemType.verticalBlast;

      // Simulate swap and resolution
      board.swap(posA, posB);
      final step = CascadeResolver.resolveStep(
        board,
        availableGems,
        swapA: posB, // The position of tileA after swap
        swapB: posA, // The position of tileB after swap
      );

      expect(step, isNotNull);
      expect(step!.triggeredCombo, ComboType.lineLine);
      expect(step.comboPosition, posB);

      // Verify row 3 and col 4 are marked for special clearing
      int clearedCount = 0;
      for (final sc in step.specialClears) {
        if (sc.position.row == 3 || sc.position.col == 4) {
          clearedCount++;
        }
      }
      
      // row has 8 cells, col has 8 cells, intersection is 1. 8 + 8 - 1 = 15.
      // But step.specialClears doesn't include the swap target if it was cleared differently? 
      // Actually, swapA and swapB are added to specialClears in the resolver.
      expect(clearedCount, 15);
    });

    test('Line + Burst combo clears 3 rows and 3 columns centered on swap target', () {
      final posA = GridPosition(4, 4);
      final posB = GridPosition(4, 5);

      board.get(posA)!.specialType = SpecialGemType.verticalBlast;
      board.get(posB)!.specialType = SpecialGemType.bomb;

      board.swap(posA, posB);
      final step = CascadeResolver.resolveStep(
        board,
        availableGems,
        swapA: posB,
        swapB: posA,
      );

      expect(step, isNotNull);
      expect(step!.triggeredCombo, ComboType.lineBurst);
      expect(step.comboPosition, posB);

      // 3 rows (3,4,5) and 3 cols (4,5,6) should be cleared
      bool foundOutside = false;
      for (final sc in step.specialClears) {
        bool inRows = sc.position.row >= 3 && sc.position.row <= 5;
        bool inCols = sc.position.col >= 4 && sc.position.col <= 6;
        if (!inRows && !inCols) {
          foundOutside = true;
        }
      }
      expect(foundOutside, false);
      
      // Calculate expected number of affected cells: 3 rows * 8 cols + 3 cols * 8 rows - 3*3 intersection = 24 + 24 - 9 = 39
      expect(step.specialClears.length, 39);
    });

    test('Burst + Burst combo clears a 5x5 area centered on swap target', () {
      final posA = GridPosition(3, 3);
      final posB = GridPosition(3, 4);

      board.get(posA)!.specialType = SpecialGemType.bomb;
      board.get(posB)!.specialType = SpecialGemType.bomb;

      board.swap(posA, posB);
      final step = CascadeResolver.resolveStep(
        board,
        availableGems,
        swapA: posB,
        swapB: posA,
      );

      expect(step, isNotNull);
      expect(step!.triggeredCombo, ComboType.burstBurst);
      expect(step.comboPosition, posB);

      // 5x5 area around posB (3, 4) -> Rows 1 to 5, Cols 2 to 6
      for (final sc in step.specialClears) {
        expect(sc.position.row, inInclusiveRange(1, 5));
        expect(sc.position.col, inInclusiveRange(2, 6));
      }
      
      expect(step.specialClears.length, 25);
    });
    
    test('Unity + Normal combo clears all normal gems of that color', () {
      final posA = GridPosition(3, 3); // Unity
      final posB = GridPosition(3, 4); // Red gem
      
      board.get(posA)!.specialType = SpecialGemType.colorClear;
      board.get(posA)!.gemType = GemType.yellowSankofa; // Color clear is visually sankofa usually
      
      board.get(posB)!.specialType = SpecialGemType.none;
      board.get(posB)!.gemType = GemType.redFuntumfunefuDenkyemfunefu;
      
      // Count how many red gems exist on board before swap
      int initialRedCount = 0;
      for (int r = 0; r < board.rowCount; r++) {
        for (int c = 0; c < board.colCount; c++) {
          if (board.get(GridPosition(r, c))?.gemType == GemType.redFuntumfunefuDenkyemfunefu) {
            initialRedCount++;
          }
        }
      }
      
      board.swap(posA, posB);
      final step = CascadeResolver.resolveStep(
        board,
        availableGems,
        swapA: posB,
        swapB: posA,
      );

      expect(step, isNotNull);
      expect(step!.triggeredCombo, ComboType.unityNormal);
      
      // Total cleared should be exactly the number of red gems + the unity gem itself
      expect(step.specialClears.length, initialRedCount + 1);
    });
  });
}
