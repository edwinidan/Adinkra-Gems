import 'package:flutter/foundation.dart';
import '../../services/balancing_service.dart';
import '../models/combo_type.dart';
import '../models/gem_type.dart';
import '../models/level_config.dart';
import '../models/level_objective.dart';
import '../models/special_gem_type.dart';

enum LevelPlayState { ready, resolving, paused, won, lost }

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
  
  int _marksRemaining = 0;
  int _potsRemaining = 0;
  int _totalMarks = 0;
  int _totalPots = 0;
  
  final Map<GemType, int> _collectedGems = {};
  LevelPlayState _state = LevelPlayState.ready;
  LevelPlayState _stateBeforePause = LevelPlayState.ready;

  // Balancing metrics tracking
  final DateTime _startTime = DateTime.now();
  int _reshuffleCount = 0;
  int _maxCascadeChain = 0;

  LevelController({required this.config}) {
    _movesRemaining = config.moveLimit ?? 0;
    _timeRemainingSeconds = config.timeLimitSeconds ?? 0;
    for (final type in GemType.values) {
      _collectedGems[type] = 0;
    }
    
    _totalMarks = config.clearMarkCells.length;
    _marksRemaining = _totalMarks;
    
    _totalPots = config.clayPotCells.fold(0, (sum, pot) => sum + pot.layers);
    _potsRemaining = _totalPots;
  }

  int get currentScore => _currentScore;
  int get movesRemaining => _movesRemaining;
  int get timeRemainingSeconds => _timeRemainingSeconds;
  
  int get marksRemaining => _marksRemaining;
  int get totalMarks => _totalMarks;
  int get potsRemaining => _potsRemaining;
  int get totalPots => _totalPots;
  
  Map<GemType, int> get collectedGems => _collectedGems;
  LevelPlayState get state => _state;
  bool get isGameOver =>
      _state == LevelPlayState.won || _state == LevelPlayState.lost;
  bool get isGameWon => _state == LevelPlayState.won;
  bool get isResolving => _state == LevelPlayState.resolving;
  bool get isPaused => _state == LevelPlayState.paused;
  bool get canAcceptInput => _state == LevelPlayState.ready;
  bool get canAdvanceTimer =>
      hasTimer && _state == LevelPlayState.ready && _timeRemainingSeconds > 0;

  bool get hasMoveLimit => config.hasMoveLimit;
  bool get hasTimer => config.hasTimer;

  /// Starts a valid player move and defers win/loss evaluation until the board
  /// reports that all cascades and special effects have settled.
  bool beginMoveResolution() {
    if (!canAcceptInput) return false;

    if (hasMoveLimit) {
      _movesRemaining = (_movesRemaining - 1).clamp(0, 999);
    }
    _state = LevelPlayState.resolving;
    notifyListeners();
    return true;
  }

  /// Evaluates the level after the board reaches a stable state.
  void finishResolution() {
    if (_state != LevelPlayState.resolving) return;
    _evaluateStableBoard();
    notifyListeners();
  }

  /// Decrements timer seconds remaining by 1. Called on periodic game ticks.
  void decrementTime() {
    if (!canAdvanceTimer) return;

    _timeRemainingSeconds = (_timeRemainingSeconds - 1).clamp(0, 999);
    if (_timeRemainingSeconds == 0) {
      _evaluateStableBoard();
    }
    notifyListeners();
  }

  void pause() {
    if (isGameOver || isPaused) return;
    _stateBeforePause = _state;
    _state = LevelPlayState.paused;
    notifyListeners();
  }

  void resume() {
    if (!isPaused) return;
    _state = _stateBeforePause;
    notifyListeners();
  }

  /// Registers matched gems, updating player score and objective counts.
  void recordMatch(
    GemType gemType,
    int count, {
    SpecialGemType specialCreated = SpecialGemType.none,
    double multiplier = 1.0,
  }) {
    if (isGameOver) return;

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

    notifyListeners();
  }

  /// Registers a tile cleared by a special power-up effect.
  void recordSpecialClear(GemType gemType, {double multiplier = 1.0}) {
    if (isGameOver) return;

    _currentScore += (20 * multiplier).toInt();

    // Track for collection objectives
    _collectedGems[gemType] = (_collectedGems[gemType] ?? 0) + 1;

    notifyListeners();
  }

  /// Registers a clear mark successfully cleared.
  void recordMarkCleared() {
    if (isGameOver) return;
    _marksRemaining = (_marksRemaining - 1).clamp(0, 999);
    _currentScore += 100;
    notifyListeners();
  }
  
  /// Registers a pot layer destroyed.
  void recordPotDestroyed() {
    if (isGameOver) return;
    _potsRemaining = (_potsRemaining - 1).clamp(0, 999);
    _currentScore += 150;
    notifyListeners();
  }

  /// Registers a special combination activation.
  void recordCombo(ComboType comboType) {
    if (isGameOver) return;
    switch (comboType) {
      case ComboType.lineLine:
        _currentScore += 500;
        break;
      case ComboType.lineBurst:
        _currentScore += 1000;
        break;
      case ComboType.burstBurst:
        _currentScore += 1500;
        break;
      case ComboType.unityNormal:
        _currentScore += 500;
        break;
    }
    notifyListeners();
  }

  /// Records a reshuffle event.
  void recordReshuffle() {
    if (isGameOver) return;
    _reshuffleCount++;
  }

  /// Records the maximum cascade chain reached during a move.
  void recordCascadeChain(int length) {
    if (isGameOver) return;
    if (length > _maxCascadeChain) {
      _maxCascadeChain = length;
    }
  }

  /// Returns true if all objectives configured for this level are completed.
  bool get areObjectivesMet {
    for (final objective in config.objectives) {
      if (objective is ScoreObjective) {
        if (_currentScore < objective.targetScore) return false;
      } else if (objective is CollectObjective) {
        final collected = _collectedGems[objective.gemType] ?? 0;
        if (collected < objective.count) return false;
      } else if (objective is ClearMarkObjective) {
        if (_marksRemaining > 0) return false;
      } else if (objective is ClearBlockerObjective) {
        if (_potsRemaining > 0) return false;
      }
    }
    return true;
  }

  /// Evaluates win and loss conditions.
  void _evaluateStableBoard() {
    if (areObjectivesMet) {
      _state = LevelPlayState.won;
      _reportBalancingData(true);
      return;
    }

    if (hasMoveLimit && _movesRemaining <= 0) {
      _state = LevelPlayState.lost;
      _reportBalancingData(false);
      return;
    }

    if (hasTimer && _timeRemainingSeconds <= 0) {
      _state = LevelPlayState.lost;
      _reportBalancingData(false);
      return;
    }

    _state = LevelPlayState.ready;
  }

  double _calculateApproximateProgress() {
    if (config.objectives.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final objective in config.objectives) {
      if (objective is ScoreObjective) {
        totalProgress += (_currentScore / objective.targetScore).clamp(0.0, 1.0);
      } else if (objective is CollectObjective) {
        final collected = _collectedGems[objective.gemType] ?? 0;
        totalProgress += (collected / objective.count).clamp(0.0, 1.0);
      } else if (objective is ClearMarkObjective) {
        if (_totalMarks == 0) {
          totalProgress += 1.0;
        } else {
          final cleared = _totalMarks - _marksRemaining;
          totalProgress += (cleared / _totalMarks).clamp(0.0, 1.0);
        }
      } else if (objective is ClearBlockerObjective) {
        if (_totalPots == 0) {
          totalProgress += 1.0;
        } else {
          final cleared = _totalPots - _potsRemaining;
          totalProgress += (cleared / _totalPots).clamp(0.0, 1.0);
        }
      }
    }
    return totalProgress / config.objectives.length;
  }

  void _reportBalancingData(bool isWin) {
    final timeSpent = DateTime.now().difference(_startTime).inSeconds;
    BalancingService.recordAttempt(
      level: config.levelNumber,
      isWin: isWin,
      movesRemaining: _movesRemaining,
      score: _currentScore,
      completionTimeSeconds: timeSpent,
      reshuffleCount: _reshuffleCount,
      maxCascadeChain: _maxCascadeChain,
      approximateGoalProgress: isWin ? 1.0 : _calculateApproximateProgress(),
    );
  }
}
