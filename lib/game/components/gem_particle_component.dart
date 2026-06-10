import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../../game/models/gem_type.dart';

/// Renders individual floating, spinning, and gravity-bound gem shards when matching occurs.
class GemParticleComponent extends PositionComponent {
  final GemType gemType;
  final Vector2 velocity;
  
  static const double gravity = 480.0; // Gravitational acceleration downwards
  static const double drag = 0.975;     // Air resistance deceleration scale

  double _opacity = 1.0;
  late final double _rotationSpeed;
  late final Color _color;

  GemParticleComponent({
    required this.gemType,
    required Vector2 position,
    required this.velocity,
    double size = 9.0,
  }) : super(
          position: position,
          size: Vector2.all(size),
          anchor: Anchor.center,
        ) {
    final rand = math.Random();
    _rotationSpeed = (rand.nextDouble() - 0.5) * 12.0; // Random rotational speed/dir
    _color = _colorForGem(gemType);
  }

  /// Map the GemType enum values to harmonious visual color representations.
  static Color _colorForGem(GemType type) {
    switch (type) {
      case GemType.redFuntumfunefuDenkyemfunefu:
        return const Color(0xFFFF4D4D);
      case GemType.silverNsoromma:
        return const Color(0xFFF0F0F0);
      case GemType.yellowSankofa:
        return const Color(0xFFFFD700);
      case GemType.purpleAkofena:
        return const Color(0xFFC71585);
      case GemType.greenGyeNyame:
        return const Color(0xFF32CD32);
      case GemType.blueDwennimmen:
        return const Color(0xFF1E90FF);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity to vertical speed
    velocity.y += gravity * dt;

    // Apply drag deceleration
    velocity.scale(math.pow(drag, dt * 60).toDouble());

    // Update positions based on current speed
    position += velocity * dt;

    // Spin
    angle += _rotationSpeed * dt;

    // Fade out linearly
    _opacity -= 2.0 * dt;
    if (_opacity <= 0.0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = _color.withOpacity(_opacity.clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    // Draw diamond shape for gem shard look
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y / 2)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y / 2)
      ..close();

    canvas.drawPath(path, paint);
  }
}
