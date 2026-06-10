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

/// The static list of all 10 level configurations.
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
];
