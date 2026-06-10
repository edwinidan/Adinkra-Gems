import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// A premium modal dialog showing the level end state (Win or Lose).
///
/// Features dynamic star rendering, score display, and buttons for map selection,
/// retrying the level, or proceeding to the next level.
class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.isWon,
    required this.score,
    required this.stars,
    required this.levelNumber,
    required this.onRetry,
    required this.onMap,
    this.onNextLevel,
  });

  final bool isWon;
  final int score;
  final int stars; // 1 to 3
  final int levelNumber;
  final VoidCallback onRetry;
  final VoidCallback onMap;
  final VoidCallback? onNextLevel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1E0738),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AdinkraTheme.primaryGold.withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AdinkraTheme.deepPurple.withOpacity(0.6),
              blurRadius: 36,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Title Header ──
            Icon(
              isWon ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied_rounded,
              color: isWon ? AdinkraTheme.primaryGold : Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              isWon ? 'LEVEL CLEARED!' : 'LEVEL FAILED',
              style: TextStyle(
                color: isWon ? AdinkraTheme.primaryGold : Colors.redAccent,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isWon ? 'Victory is Yours!' : 'Try again, you can do it!',
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // ── Stars Visual Panel (Only for Win state) ──
            if (isWon) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final filled = index < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.star_rounded,
                      color: filled ? AdinkraTheme.primaryGold : Colors.white12,
                      size: index == 1 ? 52 : 40, // Middle star is larger
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],

            // ── Score Display ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'FINAL SCORE',
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Action Buttons ──
            // Next Level (Primary - if won and not final level)
            if (isWon && onNextLevel != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('btn_win_next'),
                  onPressed: onNextLevel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdinkraTheme.primaryGold,
                    foregroundColor: AdinkraTheme.richBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'NEXT LEVEL',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Retry Level (Primary - if failed)
            if (!isWon) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const ValueKey('btn_lose_retry'),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdinkraTheme.primaryGold,
                    foregroundColor: AdinkraTheme.richBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'RETRY',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Secondary Buttons (Retry for win state, Map for both)
            Row(
              children: [
                // Map Select Node return
                Expanded(
                  child: OutlinedButton(
                    key: const ValueKey('btn_gameover_map'),
                    onPressed: onMap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'MAP SELECT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                // Retry button for Win state
                if (isWon) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      key: const ValueKey('btn_win_retry'),
                      onPressed: onRetry,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'REPLAY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
