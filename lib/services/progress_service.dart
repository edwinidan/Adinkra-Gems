import 'package:shared_preferences/shared_preferences.dart';

/// Service managing persistent storage of level progress, high scores,
/// and stars achieved using [SharedPreferences].
class ProgressService {
  ProgressService._();

  static const String _unlockedKey = 'highestUnlockedLevel';
  static const String _bestScorePrefix = 'bestScore_level_';
  static const String _bestStarsPrefix = 'bestStars_level_';

  /// Returns the highest unlocked level index (1-based, default: 1).
  static Future<int> getHighestUnlockedLevel({int? maxLevel}) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getInt(_unlockedKey) ?? 1;
    return maxLevel == null ? unlocked : unlocked.clamp(1, maxLevel);
  }

  /// Marks a level as unlocked (only updates if [level] is higher than current progress).
  static Future<void> unlockLevel(int level, {int? maxLevel}) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUnlocked = prefs.getInt(_unlockedKey) ?? 1;
    final boundedLevel = maxLevel == null ? level : level.clamp(1, maxLevel);
    if (boundedLevel > currentUnlocked) {
      await prefs.setInt(_unlockedKey, boundedLevel);
    }
  }

  /// Returns the high score recorded for a level.
  static Future<int> getBestScore(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_bestScorePrefix$level') ?? 0;
  }

  /// Saves the score for a level if it is higher than the current best.
  ///
  /// Returns true if a new high score was set.
  static Future<bool> saveScore(int level, int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBest = prefs.getInt('$_bestScorePrefix$level') ?? 0;
    if (score > currentBest) {
      await prefs.setInt('$_bestScorePrefix$level', score);
      return true;
    }
    return false;
  }

  /// Returns the highest number of stars (0 to 3) achieved on a level.
  static Future<int> getBestStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_bestStarsPrefix$level') ?? 0;
  }

  /// Saves the star rating for a level if it is higher than the current best.
  static Future<void> saveStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBest = prefs.getInt('$_bestStarsPrefix$level') ?? 0;
    if (stars > currentBest) {
      await prefs.setInt('$_bestStarsPrefix$level', stars);
    }
  }

  /// Clears all stored level progress and scores (reverts to Level 1 unlocked).
  static Future<void> clearAllProgress({int levelCount = 15}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockedKey);
    for (int i = 1; i <= levelCount; i++) {
      await prefs.remove('$_bestScorePrefix$i');
      await prefs.remove('$_bestStarsPrefix$i');
    }
  }
}
