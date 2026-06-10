import 'dart:math';

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
  String toString() => 'SpecialClearInfo(position: $position, tile: ${tile.gemType})';
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

  const CascadeStep({
    required this.matches,
    required this.falls,
    required this.spawns,
    this.specialClears = const [],
    this.createdSpecials = const {},
  });

  bool get isEmpty =>
      matches.isEmpty && falls.isEmpty && spawns.isEmpty && specialClears.isEmpty;
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

    // Check if colorClear swap is active
    bool colorClearTriggered = false;
    GridPosition? colorClearPos;
    GemType? targetColor;

    if (swapA != null && swapB != null) {
      final tileA = board.get(swapA);
      final tileB = board.get(swapB);
      if (tileA != null && tileB != null) {
        if (tileA.specialType == SpecialGemType.colorClear) {
          colorClearTriggered = true;
          colorClearPos = swapA;
          targetColor = tileB.gemType;
        } else if (tileB.specialType == SpecialGemType.colorClear) {
          colorClearTriggered = true;
          colorClearPos = swapB;
          targetColor = tileA.gemType;
        }
      }
    }

    List<MatchGroup> matches = [];

    if (colorClearTriggered && targetColor != null) {
      toClear.add(colorClearPos!);
      processingQueue.add(colorClearPos);

      for (int r = 0; r < BoardModel.rows; r++) {
        for (int c = 0; c < BoardModel.cols; c++) {
          final pos = GridPosition(r, c);
          final tile = board.get(pos);
          if (tile != null && tile.gemType == targetColor) {
            toClear.add(pos);
            processingQueue.add(pos);
            specialClearsMap[pos] = tile;
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

        final effectPositions = _getSpecialEffectPositions(board, pos, tile.specialType);
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
      if (group.specialCreated != SpecialGemType.none && group.specialSpawnPosition != null) {
        createdSpecials[group.specialSpawnPosition!] = group.specialCreated;
        createdSpecialGems[group.specialSpawnPosition!] = group.gemType;
      }
    }

    // Mutate board model: clear cells except where special tiles are created
    for (final pos in toClear) {
      if (createdSpecials.containsKey(pos)) {
        // Upgrade this tile to special instead of clearing
        final tile = board.get(pos);
        if (tile != null) {
          tile.specialType = createdSpecials[pos]!;
          tile.isMatched = false;
        } else {
          board.set(pos, TileModel(
            id: 'special_${pos.row}_${pos.col}_${DateTime.now().microsecondsSinceEpoch}',
            gemType: createdSpecialGems[pos]!,
            specialType: createdSpecials[pos]!,
          ));
        }
      } else {
        board.set(pos, null);
      }
    }

    // 3. Drop existing tiles vertically to fill gaps
    final falls = <TileFall>[];
    for (int c = 0; c < BoardModel.cols; c++) {
      // Traverse column from bottom (row 7) to top (row 0)
      for (int r = BoardModel.rows - 1; r >= 0; r--) {
        if (board.get(GridPosition(r, c)) == null) {
          // Find the first non-null tile above this empty space
          int scanRow = r - 1;
          while (scanRow >= 0 && board.get(GridPosition(scanRow, c)) == null) {
            scanRow--;
          }

          if (scanRow >= 0) {
            // Found a tile! Move it logically down in the grid
            final fallingTile = board.get(GridPosition(scanRow, c))!;
            board.set(GridPosition(r, c), fallingTile);
            board.set(GridPosition(scanRow, c), null);

            falls.add(TileFall(GridPosition(scanRow, c), GridPosition(r, c)));
          }
        }
      }
    }

    // 4. Spawn new tiles for the empty cells at the top of each column
    final spawns = <TileSpawn>[];
    for (int c = 0; c < BoardModel.cols; c++) {
      for (int r = BoardModel.rows - 1; r >= 0; r--) {
        final pos = GridPosition(r, c);
        if (board.get(pos) == null) {
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
      specialClears: specialClearsMap.entries.map((e) => SpecialClearInfo(e.key, e.value)).toList(),
      createdSpecials: createdSpecials,
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
        for (int c = 0; c < BoardModel.cols; c++) {
          if (c != pos.col) {
            positions.add(GridPosition(pos.row, c));
          }
        }
        break;
      case SpecialGemType.verticalBlast:
        // Clear all tiles in the same column
        for (int r = 0; r < BoardModel.rows; r++) {
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
        for (int r = 0; r < BoardModel.rows; r++) {
          for (int c = 0; c < BoardModel.cols; c++) {
            final t = board.get(GridPosition(r, c));
            if (t != null && t.specialType != SpecialGemType.colorClear) {
              allGemsOnBoard.add(t.gemType);
            }
          }
        }
        if (allGemsOnBoard.isNotEmpty) {
          final chosenColor = allGemsOnBoard.first;
          for (int r = 0; r < BoardModel.rows; r++) {
            for (int c = 0; c < BoardModel.cols; c++) {
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
