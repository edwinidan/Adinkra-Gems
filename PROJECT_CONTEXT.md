# Adinkra Gems — Project Context (AI Handoff)

This file is a complete reference for an AI coding agent to resume development on Adinkra Gems. Read this first before making any changes.

---

## 0. What Is This Project?

Adinkra Gems is a **Flutter + Flame match-3 puzzle game** themed around Ghanaian Adinkra symbols. It plays like Candy Crush: swap adjacent gem tiles on a grid to form matches of 3+, triggering cascades, special tiles, and particle effects. The MVP is feature-complete with 30 levels, 4 objective types, 4 special tile types, combos, blockers, and full UI flow.

- **Target platform:** Android (portrait-only), iOS-ready
- **Current state:** MVP complete, 15 fully-defined levels + 15 scaffold
- **Version:** 1.0.0+1

---

## 1. How to Run

```bash
cd "/Users/edwinrichardidan/projects/GitHub/Adinkra Gems"
flutter pub get
flutter run          # requires a connected device/emulator
flutter analyze      # static analysis
flutter test         # 13 test files, all should pass
```

Do **not** run `flutter clean` unless there's a build cache issue — it's unnecessary.

---

## 2. Tech Stack & Key Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter: sdk           # App shell, screens, navigation
  flame: ^1.37.0         # Game engine — board, tiles, input, effects, animations
  shared_preferences: ^2.5.5  # Local persistence (progress, settings, balancing)
  audioplayers: ^6.7.1   # SFX playback
  firebase_core: ^4.10.0 # Added but NOT wired to a Firebase project
  firebase_crashlytics: ^5.2.3  # Added but NOT wired
```

---

## 3. Architecture Rules (MUST FOLLOW)

### 3.1 Three-Layer Separation

```
Pure Dart Logic    → BoardModel, MatchFinder, MoveValidator, CascadeResolver, LevelController
Flame Rendering    → AdinkraGemsGame, BoardComponent, TileComponent, EffectsManager
Flutter UI/Shell   → Screens, HUD, Dialogs, Navigation, Services
```

**CRITICAL RULES:**
- **Pure Dart logic must never import Flame or Flutter.** It operates only on data models.
- **Flame components handle rendering, input, and animation coordination.** They call pure logic, never duplicate it.
- **Flutter manages screens, overlays, navigation, and service initialization.**
- Board logic goes in `lib/game/board/`, NOT inside Flame components.
- Scoring, objectives, and level state go in `lib/game/systems/level_controller.dart` — a `ChangeNotifier` that bridges Flame ↔ Flutter.

### 3.2 How They Communicate

```
User Input → BoardComponent (Flame) → MoveValidator (pure) → boardModel.swap()
  → CascadeResolver.resolveStep() (pure, mutates boardModel)
  → BoardComponent animates CascadeStep results
  → LevelController.recordMatch() / recordSpecialClear() (ChangeNotifier)
  → GameHUD (Flutter) rebuilds via ListenableBuilder
  → LevelController._evaluateStableBoard() → GameScreen shows GameOverDialog
