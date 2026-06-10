import 'package:flame/cache.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../../game/board/board_generator.dart';
import '../../game/board/board_model.dart';
import '../../game/data/gem_assets.dart';
import '../../game/models/gem_type.dart';
import '../../game/models/level_config.dart';
import 'components/board_component.dart';
import 'systems/level_controller.dart';

/// The root Flame Game class for Adinkra Gems.
///
/// Manages preloading sprite assets, generating the starting board state,
/// scaling/positioning the board component, and ticking the level timer.
class AdinkraGemsGame extends FlameGame {
  /// Configuration for the current level.
  final LevelConfig levelConfig;

  /// State tracker for level progress.
  final LevelController levelController;

  /// The underlying logical grid.
  late final BoardModel boardModel;

  /// Preloaded sprites for quick, synchronous rendering.
  final Map<GemType, Sprite> gemSprites = {};

  double _timerAccumulator = 0.0;

  AdinkraGemsGame({
    required this.levelConfig,
    required this.levelController,
  });

  // Direct Flame to search for assets under 'assets/tiles/'.
  @override
  final images = Images(prefix: 'assets/tiles/');

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Preload all gem sprites into the map cache
    for (final gemType in GemType.values) {
      final filename = GemAssets.pathFor(gemType).split('/').last;
      final sprite = await loadSprite(filename);
      gemSprites[gemType] = sprite;
    }

    // 2. Generate the starting board logic
    boardModel = BoardGenerator.generate(levelConfig.availableGems);

    // 3. Calculate dynamic layout size based on screen bounds
    const double horizontalPadding = 16.0;
    final availableWidth = size.x - (horizontalPadding * 2);
    final tileSize = (availableWidth / 8).floorToDouble();

    // 4. Instantiate and center the board component
    final boardWidth = tileSize * 8;
    final boardHeight = tileSize * 8;

    final boardComponent = BoardComponent(
      boardModel: boardModel,
      tileSize: tileSize,
    );

    boardComponent.position = Vector2(
      (size.x - boardWidth) / 2,
      (size.y - boardHeight) / 2,
    );

    add(boardComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // If level has a timer and game is active, update the countdown seconds
    if (levelController.hasTimer && !levelController.isGameOver) {
      _timerAccumulator += dt;
      if (_timerAccumulator >= 1.0) {
        _timerAccumulator -= 1.0;
        levelController.decrementTime();
      }
    }
  }
}
