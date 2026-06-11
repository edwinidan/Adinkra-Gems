import '../board/grid_position.dart';
import '../models/board_layout.dart';
import '../models/cell_blocker_definition.dart';
import '../models/gem_type.dart';
import '../models/initial_tile_definition.dart';
import '../models/level_config.dart';
import '../models/level_difficulty.dart';
import '../models/level_objective.dart';
import '../models/special_gem_type.dart';
import '../models/star_thresholds.dart';

const _allGems = [
  GemType.redFuntumfunefuDenkyemfunefu,
  GemType.silverNsoromma,
  GemType.yellowSankofa,
  GemType.purpleAkofena,
  GemType.greenGyeNyame,
  GemType.blueDwennimmen,
];

const List<LevelConfig> draftLevels = [
  // Level 16 — Heavy collect under moves
  // Objective : Collect 25 green Gye Nyame tiles
  // Limit     : 26 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 16,
    name: 'Green Dominion',
    objectives: [CollectObjective(gemType: GemType.greenGyeNyame, count: 25)],
    moveLimit: 26,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 2200,
      twoStar: 3400,
      threeStar: 5000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 17 — Score + two collects
  // Objective : Reach 4,500 points AND collect 15 yellow AND 15 blue
  // Limit     : 32 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 17,
    name: 'Wisdom and Strength',
    objectives: [
      ScoreObjective(4500),
      CollectObjective(gemType: GemType.yellowSankofa, count: 15),
      CollectObjective(gemType: GemType.blueDwennimmen, count: 15),
    ],
    moveLimit: 32,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 4500,
      twoStar: 6000,
      threeStar: 8000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 18 — Timed with collection
  // Objective : Collect 20 red tiles in 65 seconds
  // Limit     : 65 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 18,
    name: 'Funtum Fire',
    objectives: [
      CollectObjective(
        gemType: GemType.redFuntumfunefuDenkyemfunefu,
        count: 20,
      ),
    ],
    timeLimitSeconds: 65,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 2000,
      twoStar: 3500,
      threeStar: 5500,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 19 — Ultra score, tight moves
  // Objective : Reach 7,500 points
  // Limit     : 20 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 19,
    name: 'The Golden Summit',
    objectives: [ScoreObjective(7500)],
    moveLimit: 20,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 7500,
      twoStar: 9500,
      threeStar: 12000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 20 — Big mixed challenge
  // Objective : Reach 6,000 points AND collect 12 silver AND 12 purple
  // Limit     : 35 moves AND 100 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 20,
    name: 'The Great Council',
    objectives: [
      ScoreObjective(6000),
      CollectObjective(gemType: GemType.silverNsoromma, count: 12),
      CollectObjective(gemType: GemType.purpleAkofena, count: 12),
    ],
    moveLimit: 35,
    timeLimitSeconds: 100,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 6000,
      twoStar: 8500,
      threeStar: 12000,
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAPTER 3 — THE MASTER'S TEST (Levels 21–30)
  // ═══════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────
  // Level 21 — Sprint scoring
  // Objective : Reach 7,000 points
  // Limit     : 50 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 21,
    name: 'Lightning Weave',
    objectives: [ScoreObjective(7000)],
    timeLimitSeconds: 50,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 7000,
      twoStar: 9000,
      threeStar: 12000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 22 — Extreme collect challenge
  // Objective : Collect 30 blue Dwennimmen tiles
  // Limit     : 30 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 22,
    name: 'The Deep Blue',
    objectives: [CollectObjective(gemType: GemType.blueDwennimmen, count: 30)],
    moveLimit: 30,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 3000,
      twoStar: 5000,
      threeStar: 7500,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 23 — All six types, timed
  // Objective : Collect 8 of every gem type (48 total)
  // Limit     : 90 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 23,
    name: 'Adinkra Unity',
    objectives: [
      CollectObjective(gemType: GemType.redFuntumfunefuDenkyemfunefu, count: 8),
      CollectObjective(gemType: GemType.silverNsoromma, count: 8),
      CollectObjective(gemType: GemType.yellowSankofa, count: 8),
      CollectObjective(gemType: GemType.purpleAkofena, count: 8),
      CollectObjective(gemType: GemType.greenGyeNyame, count: 8),
      CollectObjective(gemType: GemType.blueDwennimmen, count: 8),
    ],
    timeLimitSeconds: 90,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 5000,
      twoStar: 8000,
      threeStar: 12000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 24 — Elite scoring, very few moves
  // Objective : Reach 8,000 points
  // Limit     : 15 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 24,
    name: 'Precision Strike',
    objectives: [ScoreObjective(8000)],
    moveLimit: 15,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 8000,
      twoStar: 10500,
      threeStar: 14000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 25 — Score + multi collect + timer
  // Objective : Reach 5,000 AND collect 15 green AND 15 red
  // Limit     : 80 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 25,
    name: 'Earth and Blood',
    objectives: [
      ScoreObjective(5000),
      CollectObjective(gemType: GemType.greenGyeNyame, count: 15),
      CollectObjective(
        gemType: GemType.redFuntumfunefuDenkyemfunefu,
        count: 15,
      ),
    ],
    timeLimitSeconds: 80,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 5000,
      twoStar: 8000,
      threeStar: 12000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 26 — Brutal move constraint
  // Objective : Reach 6,500 points
  // Limit     : 16 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 26,
    name: "Warrior's Edge",
    objectives: [ScoreObjective(6500)],
    moveLimit: 16,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 6500,
      twoStar: 9000,
      threeStar: 12500,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 27 — Collect marathon under moves
  // Objective : Collect 20 silver AND 20 purple
  // Limit     : 35 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 27,
    name: 'Silver and Royalty',
    objectives: [
      CollectObjective(gemType: GemType.silverNsoromma, count: 20),
      CollectObjective(gemType: GemType.purpleAkofena, count: 20),
    ],
    moveLimit: 35,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 4000,
      twoStar: 6500,
      threeStar: 9500,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 28 — Full pressure: score + collect + timer + moves
  // Objective : Reach 8,000 AND collect 15 yellow tiles
  // Limit     : 28 moves AND 85 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 28,
    name: 'The Ancient Oath',
    objectives: [
      ScoreObjective(8000),
      CollectObjective(gemType: GemType.yellowSankofa, count: 15),
    ],
    moveLimit: 28,
    timeLimitSeconds: 85,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 8000,
      twoStar: 11000,
      threeStar: 15000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 29 — Near-impossible score blitz
  // Objective : Reach 10,000 points
  // Limit     : 45 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 29,
    name: "Nyame's Fury",
    objectives: [ScoreObjective(10000)],
    timeLimitSeconds: 45,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 10000,
      twoStar: 13000,
      threeStar: 17000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 30 — THE FINAL TRIAL
  // Objective : Reach 12,000 AND collect 15 of EVERY gem type (90 total)
  // Limit     : 40 moves AND 120 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 30,
    name: 'The Eternal Symbol',
    objectives: [
      ScoreObjective(12000),
      CollectObjective(
        gemType: GemType.redFuntumfunefuDenkyemfunefu,
        count: 15,
      ),
      CollectObjective(gemType: GemType.silverNsoromma, count: 15),
      CollectObjective(gemType: GemType.yellowSankofa, count: 15),
      CollectObjective(gemType: GemType.purpleAkofena, count: 15),
      CollectObjective(gemType: GemType.greenGyeNyame, count: 15),
      CollectObjective(gemType: GemType.blueDwennimmen, count: 15),
    ],
    moveLimit: 40,
    timeLimitSeconds: 120,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 12000,
      twoStar: 16000,
      threeStar: 22000,
    ),
  ),
  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE 3 TEST LEVELS (Levels 31–33)
  // ═══════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────
  // Level 31 — Clear Marks Challenge
  // Objective : Clear 12 marks
  // Limit     : 25 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 31,
    name: 'Marked For Greatness',
    objectives: [ClearMarkObjective()],
    moveLimit: 25,
    availableGems: _allGems,
    clearMarkCells: [
      GridPosition(2, 2), GridPosition(2, 3), GridPosition(2, 4), GridPosition(2, 5),
      GridPosition(4, 2), GridPosition(4, 3), GridPosition(4, 4), GridPosition(4, 5),
      GridPosition(6, 2), GridPosition(6, 3), GridPosition(6, 4), GridPosition(6, 5),
    ],
    starThresholds: StarThresholds(
      oneStar: 2000,
      twoStar: 3000,
      threeStar: 4000,
    ),
  ),
  
  // ─────────────────────────────────────────────────────────────────────────
  // Level 32 — Clay Pot Blockers
  // Objective : Destroy 8 pots
  // Limit     : 30 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 32,
    name: 'Shattered Earth',
    objectives: [ClearBlockerObjective()],
    moveLimit: 30,
    availableGems: _allGems,
    clayPotCells: [
      CellBlockerDefinition(position: GridPosition(3, 3), layers: 2),
      CellBlockerDefinition(position: GridPosition(3, 4), layers: 2),
      CellBlockerDefinition(position: GridPosition(4, 3), layers: 2),
      CellBlockerDefinition(position: GridPosition(4, 4), layers: 2),
      CellBlockerDefinition(position: GridPosition(1, 1), layers: 1),
      CellBlockerDefinition(position: GridPosition(1, 6), layers: 1),
      CellBlockerDefinition(position: GridPosition(6, 1), layers: 1),
      CellBlockerDefinition(position: GridPosition(6, 6), layers: 1),
    ],
    starThresholds: StarThresholds(
      oneStar: 2000,
      twoStar: 3500,
      threeStar: 5000,
    ),
  ),
  
  // ─────────────────────────────────────────────────────────────────────────
  // Level 33 — Mixed Marks, Pots, and Collection
  // Objective : Clear 6 marks, Destroy 4 pots, Collect 15 Sankofa
  // Limit     : 35 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 33,
    name: 'The Artisan\'s Workshop',
    objectives: [
      ClearMarkObjective(),
      ClearBlockerObjective(),
      CollectObjective(gemType: GemType.yellowSankofa, count: 15),
    ],
    moveLimit: 35,
    availableGems: _allGems,
    clearMarkCells: [
      GridPosition(7, 2), GridPosition(7, 3), GridPosition(7, 4), GridPosition(7, 5),
      GridPosition(6, 3), GridPosition(6, 4),
    ],
    clayPotCells: [
      CellBlockerDefinition(position: GridPosition(5, 2), layers: 2),
      CellBlockerDefinition(position: GridPosition(5, 5), layers: 2),
      CellBlockerDefinition(position: GridPosition(4, 3), layers: 1),
      CellBlockerDefinition(position: GridPosition(4, 4), layers: 1),
    ],
    starThresholds: StarThresholds(
      oneStar: 3000,
      twoStar: 5000,
      threeStar: 7500,
    ),
  ),
  
  // ─────────────────────────────────────────────────────────────────────────
  // Level 34 — Special Combo Testing Playground
  // Objective : Score 10,000 points
  // Limit     : 25 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 34,
    name: 'Combo Training Ground',
    objectives: [
      ScoreObjective(10000),
    ],
    moveLimit: 25,
    availableGems: _allGems,
    initialTiles: [
      // Line + Line setup (swap 2,2 with 2,3)
      InitialTileDefinition(position: GridPosition(2, 2), gemType: GemType.redFuntumfunefuDenkyemfunefu, specialType: SpecialGemType.horizontalBlast),
      InitialTileDefinition(position: GridPosition(2, 3), gemType: GemType.silverNsoromma, specialType: SpecialGemType.verticalBlast),
      
      // Line + Burst setup (swap 5,2 with 5,3)
      InitialTileDefinition(position: GridPosition(5, 2), gemType: GemType.yellowSankofa, specialType: SpecialGemType.horizontalBlast),
      InitialTileDefinition(position: GridPosition(5, 3), gemType: GemType.purpleAkofena, specialType: SpecialGemType.bomb),

      // Burst + Burst setup (swap 2,5 with 2,6)
      InitialTileDefinition(position: GridPosition(2, 5), gemType: GemType.greenGyeNyame, specialType: SpecialGemType.bomb),
      InitialTileDefinition(position: GridPosition(2, 6), gemType: GemType.blueDwennimmen, specialType: SpecialGemType.bomb),
      
      // Unity + Normal setup (swap 5,5 with 5,6)
      InitialTileDefinition(position: GridPosition(5, 5), gemType: GemType.redFuntumfunefuDenkyemfunefu, specialType: SpecialGemType.colorClear),
      InitialTileDefinition(position: GridPosition(5, 6), gemType: GemType.silverNsoromma, specialType: SpecialGemType.none),
    ],
    starThresholds: StarThresholds(
      oneStar: 5000,
      twoStar: 10000,
      threeStar: 15000,
];
