import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../game/data/gem_assets.dart';
import '../../game/models/level_objective.dart';
import '../../game/systems/level_controller.dart';

/// Game HUD — displays real-time score, remaining moves/time, and objectives progression.
class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.levelController,
    required this.onPause,
  });

  final LevelController levelController;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final config = levelController.config;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AdinkraTheme.lightCream.withOpacity(0.92),
        border: Border(
          bottom: BorderSide(
            color: AdinkraTheme.cocoa.withOpacity(0.25),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Upper Bar: Title & Stats ──
          Row(
            children: [
              // Pause Menu trigger
              IconButton(
                key: const ValueKey('btn_hud_back'),
                onPressed: onPause,
                icon: const Icon(
                  Icons.pause_circle_outline_rounded,
                  color: AdinkraTheme.terracotta,
                  size: 30,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              const SizedBox(width: 12),

              // Level Label & Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LEVEL ${config.levelNumber}',
                    style: const TextStyle(
                      color: AdinkraTheme.darkCocoa,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    config.name,
                    style: const TextStyle(
                      color: AdinkraTheme.cocoa,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Score indicator
              _HudStat(
                label: 'SCORE',
                value: '${levelController.currentScore}',
                valueColor: AdinkraTheme.darkCocoa,
              ),

              const SizedBox(width: 16),

              // Moves remaining (if applicable)
              if (levelController.hasMoveLimit) ...[
                _HudStat(
                  label: 'MOVES',
                  value: '${levelController.movesRemaining}',
                  valueColor: levelController.movesRemaining <= 5
                      ? Colors.redAccent
                      : AdinkraTheme.terracotta,
                ),
                const SizedBox(width: 16),
              ],

              // Time remaining (if applicable)
              if (levelController.hasTimer)
                _HudStat(
                  label: 'TIME',
                  value: '${levelController.timeRemainingSeconds}s',
                  valueColor: levelController.timeRemainingSeconds <= 15
                      ? Colors.redAccent
                      : AdinkraTheme.sage,
                ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Lower Bar: Level Objectives List ──
          Row(
            children: [
              const Text(
                'GOALS: ',
                style: TextStyle(
                  color: AdinkraTheme.cocoa,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Expanded(child: _ObjectivesBar(levelController: levelController)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HudStat extends StatelessWidget {
  const _HudStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AdinkraTheme.cocoa,
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ObjectivesBar extends StatelessWidget {
  final LevelController levelController;

  const _ObjectivesBar({required this.levelController});

  @override
  Widget build(BuildContext context) {
    final config = levelController.config;
    final chips = <Widget>[];

    for (final objective in config.objectives) {
      if (objective is ScoreObjective) {
        chips.add(
          _ObjectiveChip(
            icon: const Icon(
              Icons.star_rounded,
              color: AdinkraTheme.primaryGold,
              size: 16,
            ),
            label: '${levelController.currentScore} / ${objective.targetScore}',
          ),
        );
      } else if (objective is CollectObjective) {
        final collected = levelController.collectedGems[objective.gemType] ?? 0;
        chips.add(
          _ObjectiveChip(
            icon: Image.asset(
              GemAssets.pathFor(objective.gemType),
              width: 18,
              height: 18,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.red, size: 18),
            ),
            label: '$collected / ${objective.count}',
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map(
              (w) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: w,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ObjectiveChip extends StatelessWidget {
  final Widget icon;
  final String label;

  const _ObjectiveChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AdinkraTheme.cream.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AdinkraTheme.cocoa.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AdinkraTheme.darkCocoa,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
