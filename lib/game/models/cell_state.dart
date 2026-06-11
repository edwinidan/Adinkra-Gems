import 'dart:core';

enum CellTerrain { none, clearMark, clayPot }

/// Represents the persistent terrain state of a cell on the board.
/// This state survives across swaps, falls, and reshuffles.
class CellState {
  CellTerrain terrain;
  
  /// Number of layers for a clay pot (usually 1 or 2). 0 means destroyed or none.
  int potLayers;
  
  /// True if this cell had a clear mark and it was successfully cleared.
  bool markCleared;

  CellState({
    this.terrain = CellTerrain.none,
    this.potLayers = 0,
    this.markCleared = false,
  });

  /// True if the cell has an uncleared mark.
  bool get hasMark => terrain == CellTerrain.clearMark && !markCleared;
  
  /// True if the cell has an active clay pot blocking it.
  bool get hasPot => terrain == CellTerrain.clayPot && potLayers > 0;
  
  /// General blocker check (currently only pots block, but extensible later).
  bool get isBlocker => hasPot;

  /// Damages the pot, removing one layer.
  void damagePot() {
    if (hasPot) potLayers--;
  }

  /// Marks this cell's mark as cleared.
  void clearMark() {
    if (terrain == CellTerrain.clearMark) markCleared = true;
  }

  /// Returns a deep copy of this state.
  CellState copyWith({
    CellTerrain? terrain,
    int? potLayers,
    bool? markCleared,
  }) {
    return CellState(
      terrain: terrain ?? this.terrain,
      potLayers: potLayers ?? this.potLayers,
      markCleared: markCleared ?? this.markCleared,
    );
  }

  @override
  String toString() {
    return 'CellState(terrain: $terrain, layers: $potLayers, markCleared: $markCleared)';
  }
}
