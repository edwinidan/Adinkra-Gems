import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/level_config.dart';
import 'package:adinkra_gems/game/models/level_objective.dart';
import 'package:adinkra_gems/game/models/star_thresholds.dart';
import 'package:adinkra_gems/game/systems/level_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('LevelController', () {
    const starThresholds = StarThresholds(
      oneStar: 100,
      twoStar: 200,
      threeStar: 300,
    );

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
      expect(controller.state, LevelPlayState.ready);
    });

    test('final move can satisfy a score objective before settlement', () {
      const config = LevelConfig(
        levelNumber: 1,
        name: 'Test Level',
        objectives: [ScoreObjective(60)],
        moveLimit: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      expect(controller.beginMoveResolution(), isTrue);
      expect(controller.movesRemaining, 0);
      expect(controller.isGameOver, isFalse);

      controller.recordMatch(GemType.redFuntumfunefuDenkyemfunefu, 3);
      expect(controller.isGameOver, isFalse);

      controller.finishResolution();
      expect(controller.currentScore, 60);
      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isTrue);
      expect(controller.state, LevelPlayState.won);
    });

    test('cascades can satisfy collect objective on the final move', () {
      const config = LevelConfig(
        levelNumber: 2,
        name: 'Test Level',
        objectives: [
          CollectObjective(gemType: GemType.yellowSankofa, count: 5),
        ],
        moveLimit: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.beginMoveResolution();
      controller.recordMatch(GemType.yellowSankofa, 3);
      expect(controller.isGameOver, isFalse);
      expect(controller.collectedGems[GemType.yellowSankofa], 3);

      controller.recordMatch(GemType.yellowSankofa, 3);
      expect(controller.isGameOver, isFalse);
      controller.finishResolution();

      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isTrue);
      expect(controller.collectedGems[GemType.yellowSankofa], 6);
    });

    test('loss waits until final move resolution finishes', () {
      const config = LevelConfig(
        levelNumber: 3,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        moveLimit: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.beginMoveResolution();

      expect(controller.movesRemaining, 0);
      expect(controller.isGameOver, isFalse);
      expect(controller.state, LevelPlayState.resolving);

      controller.finishResolution();
      expect(controller.isGameOver, isTrue);
      expect(controller.isGameWon, isFalse);
      expect(controller.state, LevelPlayState.lost);
    });

    test('special clear can complete collect objective on final move', () {
      const config = LevelConfig(
        levelNumber: 4,
        name: 'Test Level',
        objectives: [
          CollectObjective(gemType: GemType.blueDwennimmen, count: 1),
        ],
        moveLimit: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.beginMoveResolution();
      controller.recordSpecialClear(GemType.blueDwennimmen);
      controller.finishResolution();

      expect(controller.isGameWon, isTrue);
      expect(controller.collectedGems[GemType.blueDwennimmen], 1);
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

    test('timer does not advance while a move is resolving', () {
      const config = LevelConfig(
        levelNumber: 5,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        moveLimit: 10,
        timeLimitSeconds: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.beginMoveResolution();
      controller.decrementTime();

      expect(controller.timeRemainingSeconds, 1);
      expect(controller.isGameOver, isFalse);

      controller.finishResolution();
      expect(controller.state, LevelPlayState.ready);

      controller.decrementTime();
      expect(controller.state, LevelPlayState.lost);
    });

    test('pause preserves ready and resolving states', () {
      const config = LevelConfig(
        levelNumber: 6,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        moveLimit: 10,
        timeLimitSeconds: 10,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      controller.pause();
      expect(controller.state, LevelPlayState.paused);
      controller.decrementTime();
      expect(controller.timeRemainingSeconds, 10);
      controller.resume();
      expect(controller.state, LevelPlayState.ready);

      controller.beginMoveResolution();
      controller.pause();
      controller.resume();
      expect(controller.state, LevelPlayState.resolving);
    });

    test('terminal result is emitted only once', () {
      const config = LevelConfig(
        levelNumber: 7,
        name: 'Test Level',
        objectives: [ScoreObjective(60)],
        moveLimit: 1,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);
      var terminalNotifications = 0;
      controller.addListener(() {
        if (controller.isGameOver) {
          terminalNotifications++;
        }
      });

      controller.beginMoveResolution();
      controller.recordMatch(GemType.greenGyeNyame, 3);
      controller.finishResolution();
      controller.finishResolution();

      expect(controller.state, LevelPlayState.won);
      expect(terminalNotifications, 1);
    });

    test('cannot start a second move while resolving', () {
      const config = LevelConfig(
        levelNumber: 8,
        name: 'Test Level',
        objectives: [ScoreObjective(1000)],
        moveLimit: 2,
        availableGems: GemType.values,
        starThresholds: starThresholds,
      );

      final controller = LevelController(config: config);

      expect(controller.beginMoveResolution(), isTrue);
      expect(controller.beginMoveResolution(), isFalse);
      expect(controller.movesRemaining, 1);
    });
  });
}
