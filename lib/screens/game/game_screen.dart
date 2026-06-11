import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../../app/theme.dart';
import '../../app/woven_background.dart';
import '../../game/adinkra_gems_game.dart';
import '../../game/data/levels.dart';
import '../../game/systems/level_controller.dart';
import '../../services/audio_service.dart';
import '../../services/progress_service.dart';
import 'game_hud.dart';
import 'game_over_dialog.dart';

/// Game screen — hosts the Flame GameWidget and UI overlays.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AdinkraGemsGame? _game;
  LevelController? _levelController;
  int? _levelNumber;
  bool _savingProgress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_levelNumber == null) {
      // Retrieve level from route arguments
      final level = ModalRoute.of(context)?.settings.arguments as int? ?? 1;
      _levelNumber = level;
      _initLevel(level);
    }
  }

  void _initLevel(int level) {
    final config = allLevels[level - 1];
    _savingProgress = false;

    // Clean up old controller if exists
    _levelController?.removeListener(_onLevelStateChanged);

    _levelController = LevelController(config: config);
    _levelController!.addListener(_onLevelStateChanged);

    _game = AdinkraGemsGame(
      levelConfig: config,
      levelController: _levelController!,
    );
  }

  @override
  void dispose() {
    _levelController?.removeListener(_onLevelStateChanged);
    super.dispose();
  }

  void _onLevelStateChanged() {
    if (_levelController != null &&
        _levelController!.isGameOver &&
        !_savingProgress) {
      _showGameOverMenu();
    }
  }

  void _showGameOverMenu() async {
    _savingProgress = true;

    final controller = _levelController!;
    final level = _levelNumber!;
    final score = controller.currentScore;

    int stars = 0;
    if (controller.isGameWon) {
      AudioService.playWin();
      stars = controller.config.starThresholds.starsFor(score);
      if (stars < 1) stars = 1; // Minimum of 1 star if won

      // Persist player progress to SharedPreferences
      await ProgressService.unlockLevel(level + 1);
      await ProgressService.saveScore(level, score);
      await ProgressService.saveStars(level, stars);
    } else {
      AudioService.playLose();
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      builder: (_) => GameOverDialog(
        isWon: controller.isGameWon,
        score: score,
        stars: stars,
        levelNumber: level,
        onRetry: () {
          Navigator.pop(context); // Close dialog
          _restartLevel();
        },
        onMap: () {
          Navigator.pop(context); // Close dialog
          Navigator.pop(context); // Return to Map Select Screen
        },
        onNextLevel: (level < allLevels.length)
            ? () {
                Navigator.pop(context); // Close dialog
                _loadNextLevel();
              }
            : null,
      ),
    );
  }

  void _restartLevel() {
    setState(() {
      _initLevel(_levelNumber!);
    });
  }

  void _loadNextLevel() {
    setState(() {
      _levelNumber = _levelNumber! + 1;
      _initLevel(_levelNumber!);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null || _levelController == null) {
      return const Scaffold(
        backgroundColor: AdinkraTheme.cream,
        body: Center(
          child: CircularProgressIndicator(color: AdinkraTheme.primaryGold),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AdinkraTheme.cream,
      body: WovenBackground(
        overlayOpacity: 0.16,
        child: SafeArea(
          child: Column(
            children: [
              // ── HUD (rebuilds dynamically when LevelController alerts listeners) ──
              ListenableBuilder(
                listenable: _levelController!,
                builder: (context, child) {
                  return GameHud(
                    levelController: _levelController!,
                    onPause: () => _showPauseMenu(context),
                  );
                },
              ),

              // ── Board area ──
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        AdinkraTheme.cocoa.withOpacity(0.9),
                        AdinkraTheme.darkCocoa,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AdinkraTheme.cocoa.withOpacity(0.45),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AdinkraTheme.cocoa.withOpacity(0.28),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GameWidget(game: _game!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPauseMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _PauseDialog(
        onResume: () => Navigator.pop(context),
        onQuit: () {
          Navigator.pop(context); // close dialog
          Navigator.pop(context); // go back to level select
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pause menu dialog
// ─────────────────────────────────────────────
class _PauseDialog extends StatelessWidget {
  const _PauseDialog({required this.onResume, required this.onQuit});

  final VoidCallback onResume;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AdinkraTheme.lightCream,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AdinkraTheme.cocoa.withOpacity(0.35),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.pause_circle_rounded,
              color: AdinkraTheme.terracotta,
              size: 44,
            ),
            const SizedBox(height: 12),
            const Text(
              'PAUSED',
              style: TextStyle(
                color: AdinkraTheme.darkCocoa,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 28),

            // Resume
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const ValueKey('btn_pause_resume'),
                onPressed: onResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdinkraTheme.terracotta,
                  foregroundColor: AdinkraTheme.lightCream,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quit
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                key: const ValueKey('btn_pause_quit'),
                onPressed: onQuit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdinkraTheme.cocoa,
                  side: const BorderSide(color: AdinkraTheme.cocoa),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'QUIT TO MENU',
                  style: TextStyle(letterSpacing: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
