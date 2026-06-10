import 'dart:ui';
import 'package:flutter/widgets.dart' show Curves;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import '../../game/board/board_generator.dart';
import '../../game/board/board_model.dart';
import '../../game/board/cascade_resolver.dart';
import '../../game/board/grid_position.dart';
import '../../game/board/move_validator.dart';
import '../../game/board/reshuffle_service.dart';
import '../../game/models/special_gem_type.dart';
import '../../services/audio_service.dart';
import '../adinkra_gems_game.dart';
import '../systems/effects_manager.dart';
import 'tile_component.dart';

/// Renders the 8x8 grid cells, hosts the [TileComponent] children,
/// and handles all user input (taps, selects, and drags/swipes).
class BoardComponent extends PositionComponent
    with HasGameRef<AdinkraGemsGame>, TapCallbacks, DragCallbacks {
  final BoardModel boardModel;
  final double tileSize;

  GridPosition? _selectedPosition;
  GridPosition? _dragStartPosition;
  Vector2 _accumulatedDragOffset = Vector2.zero();
  bool _inputLocked = false;
  int _cascadeIndex = 0;

  BoardComponent({
    required this.boardModel,
    required this.tileSize,
  }) : super(
          size: Vector2(
            tileSize * BoardModel.cols,
            tileSize * BoardModel.rows,
          ),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spawnTiles();
  }

  /// Populates the visual board with tiles from the logical board model.
  void _spawnTiles() {
    for (int r = 0; r < BoardModel.rows; r++) {
      for (int c = 0; c < BoardModel.cols; c++) {
        final pos = GridPosition(r, c);
        final tile = boardModel.get(pos);
        if (tile != null) {
          final sprite = gameRef.gemSprites[tile.gemType];
          if (sprite != null) {
            final tileComp = TileComponent(
              tileModel: tile,
              gridPosition: pos,
              sprite: sprite,
              size: tileSize * 0.85,
            );

            // Set visual position centered inside the cell
            tileComp.position = Vector2(
              c * tileSize + tileSize / 2,
              r * tileSize + tileSize / 2,
            );

            add(tileComp);
          }
        }
      }
    }
  }

  /// Looks up a visual [TileComponent] child by its grid position.
  TileComponent? tileAt(GridPosition pos) {
    for (final child in children) {
      if (child is TileComponent && child.gridPosition == pos) {
        return child;
      }
    }
    return null;
  }

  /// Resolves the grid coordinate for a local canvas coordinate.
  GridPosition? _positionAt(Vector2 localPos) {
    final col = (localPos.x / tileSize).floor();
    final row = (localPos.y / tileSize).floor();
    final pos = GridPosition(row, col);
    if (boardModel.isInBounds(pos)) {
      return pos;
    }
    return null;
  }

  /// Checks if any tile is currently playing a motion animation or if input is locked.
  bool get isLocked {
    if (_inputLocked) return true;
    for (final child in children) {
      if (child is TileComponent && child.children.any((c) => c is MoveEffect)) {
        return true;
      }
    }
    return false;
  }

  // ── Tap/Select Input ───────────────────────────────────────────────────────

  @override
  void onTapDown(TapDownEvent event) {
    if (isLocked) return;

    final pos = _positionAt(event.localPosition);
    if (pos == null) return;

    final selectedPos = _selectedPosition;
    if (selectedPos == null) {
      // 1. Select the first tile
      _selectedPosition = pos;
      tileAt(pos)?.isSelected = true;
    } else {
      if (selectedPos == pos) {
        // 2. Tapping the same tile deselects it
        tileAt(pos)?.isSelected = false;
        _selectedPosition = null;
      } else if (pos.isAdjacentTo(selectedPos)) {
        // 3. Tapping an adjacent tile attempts a swap
        swapTiles(selectedPos, pos);
      } else {
        // 4. Tapping a non-adjacent tile selects the new tile instead
        tileAt(selectedPos)?.isSelected = false;
        _selectedPosition = pos;
        tileAt(pos)?.isSelected = true;
      }
    }
  }

  // ── Drag/Swipe Input ───────────────────────────────────────────────────────

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (isLocked) return;

    final pos = _positionAt(event.localPosition);
    if (pos != null) {
      _dragStartPosition = pos;
      _accumulatedDragOffset = Vector2.zero();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (isLocked || _dragStartPosition == null) {
      return;
    }

    _accumulatedDragOffset += event.localDelta;
    final threshold = tileSize * 0.35; // Trigger swipe at 35% tile distance

    if (_accumulatedDragOffset.length > threshold) {
      // Determine swipe direction
      GridPosition targetPos;
      final start = _dragStartPosition!;

      if (_accumulatedDragOffset.x.abs() > _accumulatedDragOffset.y.abs()) {
        // Horizontal swipe
        final colDelta = _accumulatedDragOffset.x > 0 ? 1 : -1;
        targetPos = GridPosition(start.row, start.col + colDelta);
      } else {
        // Vertical swipe
        final rowDelta = _accumulatedDragOffset.y > 0 ? 1 : -1;
        targetPos = GridPosition(start.row + rowDelta, start.col);
      }

      if (boardModel.isInBounds(targetPos)) {
        swapTiles(start, targetPos);
      }

      // Reset drag tracking so we don't trigger multiple swaps
      _dragStartPosition = null;
      _accumulatedDragOffset = Vector2.zero();
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragStartPosition = null;
    _accumulatedDragOffset = Vector2.zero();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _dragStartPosition = null;
    _accumulatedDragOffset = Vector2.zero();
  }

  // ── Swapping Mechanics ─────────────────────────────────────────────────────

  /// Performs visual and logical swapping of tiles.
  /// Valid swaps update the board, trigger cascades, and unlock.
  /// Invalid swaps bounce back and unlock.
  void swapTiles(GridPosition a, GridPosition b) {
    final tileA = tileAt(a);
    final tileB = tileAt(b);
    if (tileA == null || tileB == null) return;

    _inputLocked = true;
    AudioService.playSwap();

    // Deselect active tiles
    tileA.isSelected = false;
    tileB.isSelected = false;
    _selectedPosition = null;

    final posA = Vector2(a.col * tileSize + tileSize / 2, a.row * tileSize + tileSize / 2);
    final posB = Vector2(b.col * tileSize + tileSize / 2, b.row * tileSize + tileSize / 2);

    final validator = MoveValidator();
    final isValid = validator.isValidSwap(boardModel, a, b);

    const swapDuration = 0.22;

    if (isValid) {
      // 1. Valid Swap: Update model and animate visual position change
      boardModel.swap(a, b);
      tileA.gridPosition = b;
      tileB.gridPosition = a;

      // Reset cascade index
      _cascadeIndex = 0;

      // Decrement move count in LevelController
      gameRef.levelController.useMove();

      tileA.add(MoveEffect.to(
        posB,
        EffectController(duration: swapDuration, curve: Curves.easeInOutQuad),
      ));
      tileB.add(MoveEffect.to(
        posA,
        EffectController(duration: swapDuration, curve: Curves.easeInOutQuad),
      )..onComplete = () {
        // Start Cascade resolution chain
        _runCascadeCycle(swapA: a, swapB: b);
      });
    } else {
      // 2. Invalid Swap: Animate sliding swap, then bounce back immediately
      tileA.add(SequenceEffect([
        MoveEffect.to(posB, EffectController(duration: swapDuration * 0.8, curve: Curves.easeOutQuad)),
        MoveEffect.to(posA, EffectController(duration: swapDuration * 0.8, curve: Curves.easeInQuad)),
      ]));

      tileB.add(SequenceEffect([
        MoveEffect.to(posA, EffectController(duration: swapDuration * 0.8, curve: Curves.easeOutQuad)),
        MoveEffect.to(posB, EffectController(duration: swapDuration * 0.8, curve: Curves.easeInQuad)),
      ])..onComplete = () {
        _inputLocked = false;
      });
    }
  }

  // ── Cascade & Gravity Loop ─────────────────────────────────────────────────

  /// Scans for matches, removes them, and drops/spawns new tiles iteratively.
  void _runCascadeCycle({GridPosition? swapA, GridPosition? swapB}) {
    final step = CascadeResolver.resolveStep(
      boardModel,
      gameRef.levelConfig.availableGems,
      swapA: swapA,
      swapB: swapB,
    );

    if (step == null) {
      // Cascade complete! Board is now stable. Reset cascade index.
      _cascadeIndex = 0;

      final validator = MoveValidator();
      if (!validator.hasAnyValidMove(boardModel) && !gameRef.levelController.isGameOver) {
        _triggerReshuffle();
      } else {
        _inputLocked = false;
      }
      return;
    }

    _inputLocked = true;

    // Determine cascade multiplier
    double multiplier = 1.0;
    if (_cascadeIndex == 1) {
      multiplier = 1.5;
    } else if (_cascadeIndex == 2) {
      multiplier = 2.0;
    } else if (_cascadeIndex >= 3) {
      multiplier = 2.5;
    }
    _cascadeIndex++;

    // A. Play audio feedback: playSpecialClear if any cleared tile was special, else playMatch
    bool hasSpecialClear = step.specialClears.isNotEmpty;
    bool hasSpecialMatch = false;

    // 1. Visual Tile Removal phase
    final matchedPositions = <GridPosition>{};

    for (final group in step.matches) {
      matchedPositions.addAll(group.positions);
      gameRef.levelController.recordMatch(
        group.gemType,
        group.length,
        specialCreated: group.specialCreated,
        multiplier: multiplier,
      );

      for (final pos in group.positions) {
        final t = tileAt(pos);
        if (t != null && t.tileModel.specialType != SpecialGemType.none) {
          hasSpecialMatch = true;
        }
      }
    }

    // Add special clears
    for (final sc in step.specialClears) {
      matchedPositions.add(sc.position);
      gameRef.levelController.recordSpecialClear(
        sc.tile.gemType,
        multiplier: multiplier,
      );
    }

    if (hasSpecialClear || hasSpecialMatch) {
      AudioService.playSpecialClear();
    } else if (step.matches.isNotEmpty) {
      AudioService.playMatch();
    }

    // B. Trigger visual power-up sweeps and board shake
    final triggeredSpecials = <GridPosition, SpecialGemType>{};
    for (final pos in matchedPositions) {
      final tileComp = tileAt(pos);
      if (tileComp != null && tileComp.tileModel.specialType != SpecialGemType.none) {
        triggeredSpecials[pos] = tileComp.tileModel.specialType;
      }
    }

    if (triggeredSpecials.isNotEmpty) {
      EffectsManager.triggerBoardShake(this);
      triggeredSpecials.forEach((pos, specialType) {
        final tileComp = tileAt(pos);
        if (tileComp != null) {
          switch (specialType) {
            case SpecialGemType.horizontalBlast:
              EffectsManager.spawnHorizontalBlast(this, tileComp.y, size.x);
              break;
            case SpecialGemType.verticalBlast:
              EffectsManager.spawnVerticalBlast(this, tileComp.x, size.y);
              break;
            case SpecialGemType.bomb:
              EffectsManager.spawnBombBlast(this, tileComp.position, tileSize);
              break;
            case SpecialGemType.colorClear:
              EffectsManager.spawnColorClearPulse(this, tileComp.position, tileSize);
              break;
            case SpecialGemType.none:
              break;
          }
        }
      });
    }

    // C. Trigger floating score popups and particle bursts
    // 1. Matches
    for (final group in step.matches) {
      int basePoints = 60;
      if (group.specialCreated == SpecialGemType.bomb) {
        basePoints = 300;
      } else if (group.length >= 5) {
        basePoints = 250;
      } else if (group.length == 4) {
        basePoints = 120;
      }
      final pointsEarned = (basePoints * multiplier).toInt();

      double sumX = 0, sumY = 0;
      for (final pos in group.positions) {
        final wPos = Vector2(pos.col * tileSize + tileSize / 2, pos.row * tileSize + tileSize / 2);
        sumX += wPos.x;
        sumY += wPos.y;
        EffectsManager.spawnParticleBurst(this, wPos, group.gemType);
      }
      final centerPos = Vector2(sumX / group.positions.length, sumY / group.positions.length);
      EffectsManager.spawnScorePopup(this, centerPos, pointsEarned);
    }

    // 2. Special Clears
    for (final sc in step.specialClears) {
      final wPos = Vector2(sc.position.col * tileSize + tileSize / 2, sc.position.row * tileSize + tileSize / 2);
      final pointsEarned = (20 * multiplier).toInt();
      EffectsManager.spawnScorePopup(this, wPos, pointsEarned);
      EffectsManager.spawnParticleBurst(this, wPos, sc.tile.gemType);
    }

    // Exclude the positions of newly created special tiles from visual removal!
    final createdSpecials = step.createdSpecials;
    final positionsToRemove = matchedPositions.where((pos) => !createdSpecials.containsKey(pos)).toList();

    // Visual upgrade effect for created special tiles
    for (final entry in createdSpecials.entries) {
      final pos = entry.key;
      final type = entry.value;
      final tileComp = tileAt(pos);
      if (tileComp != null) {
        // Upgrade visual special type and play celebration scale pulse
        tileComp.tileModel.specialType = type;
        tileComp.add(
          SequenceEffect([
            ScaleEffect.to(Vector2.all(1.25), EffectController(duration: 0.15, curve: Curves.easeOut)),
            ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.15, curve: Curves.easeIn)),
          ]),
        );
      }
    }

    // D. Visual Tile Removal phase using playPopAnimation
    int removeAnimationsCount = 0;
    for (final pos in positionsToRemove) {
      final tileComp = tileAt(pos);
      if (tileComp != null) {
        removeAnimationsCount++;
        tileComp.playPopAnimation(
          onComplete: () {
            removeAnimationsCount--;
            tileComp.removeFromParent();

            // Start gravity fall phase once all matched tiles are cleared
            if (removeAnimationsCount == 0) {
              _animateFallsAndSpawns(step);
            }
          },
        );
      }
    }

    if (removeAnimationsCount == 0) {
      _animateFallsAndSpawns(step);
    }
  }

  /// Animates existing tiles falling and new tiles spawning above the screen.
  void _animateFallsAndSpawns(CascadeStep step) {
    int fallingAnimationsCount = 0;

    void onAnimationComplete() {
      fallingAnimationsCount--;
      if (fallingAnimationsCount == 0) {
        // Proceed to check for next cascade step (re-evaluation)
        _runCascadeCycle();
      }
    }

    // A. Move falling tiles
    for (final fall in step.falls) {
      final tileComp = tileAt(fall.from);
      if (tileComp != null) {
        fallingAnimationsCount++;
        tileComp.gridPosition = fall.to;

        final targetX = fall.to.col * tileSize + tileSize / 2;
        final targetY = fall.to.row * tileSize + tileSize / 2;

        tileComp.add(
          MoveEffect.to(
            Vector2(targetX, targetY),
            EffectController(duration: 0.28, curve: Curves.easeInQuad),
          )..onComplete = () {
            // Play landing squash and stretch
            tileComp.add(
              SequenceEffect([
                ScaleEffect.to(Vector2(1.15, 0.85), EffectController(duration: 0.07, curve: Curves.easeOut)),
                ScaleEffect.to(Vector2(0.92, 1.08), EffectController(duration: 0.07, curve: Curves.easeInOut)),
                ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.07, curve: Curves.easeIn)),
              ]),
            );
            onAnimationComplete();
          },
        );
      }
    }

    // B. Spawn and slide down new tiles
    for (final spawn in step.spawns) {
      fallingAnimationsCount++;
      final sprite = gameRef.gemSprites[spawn.tile.gemType]!;

      final tileComp = TileComponent(
        tileModel: spawn.tile,
        gridPosition: spawn.to,
        sprite: sprite,
        size: tileSize * 0.85,
      );

      // Start offscreen above the board
      final startX = spawn.to.col * tileSize + tileSize / 2;
      final startY = -tileSize * 1.5;
      tileComp.position = Vector2(startX, startY);

      add(tileComp);

      final targetX = spawn.to.col * tileSize + tileSize / 2;
      final targetY = spawn.to.row * tileSize + tileSize / 2;

      tileComp.add(
        MoveEffect.to(
          Vector2(targetX, targetY),
          EffectController(duration: 0.32, curve: Curves.easeInQuad),
        )..onComplete = () {
          // Play landing squash and stretch
          tileComp.add(
            SequenceEffect([
              ScaleEffect.to(Vector2(1.15, 0.85), EffectController(duration: 0.07, curve: Curves.easeOut)),
              ScaleEffect.to(Vector2(0.92, 1.08), EffectController(duration: 0.07, curve: Curves.easeInOut)),
              ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.07, curve: Curves.easeIn)),
            ]),
          );
          onAnimationComplete();
        },
      );
    }

    if (fallingAnimationsCount == 0) {
      _runCascadeCycle();
    }
  }

  // ── Reshuffling Loop ───────────────────────────────────────────────────────

  /// Gathers all tiles to the center, shuffles them logically,
  /// and disperses them back with landing bounces.
  void _triggerReshuffle() {
    _inputLocked = true;
    AudioService.playSwap();

    final boardCenter = Vector2(size.x / 2, size.y / 2);
    int activeAnimations = 0;

    final tilesList = children.whereType<TileComponent>().toList();
    if (tilesList.isEmpty) {
      _inputLocked = false;
      return;
    }

    // 1. Animate all tile components to the center of the board
    for (final tileComp in tilesList) {
      activeAnimations++;
      tileComp.isSelected = false;

      tileComp.add(
        MoveEffect.to(
          boardCenter,
          EffectController(duration: 0.45, curve: Curves.easeInBack),
        ),
      );
      tileComp.add(
        ScaleEffect.to(
          Vector2.all(0.2),
          EffectController(duration: 0.45, curve: Curves.easeInBack),
        )..onComplete = () {
            activeAnimations--;

            if (activeAnimations == 0) {
              // 2. Perform logical reshuffle of the tiles
              final success = ReshuffleService.reshuffle(boardModel);

              if (!success) {
                // Hard Fallback: Force regenerate board and reset components
                final fresh = BoardGenerator.generate(gameRef.levelConfig.availableGems);
                for (int r = 0; r < BoardModel.rows; r++) {
                  for (int c = 0; c < BoardModel.cols; c++) {
                    final pos = GridPosition(r, c);
                    boardModel.set(pos, fresh.get(pos));
                  }
                }

                // Clean components and rebuild
                children.whereType<TileComponent>().forEach((t) => t.removeFromParent());
                _spawnTiles();
                _inputLocked = false;
                return;
              }

              // 3. Disperse components from the center to their new coordinates
              _animateTilesFromCenter(boardCenter);
            }
          },
      );
    }
  }

  /// Animates the components from the center back to their resolved grid slots.
  void _animateTilesFromCenter(Vector2 boardCenter) {
    int activeAnimations = 0;
    final tilesList = children.whereType<TileComponent>().toList();

    for (final tileComp in tilesList) {
      GridPosition? newPos;
      // Search where this tile has been shuffled to
      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          final pos = GridPosition(r, c);
          if (boardModel.get(pos)?.id == tileComp.tileModel.id) {
            newPos = pos;
            break;
          }
        }
      }

      if (newPos != null) {
        activeAnimations++;
        tileComp.gridPosition = newPos;

        final targetX = newPos.col * tileSize + tileSize / 2;
        final targetY = newPos.row * tileSize + tileSize / 2;

        tileComp.add(
          MoveEffect.to(
            Vector2(targetX, targetY),
            EffectController(duration: 0.55, curve: Curves.bounceOut),
          ),
        );
        tileComp.add(
          ScaleEffect.to(
            Vector2.all(1.0),
            EffectController(duration: 0.55, curve: Curves.bounceOut),
          )..onComplete = () {
              activeAnimations--;
              if (activeAnimations == 0) {
                _inputLocked = false;

                // Scan again to ensure board is 100% stable
                _runCascadeCycle();
              }
            },
        );
      } else {
        tileComp.removeFromParent();
      }
    }

    if (activeAnimations == 0) {
      _inputLocked = false;
    }
  }

  // ── Custom Drawing ─────────────────────────────────────────────────────────

  @override
  void render(Canvas canvas) {
    // Draw premium glassmorphic background for the board
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final bgRRect = RRect.fromRectAndRadius(rect, const Radius.circular(20));

    // Dark cocoa keeps the colorful gems readable against the woven UI.
    final bgPaint = Paint()
      ..color = const Color(0xFF3A2418).withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bgRRect, bgPaint);

    // Subtle gold border
    final borderPaint = Paint()
      ..color = const Color(0xFFE2B65B).withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(bgRRect, borderPaint);

    // Draw 8x8 subtle background slots for grid positions
    final cellPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.02)
      ..style = PaintingStyle.fill;

    final cellBorderPaint = Paint()
      ..color = const Color(0xFFE2B65B).withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int r = 0; r < BoardModel.rows; r++) {
      for (int c = 0; c < BoardModel.cols; c++) {
        final cellRect = Rect.fromLTWH(
          c * tileSize + 3,
          r * tileSize + 3,
          tileSize - 6,
          tileSize - 6,
        );
        final cellRRect = RRect.fromRectAndRadius(cellRect, const Radius.circular(10));
        canvas.drawRRect(cellRRect, cellPaint);
        canvas.drawRRect(cellRRect, cellBorderPaint);
      }
    }

    super.render(canvas);
  }
}
