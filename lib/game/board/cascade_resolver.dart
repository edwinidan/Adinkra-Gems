import 'dart:math';

import '../models/combo_type.dart';
import '../models/gem_type.dart';
import '../models/match_group.dart';
import '../models/special_gem_type.dart';
import '../models/tile_model.dart';
import 'board_model.dart';
import 'grid_position.dart';
import 'match_finder.dart';

/// Represents a single movement of an existing tile falling down to fill a gap.
class TileFall {
  final GridPosition from;
  final GridPosition to;

  const TileFall(this.from, this.to);

  @override
  String toString() => 'TileFall(from: $from, to: $to)';
}

/// Represents a new tile being spawned above the grid and falling into position.
class TileSpawn {
  final GridPosition to;
  final TileModel tile;

  const TileSpawn(this.to, this.tile);

  @override
  String toString() => 'TileSpawn(to: $to, tile: ${tile.gemType})';
}

/// Represents a single tile cleared by a special power-up effect.
class SpecialClearInfo {
  final GridPosition position;
  final TileModel tile;

  const SpecialClearInfo(this.position, this.tile);

  @override
  String toString() =>
      'SpecialClearInfo(position: $position, tile: ${tile.gemType})';
}

/// Represents damage taken by a clay pot blocker.
class PotDamageInfo {
  final GridPosition position;
  final int remainingLayers; // 0 means destroyed

  const PotDamageInfo(this.position, this.remainingLayers);

  @override
  String toString() =>
      'PotDamageInfo(position: $position, remainingLayers: $remainingLayers)';
}

/// Holds all changes that occur during a single match-and-drop cycle.
class CascadeStep {
  /// All matches detected in this cycle.
  final List<MatchGroup> matches;

  /// Existing tiles that fell to fill empty spaces.
  final List<TileFall> falls;

  /// New tiles that spawned at the top of the columns.
  final List<TileSpawn> spawns;

  /// Special clears that happened in this step.
  final List<SpecialClearInfo> specialClears;

  /// Special tiles created in this step.
  final Map<GridPosition, SpecialGemType> createdSpecials;

  /// List of grid positions where a clear mark was successfully removed.
  final List<GridPosition> clearedMarks;

  /// List of pots that took damage.
  final List<PotDamageInfo> potDamages;

  /// The type of combo triggered during this step, if any.
  final ComboType? triggeredCombo;

  /// The position where the combo was triggered.
  final GridPosition? comboPosition;

  const CascadeStep({
    required this.matches,
    required this.falls,
    required this.spawns,
    this.specialClears = const [],
    this.createdSpecials = const {},
    this.clearedMarks = const [],
    this.potDamages = const [],
    this.triggeredCombo,
    this.comboPosition,
  });

  bool get isEmpty =>
      matches.isEmpty &&
      falls.isEmpty &&
      spawns.isEmpty &&
      specialClears.isEmpty &&
      clearedMarks.isEmpty &&
      potDamages.isEmpty &&
      triggeredCombo == null;
}

/// Resolves matches and computes cascading gravity drops on a [BoardModel].
///
/// This is a pure-logic resolver. It mutates the logical board model instantly
/// and returns detailed instructions ([CascadeStep]) for Flame to animate.
class CascadeResolver {
  CascadeResolver._();

  static int _spawnCounter = 0;

