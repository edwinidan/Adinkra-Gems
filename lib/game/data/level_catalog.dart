import '../board/board_generator.dart';
import '../board/match_finder.dart';
import '../board/move_validator.dart';
import '../models/level_config.dart';

class LevelCatalog {
  final List<LevelConfig> levels;
  late final Map<int, LevelConfig> _byNumber;
  late final Map<String, LevelConfig> _byId;

  LevelCatalog(this.levels) {
    final errors = validate();
    if (errors.isNotEmpty) {
      throw StateError('Invalid level catalog:\n${errors.join('\n')}');
    }
    _byNumber = {for (final level in levels) level.levelNumber: level};
    _byId = {for (final level in levels) level.id: level};
  }

  int get length => levels.length;

  LevelConfig? findByNumber(int levelNumber) => _byNumber[levelNumber];

  LevelConfig? findById(String id) => _byId[id];

  LevelConfig requireByNumber(int levelNumber) {
    final level = findByNumber(levelNumber);
    if (level == null) {
      throw StateError('Level $levelNumber does not exist.');
    }
    return level;
  }

  List<String> validate() {
    final errors = <String>[];
    final ids = <String>{};
    final numbers = <int>{};

    for (final level in levels) {
      final levelErrors = level.validate();
      errors.addAll(levelErrors);
      if (!ids.add(level.id)) {
        errors.add('Duplicate level id: ${level.id}.');
      }
      if (!numbers.add(level.levelNumber)) {
        errors.add('Duplicate level number: ${level.levelNumber}.');
      }

      if (levelErrors.isEmpty) {
        try {
          final board = BoardGenerator.generate(
            level.availableGems,
            layout: level.boardLayout,
            initialTiles: level.initialTiles,
          );
          if (MatchFinder().hasAnyMatch(board)) {
            errors.add('Level ${level.id} starts with an unintended match.');
          }
          if (!MoveValidator().hasAnyValidMove(board)) {
            errors.add('Level ${level.id} starts without a legal move.');
          }
        } on StateError catch (error) {
          errors.add('Level ${level.id} is not playable: ${error.message}');
        }
      }
    }

    return errors;
  }
}
