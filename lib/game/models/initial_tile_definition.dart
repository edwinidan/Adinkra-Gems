import '../board/grid_position.dart';
import 'gem_type.dart';
import 'special_gem_type.dart';

class InitialTileDefinition {
  final GridPosition position;
  final GemType gemType;
  final SpecialGemType specialType;

  const InitialTileDefinition({
    required this.position,
    required this.gemType,
    this.specialType = SpecialGemType.none,
  });
}
