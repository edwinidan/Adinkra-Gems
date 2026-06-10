import 'package:adinkra_gems/services/progress_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProgressService', () {
    setUp(() {
      // Initialize mock shared preferences with empty/initial values
      SharedPreferences.setMockInitialValues({});
    });

    test('defaults to level 1 unlocked, scores 0, stars 0', () async {
      final unlocked = await ProgressService.getHighestUnlockedLevel();
      final score = await ProgressService.getBestScore(1);
      final stars = await ProgressService.getBestStars(1);

      expect(unlocked, 1);
      expect(score, 0);
      expect(stars, 0);
    });

    test('unlockLevel only increases level progress', () async {
      await ProgressService.unlockLevel(3);
      expect(await ProgressService.getHighestUnlockedLevel(), 3);

      // Should ignore lower level unlock
      await ProgressService.unlockLevel(2);
      expect(await ProgressService.getHighestUnlockedLevel(), 3);
    });

    test('saveScore updates only if it exceeds current best', () async {
      final isNew1 = await ProgressService.saveScore(1, 1500);
      expect(isNew1, isTrue);
      expect(await ProgressService.getBestScore(1), 1500);

      // Lower score should be ignored
      final isNew2 = await ProgressService.saveScore(1, 1200);
      expect(isNew2, isFalse);
      expect(await ProgressService.getBestScore(1), 1500);

      // Higher score should overwrite
      final isNew3 = await ProgressService.saveScore(1, 2000);
      expect(isNew3, isTrue);
      expect(await ProgressService.getBestScore(1), 2000);
    });

    test('saveStars updates only if it exceeds current best', () async {
      await ProgressService.saveStars(1, 2);
      expect(await ProgressService.getBestStars(1), 2);

      await ProgressService.saveStars(1, 1); // ignored
      expect(await ProgressService.getBestStars(1), 2);

      await ProgressService.saveStars(1, 3); // updated
      expect(await ProgressService.getBestStars(1), 3);
    });

    test('clearAllProgress resets entire state', () async {
      await ProgressService.unlockLevel(5);
      await ProgressService.saveScore(1, 1000);
      await ProgressService.saveStars(1, 2);

      await ProgressService.clearAllProgress();

      expect(await ProgressService.getHighestUnlockedLevel(), 1);
      expect(await ProgressService.getBestScore(1), 0);
      expect(await ProgressService.getBestStars(1), 0);
    });
  });
}
