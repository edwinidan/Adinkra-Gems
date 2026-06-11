import '../board/grid_position.dart';

/// Defines a blocker (like a Clay Pot) to be placed on the board during generation.
class CellBlockerDefinition {
  final GridPosition position;
  final int layers;

  const CellBlockerDefinition({
    required this.position,
    this.layers = 1,
  });
}
