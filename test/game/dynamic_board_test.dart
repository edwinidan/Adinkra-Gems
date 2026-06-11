import 'dart:math';

import 'package:adinkra_gems/game/board/board_generator.dart';
import 'package:adinkra_gems/game/board/cascade_resolver.dart';
import 'package:adinkra_gems/game/board/grid_position.dart';
import 'package:adinkra_gems/game/models/board_layout.dart';
import 'package:adinkra_gems/game/models/gem_type.dart';
import 'package:adinkra_gems/game/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates a non-8x8 board with inactive cells', () {
    const layout = BoardLayout(
      width: 6,
      height: 7,
      inactiveCells: [GridPosition(0, 0), GridPosition(6, 5)],
    );

    final board = BoardGenerator.generate(
      GemType.values,
      layout: layout,
      random: Random(42),
    );

    expect(board.colCount, 6);
    expect(board.rowCount, 7);
    expect(board.playableCellCount, 40);
    expect(board.get(const GridPosition(0, 0)), isNull);
    expect(board.get(const GridPosition(6, 5)), isNull);
  });

  test('gravity and spawning skip inactive cells', () {
    final board = BoardGenerator.generate(
      GemType.values,
      layout: const BoardLayout(
        width: 3,
        height: 5,
        inactiveCells: [GridPosition(2, 0)],
      ),
      random: Random(7),
    );

    board.set(
      const GridPosition(4, 0),
      TileModel(id: 'm1', gemType: GemType.yellowSankofa),
    );
    board.set(
      const GridPosition(4, 1),
      TileModel(id: 'm2', gemType: GemType.yellowSankofa),
    );
    board.set(
      const GridPosition(4, 2),
      TileModel(id: 'm3', gemType: GemType.yellowSankofa),
    );
    final aboveHole = board.get(const GridPosition(1, 0))!;

    final step = CascadeResolver.resolveStep(
      board,
      GemType.values,
      random: Random(8),
    );

    expect(step, isNotNull);
    expect(board.get(const GridPosition(2, 0)), isNull);
    expect(
      step!.falls.any(
        (fall) =>
            fall.from == const GridPosition(1, 0) &&
            fall.to == const GridPosition(3, 0),
      ),
      isTrue,
    );
    expect(board.get(const GridPosition(3, 0))?.id, aboveHole.id);
    expect(
      step.spawns.any((spawn) => spawn.to == const GridPosition(2, 0)),
      isFalse,
    );
  });
}