  /// Scans the board for matches, removes them, drops existing tiles,
  /// spawns new tiles, and returns a [CascadeStep] describing the changes.
  ///
  /// Returns null if the board is already stable (no matches found).
  static CascadeStep? resolveStep(
    BoardModel board,
    List<GemType> availableGems, {
    Random? random,
    GridPosition? swapA,
    GridPosition? swapB,
  }) {
    final rng = random ?? Random();
    final finder = MatchFinder();

    final toClear = <GridPosition>{};
    final processingQueue = <GridPosition>[];
    final specialClearsMap = <GridPosition, TileModel>{};

    // Check for special combos
    ComboType? triggeredCombo;
    GridPosition? comboPos;
    GemType? targetColor; // For Unity + Normal

    if (swapA != null && swapB != null) {
      final tileA = board.get(swapA);
      final tileB = board.get(swapB);
      if (tileA != null && tileB != null && tileA.isSpecial && tileB.isSpecial) {
        comboPos = swapA; // Center on swap target

        // Check Unity + Normal (since normal gems are not strictly "isSpecial", 
        // wait, Unity+Normal means one is colorClear and the other could be ANY gem.)
      }
      
      // Let's refine the combo detection since colorClear + Normal is valid
      if (tileA != null && tileB != null) {
        bool aIsCC = tileA.specialType == SpecialGemType.colorClear;
        bool bIsCC = tileB.specialType == SpecialGemType.colorClear;
        
        if (aIsCC && !bIsCC) {
           triggeredCombo = ComboType.unityNormal;
           comboPos = swapA;
           targetColor = tileB.gemType;
        } else if (bIsCC && !aIsCC) {
           triggeredCombo = ComboType.unityNormal;
           comboPos = swapB;
           targetColor = tileA.gemType;
        } else if (tileA.isSpecial && tileB.isSpecial) {
           // We have two regular specials (Line or Burst)
           bool aIsLine = tileA.specialType == SpecialGemType.horizontalBlast || tileA.specialType == SpecialGemType.verticalBlast;
           bool bIsLine = tileB.specialType == SpecialGemType.horizontalBlast || tileB.specialType == SpecialGemType.verticalBlast;
           bool aIsBurst = tileA.specialType == SpecialGemType.bomb;
           bool bIsBurst = tileB.specialType == SpecialGemType.bomb;
           
           if (aIsLine && bIsLine) {
             triggeredCombo = ComboType.lineLine;
             comboPos = swapA;
           } else if ((aIsLine && bIsBurst) || (aIsBurst && bIsLine)) {
             triggeredCombo = ComboType.lineBurst;
             comboPos = swapA;
           } else if (aIsBurst && bIsBurst) {
             triggeredCombo = ComboType.burstBurst;
             comboPos = swapA;
           }
        }
      }
    }

    List<MatchGroup> matches = [];

    if (triggeredCombo != null) {
      // Clear the two swapped tiles
      toClear.add(swapA!);
      toClear.add(swapB!);
      processingQueue.add(swapA);
      processingQueue.add(swapB);
      
      if (board.get(swapA) != null) specialClearsMap[swapA] = board.get(swapA)!;
      if (board.get(swapB) != null) specialClearsMap[swapB] = board.get(swapB)!;

      if (triggeredCombo == ComboType.unityNormal && targetColor != null) {
        for (int r = 0; r < board.rowCount; r++) {
          for (int c = 0; c < board.colCount; c++) {
            final pos = GridPosition(r, c);
            final tile = board.get(pos);
            if (tile != null && tile.gemType == targetColor && pos != swapA && pos != swapB) {
              toClear.add(pos);
              processingQueue.add(pos);
              specialClearsMap[pos] = tile;
            }
          }
        }
      } else if (triggeredCombo == ComboType.lineLine) {
        // Clear row and col of comboPos
        for (int r = 0; r < board.rowCount; r++) {
          final pos = GridPosition(r, comboPos!.col);
          if (board.get(pos) != null) {
            toClear.add(pos);
            processingQueue.add(pos);
            specialClearsMap[pos] = board.get(pos)!;
          }
        }
        for (int c = 0; c < board.colCount; c++) {
          final pos = GridPosition(comboPos!.row, c);
          if (board.get(pos) != null) {
            toClear.add(pos);
            processingQueue.add(pos);
            specialClearsMap[pos] = board.get(pos)!;
          }
        }
      } else if (triggeredCombo == ComboType.lineBurst) {
        // Clear 3 rows and 3 cols
        for (int rowOffset = -1; rowOffset <= 1; rowOffset++) {
          int r = comboPos!.row + rowOffset;
          if (r >= 0 && r < board.rowCount) {
            for (int c = 0; c < board.colCount; c++) {
              final pos = GridPosition(r, c);
              if (board.get(pos) != null) {
                toClear.add(pos);
                processingQueue.add(pos);
                specialClearsMap[pos] = board.get(pos)!;
              }
            }
          }
        }
        for (int colOffset = -1; colOffset <= 1; colOffset++) {
          int c = comboPos!.col + colOffset;
          if (c >= 0 && c < board.colCount) {
            for (int r = 0; r < board.rowCount; r++) {
              final pos = GridPosition(r, c);
              if (board.get(pos) != null) {
                toClear.add(pos);
                processingQueue.add(pos);
                specialClearsMap[pos] = board.get(pos)!;
              }
            }
          }
        }
      } else if (triggeredCombo == ComboType.burstBurst) {
        // Clear 5x5 area
        for (int r = comboPos!.row - 2; r <= comboPos.row + 2; r++) {
          for (int c = comboPos.col - 2; c <= comboPos.col + 2; c++) {
            final target = GridPosition(r, c);
            if (board.isInBounds(target) && board.get(target) != null) {
              toClear.add(target);
              processingQueue.add(target);
              specialClearsMap[target] = board.get(target)!;
            }
          }
        }
      }
    } else {
      matches = finder.findMatches(board, swapA: swapA, swapB: swapB);
      if (matches.isEmpty) return null;

      for (final group in matches) {
        for (final pos in group.positions) {
          toClear.add(pos);
          processingQueue.add(pos);
        }
      }
    }

    // Process queue recursively for special tile chains
    final activatedSpecials = <GridPosition>{};

    while (processingQueue.isNotEmpty) {
      final pos = processingQueue.removeAt(0);
      final tile = board.get(pos);
      if (tile == null) continue;

      if (tile.isSpecial && !activatedSpecials.contains(pos)) {
        activatedSpecials.add(pos);

        final effectPositions = _getSpecialEffectPositions(
          board,
          pos,
          tile.specialType,
        );
        for (final ep in effectPositions) {
          if (!toClear.contains(ep)) {
            toClear.add(ep);
            processingQueue.add(ep);
            final epTile = board.get(ep);
            if (epTile != null) {
              specialClearsMap[ep] = epTile;
            }
          }
        }
      }
    }

    // Determine special tiles that should be created in the matched groups
    final createdSpecials = <GridPosition, SpecialGemType>{};
    final createdSpecialGems = <GridPosition, GemType>{};
    for (final group in matches) {
      if (group.specialCreated != SpecialGemType.none &&
          group.specialSpawnPosition != null) {
        createdSpecials[group.specialSpawnPosition!] = group.specialCreated;
        createdSpecialGems[group.specialSpawnPosition!] = group.gemType;
      }
    }

    // Mutate board model: clear cells except where special tiles are created
    final clearedMarks = <GridPosition>[];
    for (final pos in toClear) {
      if (createdSpecials.containsKey(pos)) {
        // Upgrade this tile to special instead of clearing
        final tile = board.get(pos);
        if (tile != null) {
          tile.specialType = createdSpecials[pos]!;
          tile.isMatched = false;
        } else {
          board.set(
            pos,
            TileModel(
              id: 'special_${pos.row}_${pos.col}_${DateTime.now().microsecondsSinceEpoch}',
              gemType: createdSpecialGems[pos]!,
              specialType: createdSpecials[pos]!,
            ),
          );
        }
      } else {
        board.set(pos, null);
      }
      
      // Clear mark if present
      final cellState = board.getCellState(pos);
      if (cellState != null && cellState.hasMark) {
        cellState.clearMark();
        clearedMarks.add(pos);
      }
    }
    
    // Check for pot damage around cleared tiles
    final potDamages = <PotDamageInfo>[];
    final damagedPots = <GridPosition>{};
    for (final pos in toClear) {
      final neighbors = [
        GridPosition(pos.row - 1, pos.col),
        GridPosition(pos.row + 1, pos.col),
        GridPosition(pos.row, pos.col - 1),
        GridPosition(pos.row, pos.col + 1),
      ];
      for (final n in neighbors) {
        if (!board.isInBounds(n)) continue;
        final state = board.getCellState(n);
        if (state != null && state.hasPot && !damagedPots.contains(n)) {
          state.damagePot();
          potDamages.add(PotDamageInfo(n, state.potLayers));
          damagedPots.add(n);
        }
      }
    }

    // 3. Compact tiles into the active cells of each column.
    final falls = <TileFall>[];
    for (int c = 0; c < board.colCount; c++) {
      final activePositions = [
        for (int r = board.rowCount - 1; r >= 0; r--)
          if (board.isPlayable(GridPosition(r, c)) && !board.isBlocked(GridPosition(r, c))) GridPosition(r, c),
      ];
      final existingTiles = [
        for (final position in activePositions)
          if (board.get(position) case final tile?) (position, tile),
      ];

      for (final position in activePositions) {
        board.set(position, null);
      }
      for (int index = 0; index < existingTiles.length; index++) {
        final destination = activePositions[index];
        final (source, tile) = existingTiles[index];
        board.set(destination, tile);
        if (source != destination) {
          falls.add(TileFall(source, destination));
        }
      }
    }

    // 4. Spawn new tiles into every remaining active cell.
    final spawns = <TileSpawn>[];
    for (int c = 0; c < board.colCount; c++) {
      for (int r = board.rowCount - 1; r >= 0; r--) {
        final pos = GridPosition(r, c);
        if (board.isPlayable(pos) && !board.isBlocked(pos) && board.get(pos) == null) {
          // Generate a new random gem tile
          final gem = availableGems[rng.nextInt(availableGems.length)];
          _spawnCounter++;
          final newTile = TileModel(
            id: 'tile_spawn_${c}_${r}_$_spawnCounter',
            gemType: gem,
          );

          board.set(pos, newTile);
          spawns.add(TileSpawn(pos, newTile));
        }
      }
    }

    return CascadeStep(
      matches: matches,
      falls: falls,
      spawns: spawns,
      specialClears: specialClearsMap.entries
          .map((e) => SpecialClearInfo(e.key, e.value))
          .toList(),
      createdSpecials: createdSpecials,
      clearedMarks: clearedMarks,
      potDamages: potDamages,
      triggeredCombo: triggeredCombo,
      comboPosition: comboPos,
    );
  }

