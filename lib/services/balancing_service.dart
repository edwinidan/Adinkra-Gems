import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for collecting lightweight, local-only metrics about level difficulty.
class BalancingService {
  BalancingService._();

  static const String _metricsKey = 'balancing_metrics_v1';

  /// Records the result of a single level attempt.
  static Future<void> recordAttempt({
    required int level,
    required bool isWin,
    required int movesRemaining,
    required int score,
    required int completionTimeSeconds,
    required int reshuffleCount,
    required int maxCascadeChain,
    required double approximateGoalProgress, // 0.0 to 1.0 (1.0 on win)
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load existing metrics
    final existingData = prefs.getString(_metricsKey);
    Map<String, dynamic> metrics = {};
    if (existingData != null) {
      try {
        metrics = jsonDecode(existingData);
      } catch (e) {
        // Corrupted data, start fresh
      }
    }

    final levelKey = 'level_$level';
    if (!metrics.containsKey(levelKey)) {
      metrics[levelKey] = {
        'attempts': 0,
        'wins': 0,
        'totalMovesRemainingOnWin': 0,
        'totalTimeOnWin': 0,
        'totalReshuffles': 0,
        'highestCascade': 0,
        'averageLossProgress': 0.0,
      };
    }

    final levelMetrics = metrics[levelKey];
    levelMetrics['attempts'] += 1;
    levelMetrics['totalReshuffles'] += reshuffleCount;
    
    if (maxCascadeChain > (levelMetrics['highestCascade'] as int)) {
      levelMetrics['highestCascade'] = maxCascadeChain;
    }

    if (isWin) {
      levelMetrics['wins'] += 1;
      levelMetrics['totalMovesRemainingOnWin'] += movesRemaining;
      levelMetrics['totalTimeOnWin'] += completionTimeSeconds;
    } else {
      // Running average for loss progress
      final losses = levelMetrics['attempts'] - levelMetrics['wins'];
      final currentAvg = levelMetrics['averageLossProgress'] as double;
      levelMetrics['averageLossProgress'] = currentAvg + ((approximateGoalProgress - currentAvg) / losses);
    }

    await prefs.setString(_metricsKey, jsonEncode(metrics));
  }

  /// Prints current balancing metrics to the console for developer analysis.
  static Future<void> exportBalancingData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_metricsKey);
    if (data == null) {
      print('--- No Balancing Data Found ---');
      return;
    }
    
    try {
      final metrics = jsonDecode(data) as Map<String, dynamic>;
      print('--- Balancing Metrics Export ---');
      
      final sortedKeys = metrics.keys.toList()
        ..sort((a, b) {
          final aNum = int.parse(a.split('_')[1]);
          final bNum = int.parse(b.split('_')[1]);
          return aNum.compareTo(bNum);
        });

      for (final key in sortedKeys) {
        final lm = metrics[key];
        final attempts = lm['attempts'] as int;
        final wins = lm['wins'] as int;
        final winRate = attempts > 0 ? (wins / attempts * 100).toStringAsFixed(1) : '0.0';
        
        final avgMovesWin = wins > 0 ? (lm['totalMovesRemainingOnWin'] / wins).toStringAsFixed(1) : '0.0';
        final avgTimeWin = wins > 0 ? (lm['totalTimeOnWin'] / wins).toStringAsFixed(1) : '0.0';
        final avgReshuffles = attempts > 0 ? (lm['totalReshuffles'] / attempts).toStringAsFixed(2) : '0.0';
        final avgLossProgress = ((lm['averageLossProgress'] as double) * 100).toStringAsFixed(1);
        final highestCascade = lm['highestCascade'];

        print('$key:');
        print('  Attempts: $attempts | Wins: $wins ($winRate%)');
        if (wins > 0) print('  Avg Moves Remaining (Win): $avgMovesWin');
        if (wins > 0) print('  Avg Time (Win): ${avgTimeWin}s');
        if (attempts > wins) print('  Avg Goal Progress (Loss): $avgLossProgress%');
        print('  Avg Reshuffles: $avgReshuffles');
        print('  Highest Cascade: $highestCascade');
        print('--------------------------------');
      }
    } catch (e) {
      print('Error parsing balancing data: $e');
    }
  }

  /// Clears all balancing data.
  static Future<void> clearBalancingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_metricsKey);
  }
}
