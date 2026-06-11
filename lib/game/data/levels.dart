import '../models/gem_type.dart';
import '../models/level_config.dart';
import '../models/level_objective.dart';
import '../models/star_thresholds.dart';

/// All 6 gem types — used as the default available set for every level.
const _allGems = [
  GemType.redFuntumfunefuDenkyemfunefu,
  GemType.silverNsoromma,
  GemType.yellowSankofa,
  GemType.purpleAkofena,
  GemType.greenGyeNyame,
  GemType.blueDwennimmen,
];

/// The static list of all 30 level configurations.
///
/// Levels are 1-indexed to match the UI. Access by:
///   `allLevels[levelNumber - 1]`
const List<LevelConfig> allLevels = [
  // ─────────────────────────────────────────────────────────────────────────
  // Level 1 — Teach basic matching
  // Objective : Reach 1,000 points
  // Limit     : 20 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 1,
    name: 'First Light',
    objectives: [ScoreObjective(1000)],
    moveLimit: 20,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 1000,
      twoStar: 1500,
      threeStar: 2000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 2 — Introduce collect objective
  // Objective : Collect 12 yellow Sankofa tiles
  // Limit     : 22 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 2,
    name: 'Sankofa Path',
    objectives: [
      CollectObjective(
        gemType: GemType.yellowSankofa,
        count: 12,
      ),
    ],
    moveLimit: 22,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 800,
      twoStar: 1200,
      threeStar: 1600,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 3 — Introduce cascades and higher scoring
  // Objective : Reach 1,800 points
  // Limit     : 20 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 3,
    name: 'Chain Reaction',
    objectives: [ScoreObjective(1800)],
    moveLimit: 20,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 1800,
      twoStar: 2400,
      threeStar: 3000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 4 — Focused collection
  // Objective : Collect 15 blue Dwennimmen tiles
  // Limit     : 24 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 4,
    name: "Dwennimmen's Trial",
    objectives: [
      CollectObjective(
        gemType: GemType.blueDwennimmen,
        count: 15,
      ),
    ],
    moveLimit: 24,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 1000,
      twoStar: 1500,
      threeStar: 2000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 5 — Introduce timer (no move limit)
  // Objective : Reach 2,500 points
  // Limit     : 60 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 5,
    name: 'Race Against Time',
    objectives: [ScoreObjective(2500)],
    timeLimitSeconds: 60,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 2500,
      twoStar: 3200,
      threeStar: 4000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 6 — Multi-collect (two gem types)
  // Objective : Collect 12 red Funtumfunefu AND 12 green Gye Nyame tiles
  // Limit     : 25 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 6,
    name: 'Dual Harvest',
    objectives: [
      CollectObjective(
        gemType: GemType.redFuntumfunefuDenkyemfunefu,
        count: 12,
      ),
      CollectObjective(
        gemType: GemType.greenGyeNyame,
        count: 12,
      ),
    ],
    moveLimit: 25,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 1200,
      twoStar: 1800,
      threeStar: 2400,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 7 — Encourage special tile creation
  // Objective : Reach 3,000 points
  // Limit     : 22 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 7,
    name: 'Power Surge',
    objectives: [ScoreObjective(3000)],
    moveLimit: 22,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 3000,
      twoStar: 3800,
      threeStar: 4800,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 8 — Timed collection
  // Objective : Collect 20 purple Akofena tiles
  // Limit     : 75 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 8,
    name: "Akofena's Wrath",
    objectives: [
      CollectObjective(
        gemType: GemType.purpleAkofena,
        count: 20,
      ),
    ],
    timeLimitSeconds: 75,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 1500,
      twoStar: 2200,
      threeStar: 3000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 9 — Combined score + collect objective
  // Objective : Reach 3,500 points AND collect 15 silver Nsoromma tiles
  // Limit     : 28 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 9,
    name: 'Stars and Glory',
    objectives: [
      ScoreObjective(3500),
      CollectObjective(
        gemType: GemType.silverNsoromma,
        count: 15,
      ),
    ],
    moveLimit: 28,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 3500,
      twoStar: 4500,
      threeStar: 5500,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 10 — Mini challenge: both moves AND a timer
  // Objective : Reach 5,000 points
  // Limit     : 30 moves AND 90 seconds (both apply simultaneously)
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 10,
    name: 'The Adinkra Trial',
    objectives: [ScoreObjective(5000)],
    moveLimit: 30,
    timeLimitSeconds: 90,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 5000,
      twoStar: 6500,
      threeStar: 8000,
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAPTER 2 — THE DEEPER PATH (Levels 11–20)
  // ═══════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────
  // Level 11 — Higher score target, tighter moves
  // Objective : Reach 4,000 points
  // Limit     : 18 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 11,
    name: 'Iron Resolve',
    objectives: [ScoreObjective(4000)],
    moveLimit: 18,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 4000,
      twoStar: 5200,
      threeStar: 6500,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 12 — Collect two gem types under time pressure
  // Objective : Collect 14 yellow Sankofa AND 14 blue Dwennimmen
  // Limit     : 70 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 12,
    name: 'Twin Symbols',
    objectives: [
      CollectObjective(gemType: GemType.yellowSankofa, count: 14),
      CollectObjective(gemType: GemType.blueDwennimmen, count: 14),
    ],
    timeLimitSeconds: 70,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 2000,
      twoStar: 3000,
      threeStar: 4200,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 13 — Big score, limited moves
  // Objective : Reach 5,500 points
  // Limit     : 22 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 13,
    name: 'Gye Nyame Rising',
    objectives: [ScoreObjective(5500)],
    moveLimit: 22,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 5500,
      twoStar: 7000,
      threeStar: 9000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 14 — Collect three gem types
  // Objective : Collect 10 red, 10 purple, 10 silver tiles
  // Limit     : 30 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 14,
    name: 'Sacred Trinity',
    objectives: [
      CollectObjective(gemType: GemType.redFuntumfunefuDenkyemfunefu, count: 10),
      CollectObjective(gemType: GemType.purpleAkofena, count: 10),
      CollectObjective(gemType: GemType.silverNsoromma, count: 10),
    ],
    moveLimit: 30,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 2500,
      twoStar: 3800,
      threeStar: 5200,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 15 — Timed blitz
  // Objective : Reach 6,000 points
  // Limit     : 55 seconds
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 15,
    name: 'Blitz of Gold',
    objectives: [ScoreObjective(6000)],
    timeLimitSeconds: 55,
    availableGems: _allGems,
    starThresholds: StarThresholds(
      oneStar: 6000,
      twoStar: 7800,
      threeStar: 10000,
    ),
  ),

  // ─────────────────────────────────────────────────────────────────────────
  // Level 16 — Heavy collect under moves
  // Objective : Collect 25 green Gye Nyame tiles
  // Limit     : 26 moves
  // ─────────────────────────────────────────────────────────────────────────
  LevelConfig(
    levelNumber: 16,
    name: 'Green Dominion',
    objectives: [
      CollectObjective(gemType: GemType.greenGyeNyame, count: 25),
    ],
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
      CollectObjective(gemType: GemType.redFuntumfunefuDenkyemfunefu, count: 20),
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
    objectives: [
      CollectObjective(gemType: GemType.blueDwennimmen, count: 30),
    ],
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
      CollectObjective(gemType: GemType.redFuntumfunefuDenkyemfunefu, count: 15),
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
      CollectObjective(gemType: GemType.redFuntumfunefuDenkyemfunefu, count: 15),
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
];
