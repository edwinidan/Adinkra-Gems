import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/level_config.dart';
import 'package:adinkra_gems/game/models/level_objective.dart';
import 'package:adinkra_gems/game/models/star_thresholds.dart';
import 'package:adinkra_gems/game/systems/level_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LevelController', () {
    const starThresholds = StarThresholds(oneStar: 100, twoStar: 200, threeStar: 300);

    test('initializes with correct limits and state', () {
      const config = LevelConfig(
        levelNumber: 1,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        moveLimit: 20,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      expect(controller.currentScore, 0);
      expect(controller.movesRemaining, 20);
      expect(controller.hasMoveLimit, isTrue);
      expect(controller.hasTimer, isFalse);
      expect(controller.isGameOver, isFalse);
      expect(controller.isGameWon, isFalse);
    });

    test('matches accumulate score and satisfy ScoreObjective', () {
      const config = LevelConfig(
        levelNumber: 1,
        name: 'Test Level',
        objectives: [ScoreObjective(60)],
        moveLimit: 20,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      // Score 60 for match-3
      controller.recordMatch(GemType.redFuntumfunefuDenkyemfunefu, 3);

      expect(controller.currentScore, 60);
      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isTrue);
    });

    test('matches satisfy CollectObjective', () {
      const config = LevelConfig(
        levelNumber: 2,
        name: 'Test Level',
        objectives: [CollectObjective(gemType: GemType.yellowSankofa, count: 5)],
        moveLimit: 10,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.recordMatch(GemType.yellowSankofa, 3);
      expect(controller.isGameOver, isFalse);
      expect(controller.collectedGems[GemType.yellowSankofa], 3);

      controller.recordMatch(GemType.yellowSankofa, 3);
      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isTrue);
      expect(controller.collectedGems[GemType.yellowSankofa], 6);
    });

    test('loss triggers when out of moves', () {
      const config = LevelConfig(
        levelNumber: 3,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        moveLimit: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.useMove();

      expect(controller.movesRemaining, 0);
      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isFalse);
    });

    test('loss triggers when out of time', () {
      const config = LevelConfig(
        levelNumber: 4,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        timeLimitSeconds: 2,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.decrementTime();
      expect(controller.isGameOver, isFalse);

      controller.decrementTime();
      expect(controller.timeRemainingSeconds, 0);
      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isFalse);
    });
  });
}