```

### 3.3 Do Not Mix These

| Pattern | Where |
|---|---|
| Rendering logic | Flame components only |
| Match/swap/cascade math | `lib/game/board/` |
| Win/lose/scoring rules | `LevelController` |
| Asset path mapping | `GemAssets` |
| Persistent storage | `services/*.dart` |
| Screen layout/styling | `screens/*.dart` |

---

## 4. File Map — What Lives Where

```
lib/
  main.dart                              # Portrait lock, immersive mode, SettingsService.init()
  app/app.dart                           # MaterialApp, theme, route table
  app/routes.dart                        # 5 named routes: /, /home, /level-select, /game, /settings
  app/theme.dart                         # AdinkraTheme: warmGold, cream, cocoa, terracotta, sage
  app/woven_background.dart              # DecoratedBox with branded bg + cream overlay

  screens/splash/splash_screen.dart      # 2s timer → navigate to /home
  screens/home/home_screen.dart          # PLAY → /level-select, SETTINGS → /settings, ABOUT → bottom sheet
  screens/level_select/
    level_select_screen.dart             # GridView of LevelNodeWidgets, loads progress from ProgressService
    level_node_widget.dart               # Single level card: number, stars, score, locked state
  screens/game/
    game_screen.dart                     # Hosts Flame GameWidget + HUD, init LevelController, handle game-over
    game_hud.dart                        # Top bar: level, score, stars, objectives, moves/timer, pause
    game_over_dialog.dart                # Win/lose dialog with stars, retry/next/map
  screens/settings/settings_screen.dart  # Sound toggle, music toggle, tile version v1/v2

  game/adinkra_gems_game.dart            # FlameGame: sprite preloading, BoardGenerator call, timer tick
  game/board/
    board_model.dart                     # 2D grid — get/set/swap/clone, isInBounds, isPlayable, isBlocked, cellState access
    board_generator.dart                 # _fillNoMatch (avoids 3-in-a-row), 100-attempt retry
    grid_position.dart                   # (int row, int col) with isAdjacentTo()
    match_finder.dart                    # findMatches(), _scanHorizontal, _scanVertical, L/T intersection, match-4/5 classification
    move_validator.dart                  # isAdjacent, isValidSwap (clones board, simulates), hasAnyValidMove
    cascade_resolver.dart                # resolveStep(): detect combos → collect matches → expand special chains → apply gravity → spawn → return CascadeStep
    reshuffle_service.dart               # reshuffle(): shuffle tiles in-place, 200-attempt retry
  game/components/
    board_component.dart                 # ~970 lines: input handling (tap/drag), swapTiles(), _runCascadeCycle(), _animateFallsAndSpawns(), _triggerReshuffle(), render (cells, marks, clay pots)
    tile_component.dart                  # SpriteComponent: selection pulse, pop animation, special overlays
    gem_particle_component.dart          # Colored particle emitter
    score_popup_component.dart           # Floating "+N" text
    special_effect_component.dart        # Beam, shockwave, pulse effects for special activations
  game/models/
    gem_type.dart                        # 6-value enum
    special_gem_type.dart                # none/horizontalBlast/verticalBlast/colorClear/bomb
    tile_model.dart                      # id, gemType, specialType, isMatched, isFalling
    level_config.dart                    # Full level definition — see section 6
    level_objective.dart                 # Sealed class: ScoreObjective, CollectObjective, ClearMarkObjective, ClearBlockerObjective
    star_thresholds.dart                 # oneStar/twoStar/threeStar, starsFor(score)
    match_group.dart                     # positions, gemType, specialCreated, specialSpawnPosition
    board_layout.dart                    # width/height/inactiveCells
    cell_state.dart                      # terrain (none/clearMark/clayPot), potLayers, markCleared
    cell_blocker_definition.dart         # position + layers for clay pot placement
    initial_tile_definition.dart         # position + gemType + specialType for pre-placed tiles
    level_difficulty.dart                # tutorial/easy/normal/hard enum
    combo_type.dart                      # lineLine/lineBurst/burstBurst/unityNormal enum
  game/systems/
    level_controller.dart                # ChangeNotifier: score, moves, timer, collected gems, marks/pots, win/lose evaluation, balancing reporting
    effects_manager.dart                 # Static methods: spawnParticleBurst, spawnScorePopup, spawnHorizontalBlast, spawnVerticalBlast, spawnBombBlast, spawnColorClearPulse, triggerBoardShake
  game/data/
    levels.dart                          # allLevels list (30 LevelConfigs), levelCatalog instance
    level_catalog.dart                   # Indexed lookup, startup validation (generates each board, checks for matches and valid moves)
    gem_assets.dart                      # GemType → asset path (v1, v2, horizontal, vertical)

  services/
    progress_service.dart                # SharedPreferences: unlock, bestScore, bestStars, clearAllProgress
    settings_service.dart                # SharedPreferences: soundEnabled, musicEnabled, tileVersion
    audio_service.dart                   # 5 SFX methods, respects soundEnabled
    tutorial_service.dart                # Per-level "seen" tracking
    balancing_service.dart               # JSON metrics storage + console export
```

---

## 5. Key Classes & Their APIs

### BoardModel (`lib/game/board/board_model.dart`)
```dart
BoardModel({int rowCount, int colCount, Iterable<GridPosition> inactiveCells})
TileModel? get(GridPosition pos)
void set(GridPosition pos, TileModel? tile)
CellState? getCellState(GridPosition pos)
void setCellState(GridPosition pos, CellState state)
void swap(GridPosition a, GridPosition b)
BoardModel clone()
bool isInBounds(GridPosition pos)
bool isPlayable(GridPosition pos)   // inBounds && !inactiveCells
bool isBlocked(GridPosition pos)    // has clay pot with layers > 0
List<GridPosition> get playablePositions
List<GridPosition> get markPositions
List<GridPosition> get potPositions
```

### LevelController (`lib/game/systems/level_controller.dart`)
```dart
// Extends ChangeNotifier — Flutter HUD listens via ListenableBuilder
LevelController({required LevelConfig config})
int get currentScore
int get movesRemaining
int get timeRemainingSeconds
int get marksRemaining / totalMarks
int get potsRemaining / totalPots
Map<GemType, int> get collectedGems
LevelPlayState get state        // ready, resolving, paused, won, lost
bool get canAcceptInput         // state == ready
bool get canAdvanceTimer        // hasTimer && state == ready && time > 0
bool beginMoveResolution()      // consumes move, sets state to resolving
void finishResolution()         // evaluates win/lose, sets state to ready/won/lost
void decrementTime()            // ticks timer, evaluates if time hits 0
void recordMatch(GemType, int count, {SpecialGemType, double multiplier})
void recordSpecialClear(GemType, {double multiplier})
void recordMarkCleared()
void recordPotDestroyed()
void recordCombo(ComboType)
bool get areObjectivesMet
```

### MatchFinder (`lib/game/board/match_finder.dart`)
```dart
List<MatchGroup> findMatches(BoardModel board, {GridPosition? swapA, GridPosition? swapB})
bool hasAnyMatch(BoardModel board)
List<MatchGroup> matchesAt(BoardModel board, GridPosition pos)
```

### CascadeResolver (`lib/game/board/cascade_resolver.dart`)
```dart
// Static — never instantiated
static CascadeStep? resolveStep(
  BoardModel board,
  List<GemType> availableGems,
  {Random? random, GridPosition? swapA, GridPosition? swapB}
)
```

### CascadeStep
```dart
class CascadeStep {
  final List<MatchGroup> matches;
  final List<TileFall> falls;
  final List<TileSpawn> spawns;
  final List<SpecialClearInfo> specialClears;
  final Map<GridPosition, SpecialGemType> createdSpecials;
  final List<GridPosition> clearedMarks;
  final List<PotDamageInfo> potDamages;
  final ComboType? triggeredCombo;
  final GridPosition? comboPosition;
  bool get isEmpty;
}
```

### AdinkraGemsGame (`lib/game/adinkra_gems_game.dart`)
```dart
AdinkraGemsGame({required LevelConfig levelConfig, required LevelController levelController})
Sprite? getSpriteFor({required GemType gemType, required SpecialGemType specialType, required int tileVersion})
// onLoad: preloads all 24 sprites (6 gems × 4 variants), generates board, positions BoardComponent
// update: ticks level timer
```

### BoardComponent (`lib/game/components/board_component.dart`)
```dart
// Handles: tap-to-select, drag-to-swipe, swapTiles(), cascade loop, reshuffle loop, board rendering
// Input methods: onTapDown, onDragStart, onDragUpdate, onDragEnd
// Cascade loop: _runCascadeCycle() → CascadeResolver.resolveStep() → animate removal → _animateFallsAndSpawns() → recurse
// Reshuffle: _triggerReshuffle() → gather tiles to center → ReshuffleService.reshuffle() → _animateTilesFromCenter()
// Rendering: draw board background, cell slots, clear marks (gold underlay), clay pots (after children)
```

---

## 6. LevelConfig — The Central Config Object

```dart
class LevelConfig {
  final int levelNumber;
  final String name;
  final List<LevelObjective> objectives;    // All must be satisfied to win
  final int? moveLimit;                     // null = purely timed
  final int? timeLimitSeconds;              // null = purely move-based
  final List<GemType> availableGems;        // Usually all 6
  final StarThresholds starThresholds;      // Score bands for 1/2/3 stars
  final LevelDifficulty difficulty;
  final BoardLayout boardLayout;            // Default 8×8, use for inactive cells
  final List<InitialTileDefinition> initialTiles;     // Pre-placed gems
  final List<GridPosition> clearMarkCells;            // Gold-marked cells
  final List<CellBlockerDefinition> clayPotCells;     // Blocker positions + layers
  final String? tutorialHint;               // Shown once as dialog at level start
  final String? inGameHint;
  final String? levelId;                    // Auto-generated from number if null
  final String episodeId;                   // Default 'episode_1'
  // + validate() helper that returns List<String> errors
}
```

### LevelObjective subtypes
```dart
ScoreObjective(int targetScore)
CollectObjective({required GemType gemType, required int count})
ClearMarkObjective()     // All clearMarkCells must be cleared
ClearBlockerObjective()  // All clayPotCells must be destroyed
```

---

## 7. The Cascade Pipeline (Critical Flow)

When a valid swap happens, here is the EXACT sequence:

1. `BoardComponent.swapTiles(a, b)` — validates via `MoveValidator.isValidSwap()`, calls `levelController.beginMoveResolution()`, swaps `boardModel`, animates visual swap
2. On swap animation complete → `_runCascadeCycle(swapA: a, swapB: b)`
3. `CascadeResolver.resolveStep()` is called:
   - Detects special combos if both swapped tiles are special
   - If no combo: calls `MatchFinder.findMatches()`
   - Processes recursive special activation chain (queue-based BFS)
   - Upgrades matched tiles to special instead of clearing them
   - Clears marks on matched cells
   - Damages adjacent clay pots
   - Compacts tiles in each column (gravity)
   - Spawns new tiles in empty cells
   - Returns `CascadeStep` with all animation instructions
4. `BoardComponent` animates the step:
   - Record scores, play audio
   - Trigger visual effects for specials and combos
   - Animate tile pops for matched positions
   - On all pops complete → animate falls + spawns
   - On all falls/spawns complete → recurse to `_runCascadeCycle()` (no swap args)
5. When `CascadeResolver.resolveStep()` returns `null` (no matches) → board stable
6. `levelController.finishResolution()` → evaluates win/lose
7. If no valid moves remain → `_triggerReshuffle()`
8. Otherwise → `_inputLocked = false`, player can act

---

## 8. Asset Conventions

### Tile Assets
- **v1 tiles:** `assets/tiles/{color}_{symbol}.png` (6 files)
- **v2 tiles:** `assets/tiles_v2/{color}_v2.png` (6 files)
- **Horizontal blast overlays:** `assets/stripped_tile_horizontal/{color}_stripped*.png` (6 files)
- **Vertical blast overlays:** `assets/stripped_tile_vertical/{color}_vertical_stripped*.png` (6 files)

### Audio
- `assets/audio/swap.wav`
- `assets/audio/match.wav`
- `assets/audio/special_clear.wav`
- `assets/audio/win.wav`
- `assets/audio/lose.wav`

### Avatar/Background
- `assets/adinkra tile homescreen pnd.png` — home screen logo
- `assets/new/adinkra gems home screen.png` — woven background image
- `assets/new/adinkra gems text.png` — text logo
- `assets/gameplay background.jpg` — unused alternate background

### Adding a new asset
1. Place file in appropriate `assets/` subdirectory
2. If a new subdirectory, add it to `pubspec.yaml` → `flutter.assets`
3. Map it in `GemAssets` if it's a tile variant
4. Load it in `AdinkraGemsGame.onLoad()` if it's a sprite

---

## 9. How to Add a New Level

1. Open `lib/game/data/levels.dart`
2. Add a `LevelConfig(...)` entry to the `allLevels` list. Required fields:
   ```dart
   LevelConfig(
     levelNumber: N,        // Must be unique
     name: 'Level Name',
     objectives: [ScoreObjective(N)],  // Or CollectObjective, ClearMarkObjective, ClearBlockerObjective
     moveLimit: N,          // and/or timeLimitSeconds
     availableGems: _allGems,
     starThresholds: StarThresholds(oneStar: N, twoStar: N, threeStar: N),
     // Optional:
     boardLayout: BoardLayout(inactiveCells: [...]),
     clearMarkCells: [...],
     clayPotCells: [CellBlockerDefinition(position: ..., layers: 1)],
     initialTiles: [InitialTileDefinition(position: ..., gemType: ..., specialType: ...)],
     tutorialHint: 'Hint text shown once',
   ),
   ```
3. Run tests: `flutter test test/game/level_catalog_test.dart` — this validates every level config
4. If the level has new mechanics (new objective type, new blocker), add validation in `LevelConfig.validate()` and `LevelController.areObjectivesMet`

---

## 10. How to Add a New Screen

1. Create `lib/screens/screen_name/screen_name_screen.dart`
2. Add a route constant in `lib/app/routes.dart`
3. Register in `lib/app/app.dart` route table
4. Add navigation: `Navigator.pushNamed(context, AppRoutes.screenName)`
5. Use `AdinkraTheme` constants for colors
6. Wrap in `WovenBackground` for branded look
7. Use `SafeArea` for notch/status bar handling

---

## 11. How to Add a New Service

1. Create `lib/services/service_name.dart`
2. If it needs init, add to `main()` after `SettingsService.init()`
3. Keep it static or provide a singleton — this project uses static classes (e.g., `ProgressService._()`)
4. Use `SharedPreferences` for persistence (consistent with existing pattern)
5. Add tests in `test/game/service_name_test.dart`

---

## 12. How to Add a New Special Tile Type

1. Add the type to `SpecialGemType` enum in `lib/game/models/special_gem_type.dart`
2. Add creation logic in `MatchFinder.findMatches()` — decide what match pattern creates it
3. Add activation logic in `CascadeResolver._getSpecialEffectPositions()` — what cells it clears
4. Add visual in `TileComponent._drawSpecialOverlay()` — how it looks
5. Add asset mapping in `GemAssets` if it needs a different sprite
6. Add sprite loading in `AdinkraGemsGame.getSpriteFor()` / `onLoad()`
7. Add scoring in `LevelController.recordMatch()` if different points
8. Add combo detection in `CascadeResolver.resolveStep()` if it combines with other specials

---

## 13. How to Add a New Objective Type

1. Add a new `final class` extending `LevelObjective` in `lib/game/models/level_objective.dart`
2. Add tracking fields in `LevelController` (e.g., counters, flags)
3. Implement the check in `LevelController.areObjectivesMet`
4. Add progress calculation in `LevelController._calculateApproximateProgress()`
5. Add UI display in `GameHud`
6. Add validation in `LevelConfig.validate()`
7. Update `LevelController` constructor if the objective needs to read config data (like `clearMarkCells`)
8. If the objective involves board state (like marks/pots), the clearing logic is in `CascadeResolver` and `BoardComponent` — wire the callback to `LevelController.record*()` methods

---

## 14. Common Tasks & Where to Make Changes

| Task | Files to Edit |
|---|---|
| Tune level difficulty | `levels.dart` (targets, limits, star thresholds) |
| Change scoring rules | `level_controller.dart` (`recordMatch`, `recordSpecialClear`, `recordCombo`) |
| Adjust animation timing | `board_component.dart` (EffectController durations) |
| Add new gem color/type | `gem_type.dart`, `gem_assets.dart`, `adinkra_gems_game.dart` (sprite loading), add asset files |
| Change board size | `level_config.dart` (boardLayout), `board_model.dart`, `board_component.dart` (rendering) |
| Add new blocker type | `cell_state.dart` (new CellTerrain), `board_component.dart` (render), `cascade_resolver.dart` (damage logic) |
| Modify cascade behavior | `cascade_resolver.dart` (resolveStep), `board_component.dart` (animation) |
| Add/modify particle effects | `effects_manager.dart`, `gem_particle_component.dart` |
| Change UI colors | `theme.dart` (AdinkraTheme constants) |
| Add new SFX | `audio_service.dart`, add file to `assets/audio/` |
| Fix a level that can't be won | Check `LevelConfig.validate()` output, tune `starThresholds` or limits |
| Export balancing data | Call `BalancingService.exportBalancingData()` from debug code |

---

## 15. Testing Conventions

- Tests live in `test/game/` mirroring the `lib/game/` structure
- Pure logic tests use `flutter_test` + manual setup (no mocking framework)
- Board tests construct `BoardModel` directly with specific tile layouts
- Use `BoardModel.clone()` to simulate moves without mutating
- Level config tests use `LevelCatalog` validation which auto-generates boards
- Run all tests: `flutter test`
- Run specific: `flutter test test/game/match_finder_test.dart`

---

## 16. Key Design Decisions & Rationale

1. **Static service classes** (not dependency injection) — chosen for MVP simplicity. Change to DI if the project grows significantly.
2. **BoardModel is mutable** — CascadeResolver mutates it directly, then returns animation instructions. The clone-based approach is only used for move validation.
3. **LevelController is a ChangeNotifier** — bridges Flame game loop to Flutter HUD without Riverpod/Bloc overhead.
4. **Cascade resolution is iterative, not recursive** — `_runCascadeCycle()` calls itself via animation completion callbacks, capped at 100 steps (then regenerates board).
5. **Special combos checked before MatchFinder** — in `CascadeResolver.resolveStep()`, combo detection runs first. Only if no combo detected does MatchFinder run normally.
6. **Tile assets use versioning** — `SettingsService.tileVersion` (1 or 2) switches between two sets of tile sprites, allowing visual experimentation without code changes.
7. **Clear marks and clay pots are cell terrain** — stored in `CellState` attached to board positions, not tiles. They survive tile swaps, falls, and reshuffles.
8. **No board controller class** — The PRD planned for one, but `BoardComponent` absorbed coordination duties to avoid unnecessary abstraction at MVP scale.
9. **Flame canvas is transparent** (`backgroundColor() => Color(0x00000000)`) — the Flutter `WovenBackground` shows through behind the board.

---

## 17. What NOT to Build (Per MVP Scope)

These are explicitly out of scope and should not be added without discussion:
- Ads, shop, IAP, real-money purchases
- Lives/energy system
- Online accounts, cloud save, leaderboards
- Daily rewards, seasonal events, social features
- Complex blockers beyond clay pots (chocolate, jelly, portals, chains)
- Boosters (hammer, shuffle, extra moves, etc.)
- Multiple worlds (episode system is scaffolded but only Episode 1 exists)
- Remote config or A/B testing
- Music (only SFX are implemented)

---

## 18. Known Quirks & Gotchas

- **Color Clear gem activation:** When it's part of a match with other specials (not the swap initiator), it picks the first available non-ColorClear gem type on the board. This is a known simplification.
- **Board regeneration fallback:** If cascade exceeds 100 steps OR reshuffle fails after 200 attempts, the board is fully regenerated (`_replaceBoardWithFreshBoard()`). This silently resets the board state — marks and pots may be lost.
- **Special tile sprites are separate PNGs**, not overlays: horizontal blast and vertical blast tiles use entirely different sprite files (`stripped_tile_horizontal/` and `stripped_tile_vertical/` directories). Bomb and Color Clear use the normal tile sprite + canvas-drawn overlays.
- **Audio players** are created per SFX and auto-disposed. No pooling. This is fine for MVP but could be optimized.
- **Firebase is in pubspec but not initialized** — `Firebase.initializeApp()` is never called. The dependencies exist for future wiring.
- **Asset naming inconsistencies:** Some stripped tile files have `-removebg-preview` suffixes, some don't. This is documented in code via `GemAssets` — change paths there, not the filenames, to avoid breaking references.
- **Level 2 has 4 corner inactive cells** — this is the only level using non-default BoardLayout. Test any board layout changes on Level 2 specifically.

---

## 19. Reference Documents in Repo

| File | Use When |
|---|---|
| `ADINKRA_GEMS_TECHNICAL_PRD.md` | Need the full original spec for any system, mechanic, or acceptance criterion |
| `ADINKRA_GEMS_PHASED_CODEX_PLAN.md` | Need the original 14-phase implementation plan and phase-by-phase instructions |
| `PROJECT_REPORT.md` | Need a human-readable project overview with status, lists, and summaries |
| `_dev/ADINKRA_GEMS_MVP_PHASE_*.md` | Need the detailed spec for a specific implementation phase |
