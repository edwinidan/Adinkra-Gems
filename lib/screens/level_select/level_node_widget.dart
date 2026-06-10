import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// A single level node displayed on the level select screen.
///
/// Shows a gold gem tile for unlocked levels, with stars and best score details.
/// Shows a dim locked tile for locked levels.
class LevelNodeWidget extends StatefulWidget {
  const LevelNodeWidget({
    super.key,
    required this.level,
    required this.isUnlocked,
    required this.stars,
    required this.bestScore,
    required this.onTap,
  });

  final int level;
  final bool isUnlocked;
  final int stars; // 0 to 3
  final int bestScore;
  final VoidCallback onTap;

  @override
  State<LevelNodeWidget> createState() => _LevelNodeWidgetState();
}

class _LevelNodeWidgetState extends State<LevelNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnim = _scaleCtrl.drive(CurveTween(curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.isUnlocked) _scaleCtrl.reverse();
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.isUnlocked) {
      _scaleCtrl.forward();
      widget.onTap();
    }
  }

  void _onTapCancel() {
    if (widget.isUnlocked) _scaleCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey('level_node_${widget.level}'),
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: _buildTile(),
      ),
    );
  }

  Widget _buildTile() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: widget.isUnlocked
            ? const LinearGradient(
                colors: [
                  Color(0xFFFFE066),
                  AdinkraTheme.primaryGold,
                  Color(0xFFCC8800),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.06),
                  Colors.white.withOpacity(0.02),
                ],
              ),
        border: Border.all(
          color: widget.isUnlocked
              ? const Color(0xFFFFE066)
              : Colors.white10,
          width: widget.isUnlocked ? 2 : 1,
        ),
        boxShadow: widget.isUnlocked
            ? [
                BoxShadow(
                  color: AdinkraTheme.primaryGold.withOpacity(0.45),
                  blurRadius: 16,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            widget.isUnlocked ? Icons.diamond_rounded : Icons.lock_rounded,
            color: widget.isUnlocked
                ? AdinkraTheme.richBlack
                : Colors.white24,
            size: 26,
          ),
          const SizedBox(height: 4),

          // Level number
          Text(
            '${widget.level}',
            style: TextStyle(
              color: widget.isUnlocked
                  ? AdinkraTheme.richBlack
                  : Colors.white24,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),

          // Stars earned
          if (widget.isUnlocked) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) {
                  final filled = i < widget.stars;
                  return Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 11,
                    color: AdinkraTheme.richBlack,
                  );
                },
              ),
            ),
          ],

          // Best score label
          if (widget.isUnlocked && widget.bestScore > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${widget.bestScore}',
              style: const TextStyle(
                color: AdinkraTheme.richBlack,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