  static List<GridPosition> _getSpecialEffectPositions(
    BoardModel board,
    GridPosition pos,
    SpecialGemType type,
  ) {
    final positions = <GridPosition>[];
    switch (type) {
      case SpecialGemType.horizontalBlast:
        // Clear all tiles in the same row
        for (int c = 0; c < board.colCount; c++) {
          if (c != pos.col) {
            positions.add(GridPosition(pos.row, c));
          }
        }
        break;
      case SpecialGemType.verticalBlast:
        // Clear all tiles in the same column
        for (int r = 0; r < board.rowCount; r++) {
          if (r != pos.row) {
            positions.add(GridPosition(r, pos.col));
          }
        }
        break;
      case SpecialGemType.bomb:
        // Clear 3x3 area around the bomb
        for (int r = pos.row - 1; r <= pos.row + 1; r++) {
          for (int c = pos.col - 1; c <= pos.col + 1; c++) {
            final target = GridPosition(r, c);
            if (board.isInBounds(target) && target != pos) {
              positions.add(target);
            }
          }
        }
        break;
      case SpecialGemType.colorClear:
        // Clear all of a chosen color when triggered by a secondary blast/bomb
        final allGemsOnBoard = <GemType>{};
        for (int r = 0; r < board.rowCount; r++) {
          for (int c = 0; c < board.colCount; c++) {
            final t = board.get(GridPosition(r, c));
            if (t != null && t.specialType != SpecialGemType.colorClear) {
              allGemsOnBoard.add(t.gemType);
            }
          }
        }
        if (allGemsOnBoard.isNotEmpty) {
          final chosenColor = allGemsOnBoard.first;
          for (int r = 0; r < board.rowCount; r++) {
            for (int c = 0; c < board.colCount; c++) {
              final target = GridPosition(r, c);
              final t = board.get(target);
              if (t != null && t.gemType == chosenColor) {
                positions.add(target);
              }
            }
          }
        }
        break;
      case SpecialGemType.none:
        break;
    }
    return positions;
  }
}
