import 'package:flutter/foundation.dart';
import '../models/gem_type.dart';
import '../models/level_config.dart';
import '../models/level_objective.dart';
import '../models/special_gem_type.dart';

/// Manages level-specific gameplay rules, scoring, objectives tracking,
/// move limits, and countdown timers.
///
/// Extends [ChangeNotifier] to serve as a bridge between the Flame game loop
/// and the Flutter HUD widget tree.
class LevelController extends ChangeNotifier {
  /// Configuration for the current level.
  final LevelConfig config;

  int _currentScore = 0;
  int _movesRemaining = 0;
  int _timeRemainingSeconds = 0;
  final Map<GemType, int> _collectedGems = {};
  bool _isGameOver = false;
  bool _isGameWon = false;

  LevelController({required this.config}) {
    _movesRemaining = config.moveLimit ?? 0;
    _timeRemainingSeconds = config.timeLimitSeconds ?? 0;
    for (final type in GemType.values) {
      _collectedGems[type] = 0;
    }
  }

  int get currentScore => _currentScore;
  int get movesRemaining => _movesRemaining;
  int get timeRemainingSeconds => _timeRemainingSeconds;
  Map<GemType, int> get collectedGems => _collectedGems;
  bool get isGameOver => _isGameOver;
  bool get isGameWon => _isGameWon;

  bool get hasMoveLimit => config.hasMoveLimit;
  bool get hasTimer => config.hasTimer;

  /// Decrements moves remaining by 1. Checked on valid player swaps.
  void useMove() {
    if (_isGameOver) return;
    if (hasMoveLimit) {
      _movesRemaining = (_movesRemaining - 1).clamp(0, 999);
      _checkGameStatus();
    }
    notifyListeners();
  }

  /// Decrements timer seconds remaining by 1. Called on periodic game ticks.
  void decrementTime() {
    if (_isGameOver) return;
    if (hasTimer) {
      _timeRemainingSeconds = (_timeRemainingSeconds - 1).clamp(0, 999);
      _checkGameStatus();
    }
    notifyListeners();
  }

  /// Registers matched gems, updating player score and objective counts.
  void recordMatch(GemType gemType, int count, {SpecialGemType specialCreated = SpecialGemType.none, double multiplier = 1.0}) {
    if (_isGameOver) return;

    int points = 0;
    if (specialCreated == SpecialGemType.bomb) {
      points = 300;
    } else if (count >= 5) {
      points = 250;
    } else if (count == 4) {
      points = 120;
    } else {
      points = 60;
    }

    _currentScore += (points * multiplier).toInt();

    // Track matching counts for collection objectives
    _collectedGems[gemType] = (_collectedGems[gemType] ?? 0) + count;

    _checkGameStatus();
    notifyListeners();
  }

  /// Registers a tile cleared by a special power-up effect.
  void recordSpecialClear(GemType gemType, {double multiplier = 1.0}) {
    if (_isGameOver) return;

    _currentScore += (20 * multiplier).toInt();

    // Track for collection objectives
    _collectedGems[gemType] = (_collectedGems[gemType] ?? 0) + 1;

    _checkGameStatus();
    notifyListeners();
  }

  /// Returns true if all objectives configured for this level are completed.
  bool get areObjectivesMet {
    for (final objective in config.objectives) {
      if (objective is ScoreObjective) {
        if (_currentScore < objective.targetScore) return false;
      } else if (objective is CollectObjective) {
        final collected = _collectedGems[objective.gemType] ?? 0;
        if (collected < objective.count) return false;
      }
    }
    return true;
  }

  /// Evaluates win and loss conditions.
  void _checkGameStatus() {
    // 1. Win Check (all objectives met)
    if (areObjectivesMet) {
      _isGameOver = true;
      _isGameWon = true;
      return;
    }

    // 2. Lose Check (out of moves/time without meeting objectives)
    if (hasMoveLimit && _movesRemaining <= 0) {
      _isGameOver = true;
      _isGameWon = false;
      return;
    }

    if (hasTimer && _timeRemainingSeconds <= 0) {
      _isGameOver = true;
      _isGameWon = false;
      return;
    }
  }
}
