import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../app/woven_background.dart';
import '../../game/data/levels.dart';
import '../../services/progress_service.dart';
import 'level_node_widget.dart';

/// Level select screen — scrollable map displaying all level nodes.
///
/// Unlocks level N+1 when level N is won, and renders high scores and star ratings
/// persistently fetched from SharedPreferences.
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  int _highestUnlockedLevel = 1;
  final Map<int, int> _bestScores = {};
  final Map<int, int> _bestStars = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
    });

    final highestUnlocked = await ProgressService.getHighestUnlockedLevel(
      maxLevel: levelCatalog.length,
    );
    final scores = <int, int>{};
    final stars = <int, int>{};

    for (int i = 1; i <= levelCatalog.length; i++) {
      scores[i] = await ProgressService.getBestScore(i);
      stars[i] = await ProgressService.getBestStars(i);
    }

    if (mounted) {
      setState(() {
        _highestUnlockedLevel = highestUnlocked;
        _bestScores.addAll(scores);
        _bestStars.addAll(stars);
        _isLoading = false;
      });
    }
  }

  void _onLevelTap(int level) async {
    // Navigate to game screen and wait for return
    await Navigator.pushNamed(context, AppRoutes.game, arguments: level);

    // Refresh progress state when returning to this screen
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdinkraTheme.cream,
      body: WovenBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      key: const ValueKey('btn_level_select_back'),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AdinkraTheme.darkCocoa,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'SELECT LEVEL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AdinkraTheme.darkCocoa,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer to balance back button
                  ],
                ),
              ),

              // ── Subtitle ──
              const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 20),
                child: Text(
                  'Journey through the Adinkra realm',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AdinkraTheme.cocoa, fontSize: 12),
                ),
              ),

              // ── Level grid ──
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AdinkraTheme.primaryGold,
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.88,
                            ),
                        itemCount: levelCatalog.length,
                        itemBuilder: (context, index) {
                          final level = index + 1;
                          final isUnlocked = level <= _highestUnlockedLevel;
                          final bestScore = _bestScores[level] ?? 0;
                          final stars = _bestStars[level] ?? 0;

                          return LevelNodeWidget(
                            level: level,
                            isUnlocked: isUnlocked,
                            stars: stars,
                            bestScore: bestScore,
                            onTap: () => _onLevelTap(level),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
