import 'dart:math';

import 'package:adinkra_gems/game/board/board_generator.dart';
import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/board/match_finder.dart';
import 'package:adinkra_gems/game/board/move_validator.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:flutter_test/flutter_test.dart' hide MatchFinder;

const _allGems = GemType.values;

void main() {
  group('BoardGenerator', () {
    test('fills all 64 cells', () {
      final board = BoardGenerator.generate(_allGems, random: Random(42));
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          expect(
            board.get(GridPosition(r, c)),
            isNotNull,
            reason: 'Cell ($r,$c) should not be null',
          );
        }
      }
    });

    test('starting board has no matches', () {
      final finder = MatchFinder();
      for (int seed = 0; seed < 20; seed++) {
        final board = BoardGenerator.generate(_allGems, random: Random(seed));
        final matches = finder.findMatches(board);
        expect(
          matches,
          isEmpty,
          reason: 'Seed $seed: board should have no initial matches',
        );
      }
    });

    test('starting board has at least one valid move', () {
      final validator = MoveValidator();
      for (int seed = 0; seed < 20; seed++) {
        final board = BoardGenerator.generate(_allGems, random: Random(seed));
        expect(
          validator.hasAnyValidMove(board),
          isTrue,
          reason: 'Seed $seed: board should have at least one valid move',
        );
      }
    });

    test('only uses gem types from availableGems', () {
      const limited = [GemType.yellowSankofa, GemType.blueDwennimmen];
      final board =
          BoardGenerator.generate(limited, random: Random(99));

      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          final tile = board.get(GridPosition(r, c))!;
          expect(
            limited.contains(tile.gemType),
            isTrue,
            reason: 'Cell ($r,$c) has unexpected gem type ${tile.gemType}',
          );
        }
      }
    });
  });
}
