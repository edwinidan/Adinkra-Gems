import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import '../../game/models/tile_model.dart';
import '../../game/models/special_gem_type.dart';
import '../board/grid_position.dart';

/// The visual representation of a gem tile on the Flame game board.
///
/// Handles rendering the gem sprite, and will handle animations
/// (swaps, falls, matches) in later phases.
class TileComponent extends SpriteComponent {
  /// The logical model containing the state of this tile.
  final TileModel tileModel;

  /// The current coordinates on the 8x8 grid.
  GridPosition gridPosition;

  /// Whether this tile is currently selected by the player.
  bool isSelected = false;

  double _pulseTime = 0.0;

  TileComponent({
    required this.tileModel,
    required this.gridPosition,
    required Sprite sprite,
    required double size,
  }) : super(
          sprite: sprite,
          size: Vector2.all(size),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Start with a small scale-in effect to make board population feel juicy
    scale = Vector2.zero();
    add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(
          duration: 0.35,
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }

  /// Check if the tile is currently playing its entrance zoom animation.
  bool get isAnimatingEntrance => children.any((c) => c is ScaleEffect);

  @override
  void update(double dt) {
    super.update(dt);

    if (isSelected) {
      _pulseTime += dt * 5.0;
      // Gentle pulsing: scales between 0.94 and 1.06
      final pulseScale = 1.0 + 0.06 * math.sin(_pulseTime);
      scale = Vector2.all(pulseScale);
    } else {
      _pulseTime = 0.0;
      // Revert to normal scale if not animating entrance
      if (scale.x != 1.0 && !isAnimatingEntrance) {
        scale = Vector2.all(1.0);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (tileModel.specialType != SpecialGemType.none) {
      _drawSpecialOverlay(canvas);
    }
  }

  void _drawSpecialOverlay(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final center = Offset(size.x / 2, size.y / 2);

    switch (tileModel.specialType) {
      case SpecialGemType.horizontalBlast:
        // Draw horizontal glow stripe
        final paint = Paint()
          ..color = const Color(0x77FFFFFF)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(0, size.y * 0.4, size.x, size.y * 0.2), paint);

        final linePaint = Paint()
          ..color = const Color(0xFFFFCC00)
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(0, size.y * 0.4), Offset(size.x, size.y * 0.4), linePaint);
        canvas.drawLine(Offset(0, size.y * 0.6), Offset(size.x, size.y * 0.6), linePaint);
        break;

      case SpecialGemType.verticalBlast:
        // Draw vertical glow stripe
        final paint = Paint()
          ..color = const Color(0x77FFFFFF)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(size.x * 0.4, 0, size.x * 0.2, size.y), paint);

        final linePaint = Paint()
          ..color = const Color(0xFFFFCC00)
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(size.x * 0.4, 0), Offset(size.x * 0.4, size.y), linePaint);
        canvas.drawLine(Offset(size.x * 0.6, 0), Offset(size.x * 0.6, size.y), linePaint);
        break;

      case SpecialGemType.bomb:
        // Draw glowing outer ring
        final paint = Paint()
          ..color = const Color(0xFFFF3300)
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5.0);
        canvas.drawCircle(center, size.x * 0.42, paint);

        final innerPaint = Paint()
          ..color = const Color(0xFFFFBB00)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawCircle(center, size.x * 0.38, innerPaint);
        break;

      case SpecialGemType.colorClear:
        // Draw magical glowing golden outline and star symbol
        final paint = Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 4.5
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6.0);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect.deflate(2.0), const Radius.circular(12.0)),
          paint,
        );

        final centerPaint = Paint()
          ..color = const Color(0xFFFFFFFF)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(center, 5.0, centerPaint);

        final crossPaint = Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(center.dx - 10, center.dy), Offset(center.dx + 10, center.dy), crossPaint);
        canvas.drawLine(Offset(center.dx, center.dy - 10), Offset(center.dx, center.dy + 10), crossPaint);
        break;
      case SpecialGemType.none:
        break;
    }
  }

  /// Plays a juicy match-pop animation sequence: scales up quickly (overshoot),
  /// then shrinks to zero. Bypasses OpacityEffect to avoid compatibility issues.
  void playPopAnimation({required VoidCallback onComplete}) {
    isSelected = false;

    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.25),
          EffectController(duration: 0.08, curve: Curves.easeOut),
        ),
        ScaleEffect.to(
          Vector2.all(0.0),
          EffectController(duration: 0.14, curve: Curves.easeIn),
        ),
      ])..onComplete = onComplete,
    );
  }
}
