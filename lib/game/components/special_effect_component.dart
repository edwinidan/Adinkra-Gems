import 'package:flutter/material.dart';
import 'package:flame/components.dart';

enum SpecialEffectType {
  horizontalBlast,
  verticalBlast,
  bomb,
  colorClear,
}

/// Renders visual blast waves, laser beams, and chimes for special tile activations.
class SpecialEffectComponent extends PositionComponent {
  final SpecialEffectType type;
  final double maxExtent; // Horizontal width, vertical height, or radius
  final double duration;

  double _progress = 0.0; // Normalized 0.0 to 1.0 over duration

  SpecialEffectComponent({
    required this.type,
    required Vector2 position,
    required this.maxExtent,
    this.duration = 0.28,
  }) : super(
          position: position,
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    
    _progress += dt / duration;
    if (_progress >= 1.0) {
      _progress = 1.0;
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final opacity = (1.0 - _progress).clamp(0.0, 1.0);

    switch (type) {
      case SpecialEffectType.horizontalBlast:
        // Draw an expanding horizontal laser beam spanning the whole row
        final height = (1.0 - _progress) * 45.0;
        
        final glowPaint = Paint()
          ..color = const Color(0xFFFFCC00).withOpacity(opacity * 0.65)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(-maxExtent / 2, -height / 2, maxExtent, height), glowPaint);

        final corePaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(-maxExtent / 2, -height / 5, maxExtent, height * 0.4), corePaint);
        break;

      case SpecialEffectType.verticalBlast:
        // Draw an expanding vertical laser beam spanning the whole column
        final width = (1.0 - _progress) * 45.0;

        final glowPaint = Paint()
          ..color = const Color(0xFFFFCC00).withOpacity(opacity * 0.65)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(-width / 2, -maxExtent / 2, width, maxExtent), glowPaint);

        final corePaint = Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(Rect.fromLTWH(-width / 5, -maxExtent / 2, width * 0.4, maxExtent), corePaint);
        break;

      case SpecialEffectType.bomb:
        // Draw expanding translucent shockwave rings for L/T bombs
        final radius = _progress * maxExtent;
        
        final shockPaint = Paint()
          ..color = const Color(0xFFFF5500).withOpacity(opacity * 0.45)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, radius, shockPaint);

        final ringPaint = Paint()
          ..color = const Color(0xFFFFCC00).withOpacity(opacity * 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.0 * (1.0 - _progress);
        canvas.drawCircle(Offset.zero, radius, ringPaint);
        break;

      case SpecialEffectType.colorClear:
        // Draw contracting magical pulses centered around the clear action
        final radius = (1.0 - _progress) * maxExtent;
        final pulsePaint = Paint()
          ..color = const Color(0xFFFFD700).withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5;
        canvas.drawCircle(Offset.zero, radius, pulsePaint);
        break;
    }
  }
}
