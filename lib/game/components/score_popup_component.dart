import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

/// A floating score popup visual overlay (+60, +120, etc.) that rises and fades out.
class ScorePopupComponent extends TextComponent {
  final double duration;
  double _time = 0.0;

  static const Color baseColor = Color(0xFFE2B65B);
  static const Color shadowColor = Color(0xFF2F1B12);

  ScorePopupComponent({
    required String text,
    required Vector2 position,
    this.duration = 0.65,
  }) : super(
          text: text,
          position: position,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: baseColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: shadowColor,
                  offset: Offset(1.5, 1.5),
                  blurRadius: 3.0,
                ),
              ],
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Move upwards by 45 pixels over the duration
    add(MoveByEffect(
      Vector2(0, -45),
      EffectController(duration: duration, curve: Curves.easeOut),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    if (_time >= duration) {
      removeFromParent();
      return;
    }

    // Update text paint color opacity dynamically over time
    final opacity = (1.0 - (_time / duration)).clamp(0.0, 1.0);
    textRenderer = TextPaint(
      style: TextStyle(
        color: baseColor.withOpacity(opacity),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: shadowColor.withOpacity(opacity),
            offset: const Offset(1.5, 1.5),
            blurRadius: 3.0,
          ),
        ],
      ),
    );
  }
}
