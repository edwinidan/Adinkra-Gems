import 'package:adinkra_gems/game/board/board_model.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/board/match_finder.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/special_gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart' hide MatchFinder;

void main() {
  group('MatchFinder', () {
    late MatchFinder finder;
    late BoardModel board;

    setUp(() {
      finder = MatchFinder();
      board = BoardModel();
    });

    // Helper to fill the board with random/distinct gems to avoid accidental matches
    void fillEmptyBoard() {
      int id = 0;
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          // Alternating pattern so no matches of 3 are formed
          // e.g. red, silver, red, silver...
          // and next row offset: silver, red, silver, red...
          final gem = ((r + c) % 2 == 0)
              ? GemType.redFuntumfunefuDenkyemfunefu
              : GemType.silverNsoromma;
          board.set(GridPosition(r, c), TileModel(id: 'tile_$id', gemType: gem));
          id++;
        }
      }
    }

    test('no matches on a clean alternating board', () {
      fillEmptyBoard();
      expect(finder.hasAnyMatch(board), isFalse);
      expect(finder.findMatches(board), isEmpty);
    });

    test('detects simple horizontal match-3', () {
      fillEmptyBoard();
      // Force a match-3 of yellowSankofa at (2, 2), (2, 3), (2, 4)
      board.set(const GridPosition(2, 2), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(2, 3), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(2, 4), TileModel(id: 'y3', gemType: GemType.yellowSankofa));

      expect(finder.hasAnyMatch(board), isTrue);
      final matches = finder.findMatches(board);
      expect(matches.length, 1);
      expect(matches.first.gemType, GemType.yellowSankofa);
      expect(matches.first.length, 3);
      expect(matches.first.positions, containsAll([
        const GridPosition(2, 2),
        const GridPosition(2, 3),
        const GridPosition(2, 4),
      ]));
    });

    test('detects simple vertical match-4', () {
      fillEmptyBoard();
      // Force a match-4 of blueDwennimmen at (1, 5), (2, 5), (3, 5), (4, 5)
      board.set(const GridPosition(1, 5), TileModel(id: 'b1', gemType: GemType.blueDwennimmen));
      board.set(const GridPosition(2, 5), TileModel(id: 'b2', gemType: GemType.blueDwennimmen));
      board.set(const GridPosition(3, 5), TileModel(id: 'b3', gemType: GemType.blueDwennimmen));
      board.set(const GridPosition(4, 5), TileModel(id: 'b4', gemType: GemType.blueDwennimmen));

      expect(finder.hasAnyMatch(board), isTrue);
      final matches = finder.findMatches(board);
      expect(matches.length, 1);
      expect(matches.first.gemType, GemType.blueDwennimmen);
      expect(matches.first.length, 4);
      expect(matches.first.isFour, isTrue);
      expect(matches.first.isFive, isFalse);
      expect(matches.first.positions, containsAll([
        const GridPosition(1, 5),
        const GridPosition(2, 5),
        const GridPosition(3, 5),
        const GridPosition(4, 5),
      ]));
    });

    test('detects intersecting horizontal and vertical matches', () {
      fillEmptyBoard();
      // Horizontal run at row 3: cols 1, 2, 3 (purpleAkofena)
      board.set(const GridPosition(3, 1), TileModel(id: 'p1', gemType: GemType.purpleAkofena));
      board.set(const GridPosition(3, 2), TileModel(id: 'p2', gemType: GemType.purpleAkofena));
      board.set(const GridPosition(3, 3), TileModel(id: 'p3', gemType: GemType.purpleAkofena));

      // Vertical run at col 3: rows 2, 3, 4 (purpleAkofena)
      // They share (3, 3)
      board.set(const GridPosition(2, 3), TileModel(id: 'p4', gemType: GemType.purpleAkofena));
      board.set(const GridPosition(4, 3), TileModel(id: 'p5', gemType: GemType.purpleAkofena));

      expect(finder.hasAnyMatch(board), isTrue);
      final matches = finder.findMatches(board);
      expect(matches.length, 1);

      final combinedMatch = matches.first;
      expect(combinedMatch.gemType, GemType.purpleAkofena);
      expect(combinedMatch.specialCreated, SpecialGemType.bomb);
      expect(combinedMatch.specialSpawnPosition, const GridPosition(3, 3));
      expect(combinedMatch.positions, containsAll([
        const GridPosition(3, 1),
        const GridPosition(3, 2),
        const GridPosition(3, 3),
        const GridPosition(2, 3),
        const GridPosition(4, 3),
      ]));
    });

    test('matchesAt returns only matches involving a given cell', () {
      fillEmptyBoard();
      // Match 1: Row 1, cols 1, 2, 3 (yellowSankofa)
      board.set(const GridPosition(1, 1), TileModel(id: 'y1', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(1, 2), TileModel(id: 'y2', gemType: GemType.yellowSankofa));
      board.set(const GridPosition(1, 3), TileModel(id: 'y3', gemType: GemType.yellowSankofa));

      // Match 2: Row 5, cols 5, 6, 7 (greenGyeNyame)
      board.set(const GridPosition(5, 5), TileModel(id: 'g1', gemType: GemType.greenGyeNyame));
      board.set(const GridPosition(5, 6), TileModel(id: 'g2', gemType: GemType.greenGyeNyame));
      board.set(const GridPosition(5, 7), TileModel(id: 'g3', gemType: GemType.greenGyeNyame));

      final matchesAtY2 = finder.matchesAt(board, const GridPosition(1, 2));
      expect(matchesAtY2.length, 1);
      expect(matchesAtY2.first.gemType, GemType.yellowSankofa);

      final matchesAtG1 = finder.matchesAt(board, const GridPosition(5, 5));
      expect(matchesAtG1.length, 1);
      expect(matchesAtG1.first.gemType, GemType.greenGyeNyame);

      final matchesAtEmpty = finder.matchesAt(board, const GridPosition(0, 0));
      expect(matchesAtEmpty, isEmpty);
    });
  });
}
