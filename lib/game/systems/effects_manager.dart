import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart' show Curves;
import '../components/gem_particle_component.dart';
import '../components/score_popup_component.dart';
import '../components/special_effect_component.dart';
import '../models/gem_type.dart';

/// Coordinator that handles adding visual effects to the game board.
class EffectsManager {
  EffectsManager._();

  /// Spawns a burst of 9 colorful particles at [position] matching the [gemType] color.
  static void spawnParticleBurst(PositionComponent parent, Vector2 position, GemType gemType) {
    final rand = math.Random();
    for (int i = 0; i < 9; i++) {
      // Random polar angle and radial velocity
      final angle = rand.nextDouble() * 2.0 * math.pi;
      final speed = 80.0 + rand.nextDouble() * 160.0;
      final velocity = Vector2(math.cos(angle) * speed, math.sin(angle) * speed);

      parent.add(GemParticleComponent(
        gemType: gemType,
        position: position.clone(),
        velocity: velocity,
      ));
    }
  }

  /// Spawns a gold rising score text showing the points earned.
  static void spawnScorePopup(PositionComponent parent, Vector2 position, int score) {
    parent.add(ScorePopupComponent(
      text: '+$score',
      position: position.clone(),
    ));
  }

  /// Spawns a horizontal laser beam to clear a row.
  static void spawnHorizontalBlast(PositionComponent parent, double y, double boardWidth) {
    parent.add(SpecialEffectComponent(
      type: SpecialEffectType.horizontalBlast,
      position: Vector2(boardWidth / 2, y),
      maxExtent: boardWidth,
      duration: 0.25,
    ));
  }

  /// Spawns a vertical laser beam to clear a column.
  static void spawnVerticalBlast(PositionComponent parent, double x, double boardHeight) {
    parent.add(SpecialEffectComponent(
      type: SpecialEffectType.verticalBlast,
      position: Vector2(x, boardHeight / 2),
      maxExtent: boardHeight,
      duration: 0.25,
    ));
  }

  /// Spawns an expanding explosive wave covering a 3x3 circle.
  static void spawnBombBlast(PositionComponent parent, Vector2 position, double tileSize) {
    parent.add(SpecialEffectComponent(
      type: SpecialEffectType.bomb,
      position: position.clone(),
      maxExtent: tileSize * 2.5,
      duration: 0.32,
    ));
  }

  /// Spawns contracting magical golden rings centered on a color clear event.
  static void spawnColorClearPulse(PositionComponent parent, Vector2 position, double tileSize) {
    parent.add(SpecialEffectComponent(
      type: SpecialEffectType.colorClear,
      position: position.clone(),
      maxExtent: tileSize * 1.5,
      duration: 0.24,
    ));
  }

  /// Performs a fast, visual screen shake of [targetComponent] (e.g. the entire board).
  static void triggerBoardShake(PositionComponent targetComponent) {
    final originalPos = targetComponent.position.clone();
    
    // Create a chain of small offsets that snaps back to the original position
    final shakeEffect = SequenceEffect([
      MoveEffect.to(originalPos + Vector2(-6.0, 4.0), EffectController(duration: 0.035, curve: Curves.linear)),
      MoveEffect.to(originalPos + Vector2(7.0, -6.0), EffectController(duration: 0.035, curve: Curves.linear)),
      MoveEffect.to(originalPos + Vector2(-5.0, 5.0), EffectController(duration: 0.035, curve: Curves.linear)),
      MoveEffect.to(originalPos + Vector2(6.0, -3.0), EffectController(duration: 0.035, curve: Curves.linear)),
      MoveEffect.to(originalPos, EffectController(duration: 0.035, curve: Curves.linear)),
    ]);

    targetComponent.add(shakeEffect);
  }
}
