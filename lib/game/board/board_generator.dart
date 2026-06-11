import 'dart:math';

import '../models/board_layout.dart';
import '../models/gem_type.dart';
import '../models/initial_tile_definition.dart';
import '../models/cell_blocker_definition.dart';
import '../models/cell_state.dart';
import '../models/tile_model.dart';
import 'board_model.dart';
import 'grid_position.dart';
import 'match_finder.dart';
import 'move_validator.dart';

/// Generates a playable board while respecting inactive cells and fixed tiles.
class BoardGenerator {
  static int _idCounter = 0;

  static BoardModel generate(
    List<GemType> availableGems, {
    BoardLayout layout = const BoardLayout(),
    List<InitialTileDefinition> initialTiles = const [],
    List<GridPosition> clearMarkCells = const [],
    List<CellBlockerDefinition> clayPotCells = const [],
    Random? random,
  }) {
    if (availableGems.isEmpty) {
      throw ArgumentError.value(
        availableGems,
        'availableGems',
        'At least one gem type is required.',
      );
    }

    final rng = random ?? Random();
    final finder = MatchFinder();
    final validator = MoveValidator(matchFinder: finder);

    for (int attempt = 0; attempt < 100; attempt++) {
      final board = _fillNoMatch(
        availableGems,
        layout,
        initialTiles,
        clearMarkCells,
        clayPotCells,
        rng,
      );

      if (!finder.hasAnyMatch(board) && validator.hasAnyValidMove(board)) {
        return board;
      }
    }

    throw StateError(
      'Could not generate a playable ${layout.width}x${layout.height} board '
      'for the supplied layout and initial tiles.',
    );
  }

  static BoardModel _fillNoMatch(
    List<GemType> gems,
    BoardLayout layout,
    List<InitialTileDefinition> initialTiles,
    List<GridPosition> clearMarkCells,
    List<CellBlockerDefinition> clayPotCells,
    Random rng,
  ) {
    final board = BoardModel(
      rowCount: layout.height,
      colCount: layout.width,
      inactiveCells: layout.inactiveCells,
    );
    final fixedTiles = {for (final tile in initialTiles) tile.position: tile};
    final marks = clearMarkCells.toSet();
    final pots = {for (final pot in clayPotCells) pot.position: pot.layers};

    for (int r = 0; r < board.rowCount; r++) {
      for (int c = 0; c < board.colCount; c++) {
        final pos = GridPosition(r, c);
        if (!board.isPlayable(pos)) continue;

        // Apply cell state
        if (pots.containsKey(pos)) {
          board.setCellState(pos, CellState(
            terrain: CellTerrain.clayPot,
            potLayers: pots[pos]!,
          ));
          // Clay pots occupy the cell, so no gem is placed
          continue;
        } else if (marks.contains(pos)) {
          board.setCellState(pos, CellState(
            terrain: CellTerrain.clearMark,
          ));
        }

        final fixed = fixedTiles[pos];
        if (fixed != null) {
          board.set(
            pos,
            TileModel(
              id: 'initial_${r}_${c}_${_nextCounter()}',
              gemType: fixed.gemType,
              specialType: fixed.specialType,
            ),
          );
          continue;
        }

        final forbidden = _forbiddenAt(board, pos);
        final candidates = gems
            .where((gem) => !forbidden.contains(gem))
            .toList();
        final pool = candidates.isEmpty ? gems : candidates;
        board.set(
          pos,
          TileModel(
            id: 'tile_${r}_${c}_${_nextCounter()}',
            gemType: pool[rng.nextInt(pool.length)],
          ),
        );
      }
    }

    return board;
  }

  static Set<GemType> _forbiddenAt(BoardModel board, GridPosition position) {
    final forbidden = <GemType>{};

    final left1 = board.get(GridPosition(position.row, position.col - 1));
    final left2 = board.get(GridPosition(position.row, position.col - 2));
    if (left1 != null && left2 != null && left1.gemType == left2.gemType) {
      forbidden.add(left1.gemType);
    }

    final up1 = board.get(GridPosition(position.row - 1, position.col));
    final up2 = board.get(GridPosition(position.row - 2, position.col));
    if (up1 != null && up2 != null && up1.gemType == up2.gemType) {
      forbidden.add(up1.gemType);
    }

    return forbidden;
  }

  static int _nextCounter() => ++_idCounter;
}
