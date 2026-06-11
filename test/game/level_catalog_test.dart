import 'dart:math';

import 'package:adinkra_gems/game/board/board_generator.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/board/match_finder.dart';
import 'package:adinkra_gems/game/board/move_validator.dart';
import 'package:adinkra_gems/game/data/level_catalog.dart';
import 'package:adinkra_gems/game/data/levels.dart';
import 'package:adinkra_gems/game/models/board_layout.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/initial_tile_definition.dart';
import 'package:adinkra_gems/game/models/level_config.dart';
import 'package:adinkra_gems/game/models/level_objective.dart';
import 'package:adinkra_gems/game/models/special_gem_type.dart';
import 'package:adinkra_gems/game/models/star_thresholds.dart';
import 'package:flutter_test/flutter_test.dart' hide MatchFinder;

const _stars = StarThresholds(oneStar: 100, twoStar: 200, threeStar: 300);

LevelConfig makeLevel({
  int number = 1,
  String? id,
  BoardLayout layout = const BoardLayout(),
  List<InitialTileDefinition> initialTiles = const [],
  List<GemType> gems = GemType.values,
  StarThresholds thresholds = _stars,
}) {
  return LevelConfig(
    levelId: id,
    levelNumber: number,
    name: 'Test $number',
    objectives: const [ScoreObjective(100)],
    moveLimit: 10,
    availableGems: gems,
    starThresholds: thresholds,
    boardLayout: layout,
    initialTiles: initialTiles,
  );
}

void main() {
  group('LevelCatalog', () {
    test('loads levels by number and id', () {
      final catalog = LevelCatalog([
        makeLevel(number: 1, id: 'first'),
        makeLevel(number: 2, id: 'second'),
      ]);

      expect(catalog.requireByNumber(1).id, 'first');
      expect(catalog.findById('second')?.levelNumber, 2);
      expect(catalog.findByNumber(99), isNull);
      expect(() => catalog.requireByNumber(99), throwsStateError);
    });

    test('rejects duplicate ids and level numbers', () {
      expect(
        () => LevelCatalog([
          makeLevel(number: 1, id: 'duplicate'),
          makeLevel(number: 2, id: 'duplicate'),
        ]),
        throwsStateError,
      );
      expect(
        () => LevelCatalog([
          makeLevel(number: 1, id: 'first'),
          makeLevel(number: 1, id: 'second'),
        ]),
        throwsStateError,
      );
    });

    test('rejects out-of-bounds initial tiles', () {
      final level = makeLevel(
        initialTiles: const [
          InitialTileDefinition(
            position: GridPosition(8, 0),
            gemType: GemType.yellowSankofa,
          ),
        ],
      );

      expect(level.validate(), isNotEmpty);
      expect(() => LevelCatalog([level]), throwsStateError);
    });

    test('rejects unordered star thresholds', () {
      final level = makeLevel(
        thresholds: const StarThresholds(
          oneStar: 300,
          twoStar: 200,
          threeStar: 100,
        ),
      );

      expect(level.validate(), isNotEmpty);
      expect(() => LevelCatalog([level]), throwsStateError);
    });

    test('every shipped level validates and generates a playable board', () {
      expect(levelCatalog.length, allLevels.length);

      for (final level in levelCatalog.levels) {
        expect(level.validate(), isEmpty, reason: level.id);
        final board = BoardGenerator.generate(
          level.availableGems,
          layout: level.boardLayout,
          initialTiles: level.initialTiles,
          random: Random(level.levelNumber),
        );
        expect(MatchFinder().hasAnyMatch(board), isFalse, reason: level.id);
        expect(
          MoveValidator().hasAnyValidMove(board),
          isTrue,
          reason: level.id,
        );
      }
    });
  });

  group('upgraded level samples', () {
    test('level 1 is a standard tutorial level', () {
      final level = levelCatalog.requireByNumber(1);

      expect(level.boardWidth, 8);
      expect(level.boardHeight, 8);
      expect(level.tutorialHint, isNotNull);
    });

    test('level 2 generates an irregular board', () {
      final level = levelCatalog.requireByNumber(2);
      final board = BoardGenerator.generate(
        level.availableGems,
        layout: level.boardLayout,
        random: Random(2),
      );

      expect(board.isPlayable(const GridPosition(0, 0)), isFalse);
      expect(board.get(const GridPosition(0, 0)), isNull);
      expect(board.playableCellCount, 60);
    });

    test('level 3 preserves its fixed starting special tile', () {
      final level = levelCatalog.requireByNumber(3);
      final board = BoardGenerator.generate(
        level.availableGems,
        layout: level.boardLayout,
        initialTiles: level.initialTiles,
        random: Random(3),
      );
      final tile = board.get(const GridPosition(3, 3));

      expect(tile?.gemType, GemType.purpleAkofena);
      expect(tile?.specialType, SpecialGemType.colorClear);
    });
  });
}
