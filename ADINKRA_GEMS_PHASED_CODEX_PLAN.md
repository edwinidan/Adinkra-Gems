# Adinkra Gems — Phased Development Plan for Codex Agent

**Project:** Adinkra Gems  
**Game Type:** Match-3 puzzle game  
**Stack:** Flutter + Flame  
**Purpose of this document:** Give the Codex agent a clear phase-by-phase implementation plan so the project can be built gradually without attempting everything at once.

---

# 0. Important Instruction to the Agent

You are working on a new Flutter + Flame match-3 puzzle game called **Adinkra Gems**.

Do **not** try to build the whole game in one pass.

Work in phases.

At the end of each phase:

1. Stop.
2. Summarize exactly what you changed.
3. List every file you created or edited.
4. Mention any issues, tradeoffs, or unfinished parts.
5. Tell Edwin what to test manually.
6. Wait for approval before continuing to the next phase.

Do not continue to the next phase unless Edwin explicitly says to continue.

---

# 1. Product Summary

Adinkra Gems is a bright, colorful, Candy Crush-style match-3 puzzle game built around glossy crystal Adinkra gem tiles.

The game should feel:

- Bright
- Smooth
- Colorful
- Juicy
- Satisfying
- Magical
- Ghanaian/Adinkra-inspired
- Mobile-friendly

The first playable version must include:

- 10 levels
- Home screen
- Level select map
- Game screen
- Win screen
- Lose screen
- 3-star rating system
- Local saved progress
- Match-3 board
- Valid-match-only swaps
- Automatic cascades
- Automatic reshuffle when no valid moves remain
- Move-based levels
- Time-based levels
- Some levels with both moves and timer
- Score objectives
- Collect tile objectives
- Special tiles:
  - Match 4 = row/column blast tile
  - Match 5 = color clear tile
  - L-shape/T-shape = bomb tile
- Particles, pop animation, bounce, small shake, score popup, and basic sound effects

Boosters are **not required** for the first playable version. They will be added later.

---

# 2. High-Level Technical Direction

Use:

```text
Flutter = app shell, screens, navigation, overlays, settings, level map, save data
Flame = game board, tile rendering, movement, input, particles, animations, effects
Pure Dart = board logic, match detection, scoring, objectives, cascades, level rules
```

Important rule:

> Do not put board logic directly inside Flame visual components.

Separate:

```text
Logic:
- BoardModel
- MatchFinder
- MoveValidator
- CascadeResolver
- LevelController
- ScoreSystem
- ObjectiveSystem

Visual:
- AdinkraGemsGame
- BoardComponent
- TileComponent
- Particle effects
- Score popup
- Special effects
```

---

# 3. Tile Asset Information

The first 6 tile PNG assets are in a folder currently called:

```text
tile asset
```

The current file names are:

```text
red funtumfunefu denkyemfunefu -removebg-preview.png
silver nsoromma-removebg-preview.png
yellow sankofa-removebg-preview.png
purple akofena removebg-preview.png
green gye nyame-removebg-preview.png
blue dwennimmen -removebg-preview.png
```

## 3.1 Required Asset Rename

Before using these assets in code, rename and move them into a clean Flutter asset folder.

Create this folder:

```text
assets/tiles/
```

Rename files like this:

| Original File | New File |
|---|---|
| `red funtumfunefu denkyemfunefu -removebg-preview.png` | `red_funtumfunefu_denkyemfunefu.png` |
| `silver nsoromma-removebg-preview.png` | `silver_nsoromma.png` |
| `yellow sankofa-removebg-preview.png` | `yellow_sankofa.png` |
| `purple akofena removebg-preview.png` | `purple_akofena.png` |
| `green gye nyame-removebg-preview.png` | `green_gye_nyame.png` |
| `blue dwennimmen -removebg-preview.png` | `blue_dwennimmen.png` |

Final expected paths:

```text
assets/tiles/red_funtumfunefu_denkyemfunefu.png
assets/tiles/silver_nsoromma.png
assets/tiles/yellow_sankofa.png
assets/tiles/purple_akofena.png
assets/tiles/green_gye_nyame.png
assets/tiles/blue_dwennimmen.png
```

## 3.2 First 6 Gem Types

Use these 6 tile types for the first playable version:

| Gem Type ID | Color | Adinkra Symbol | Asset |
|---|---|---|---|
| `redFuntumfunefuDenkyemfunefu` | Red | Funtumfunefu Denkyemfunefu | `red_funtumfunefu_denkyemfunefu.png` |
| `silverNsoromma` | Silver | Nsoromma | `silver_nsoromma.png` |
| `yellowSankofa` | Yellow | Sankofa | `yellow_sankofa.png` |
| `purpleAkofena` | Purple | Akofena | `purple_akofena.png` |
| `greenGyeNyame` | Green | Gye Nyame | `green_gye_nyame.png` |
| `blueDwennimmen` | Blue | Dwennimmen | `blue_dwennimmen.png` |

---

# 4. Global Rules for Every Phase

## 4.1 Do Not Overbuild

Do not add:

- Ads
- Shop
- In-app purchases
- Online accounts
- Cloud save
- Daily rewards
- Lives system
- Complex blockers
- Multiplayer
- Leaderboards
- Remote config

## 4.2 Keep MVP Simple

The first playable version is a complete mini game with 10 levels, not a full Candy Crush clone.

## 4.3 Maintain Clean Architecture

Do not mix:

- rendering logic
- board logic
- UI navigation
- save data
- level rules

Each system should have its own file and responsibility.

## 4.4 Every Phase Must Be Testable

At the end of each phase, the app should run or the logic should pass tests.

## 4.5 Always Report Back

After each phase, stop and provide a report.

Report format:

```markdown
## Phase X Report

### Completed
- ...

### Files Created
- ...

### Files Modified
- ...

### How to Test
- ...

### Notes / Issues
- ...

### Ready for Review
Please test and confirm before I continue to Phase X+1.
```

---

# 5. Recommended Folder Structure

Build toward this structure gradually.

```text
lib/
  main.dart

  app/
    app.dart
    routes.dart
    theme.dart

  screens/
    splash/
      splash_screen.dart
    home/
      home_screen.dart
    level_select/
      level_select_screen.dart
      level_node_widget.dart
    game/
      game_screen.dart
      game_hud.dart
      win_overlay.dart
      lose_overlay.dart
    settings/
      settings_screen.dart

  game/
    adinkra_gems_game.dart

    board/
      board_model.dart
      board_controller.dart
      board_state.dart
      grid_position.dart
      match_finder.dart
      cascade_resolver.dart
      move_validator.dart
      board_generator.dart
      reshuffle_service.dart

    components/
      board_component.dart
      tile_component.dart
      score_popup_component.dart
      gem_particle_component.dart
      special_effect_component.dart

    models/
      tile_model.dart
      gem_type.dart
      special_gem_type.dart
      match_group.dart
      level_config.dart
      level_objective.dart
      star_thresholds.dart

    systems/
      level_controller.dart
      score_system.dart
      objective_system.dart
      input_controller.dart
      effects_manager.dart

    data/
      levels.dart
      gem_assets.dart

  services/
    progress_service.dart
    audio_service.dart
    settings_service.dart

  utils/
    constants.dart
    logger.dart
```

Do not create every file at once unless that phase needs it.

---

# Phase 0 — Project Setup and Dependencies

## Goal

Create the basic Flutter project foundation and add the core dependencies needed for Flutter + Flame development.

## What to Do

1. Confirm the Flutter project exists.
2. Add Flame dependency.
3. Add local save dependency.
4. Add audio dependency if needed for later.
5. Create the base folder structure.
6. Set app name to **Adinkra Gems**.
7. Set app orientation to portrait only.
8. Confirm the app runs.

## Suggested Dependencies

In `pubspec.yaml`, add:

```yaml
dependencies:
  flame: ^1.0.0
  shared_preferences: ^2.0.0
  audioplayers: ^6.0.0
```

Use the latest stable compatible versions available in the project environment.

## Files/Folders to Create or Edit

Likely:

```text
pubspec.yaml
lib/main.dart
lib/app/app.dart
lib/app/routes.dart
lib/app/theme.dart
lib/screens/splash/splash_screen.dart
lib/screens/home/home_screen.dart
lib/screens/level_select/level_select_screen.dart
lib/screens/game/game_screen.dart
lib/screens/settings/settings_screen.dart
```

## Acceptance Criteria

- App builds successfully.
- App launches without crashing.
- Basic placeholder screens exist.
- Navigation can move from splash/home to level select and settings.
- No Flame board is required yet.

## Stop and Report

Stop after this phase and report back.

---

# Phase 1 — App Shell, Navigation, and Placeholder Screens

## Goal

Build the basic app flow before adding gameplay.

## Required Screens

1. Splash Screen
2. Home Screen
3. Level Select Screen
4. Game Screen placeholder
5. Settings Screen placeholder

## Home Screen Requirements

Home screen should show:

- Game title: **Adinkra Gems**
- Play button
- Settings button
- About button or simple text section

## Level Select Placeholder Requirements

Show 10 placeholder level nodes.

At this stage:

- Level 1 can be shown as unlocked.
- Levels 2–10 can be shown as locked or placeholder.
- Tapping Level 1 should open the game screen placeholder.
- Do not implement saved progress yet.

## Game Screen Placeholder Requirements

Show:

- Level number
- Placeholder board area
- Back button or pause/menu button

## Settings Placeholder Requirements

Show:

- Sound toggle placeholder
- Music toggle placeholder

Actual persistence can come later.

## Files/Folders to Create or Edit

Likely:

```text
lib/app/routes.dart
lib/screens/home/home_screen.dart
lib/screens/level_select/level_select_screen.dart
lib/screens/level_select/level_node_widget.dart
lib/screens/game/game_screen.dart
lib/screens/settings/settings_screen.dart
```

## Acceptance Criteria

- User can open the app.
- User can press Play.
- User can see 10 level nodes.
- User can tap Level 1 and open the game screen placeholder.
- User can return/back navigate.
- Settings screen opens.

## Stop and Report

Stop after this phase and report back.

---

# Phase 2 — Core Data Models and Level Configs

## Goal

Create pure Dart models for gems, tiles, objectives, levels, and star thresholds.

Do not build the board visually yet.

## What to Build

Create:

- GemType enum
- SpecialGemType enum
- TileModel
- GridPosition
- LevelObjective model
- ScoreObjective
- CollectObjective
- LevelConfig
- StarThresholds
- Static 10-level config list

## Required Gem Types

```dart
enum GemType {
  redFuntumfunefuDenkyemfunefu,
  silverNsoromma,
  yellowSankofa,
  purpleAkofena,
  greenGyeNyame,
  blueDwennimmen,
}
```

## Required Special Gem Types

```dart
enum SpecialGemType {
  none,
  horizontalBlast,
  verticalBlast,
  colorClear,
  bomb,
}
```

## First 10 Levels

Use this initial setup:

| Level | Objective | Limit | Purpose |
|---|---|---:|---|
| 1 | Reach 1,000 points | 20 moves | Teach basic matching |
| 2 | Collect 12 yellow Sankofa tiles | 22 moves | Introduce collect objective |
| 3 | Reach 1,800 points | 20 moves | Introduce cascades/scoring |
| 4 | Collect 15 blue Dwennimmen tiles | 24 moves | Focused collection |
| 5 | Reach 2,500 points | 60 seconds | Introduce timer |
| 6 | Collect 12 red tiles and 12 green tiles | 25 moves | Multi-collect |
| 7 | Reach 3,000 points | 22 moves | Encourage special tiles later |
| 8 | Collect 20 purple Akofena tiles | 75 seconds | Timed collect |
| 9 | Reach 3,500 points and collect 15 silver Nsoromma tiles | 28 moves | Combined objective |
| 10 | Reach 5,000 points | 30 moves + 90 seconds | Mini challenge |

## Files/Folders to Create or Edit

Likely:

```text
lib/game/models/gem_type.dart
lib/game/models/special_gem_type.dart
lib/game/models/tile_model.dart
lib/game/board/grid_position.dart
lib/game/models/level_objective.dart
lib/game/models/level_config.dart
lib/game/models/star_thresholds.dart
lib/game/data/levels.dart
```

## Acceptance Criteria

- Models compile.
- 10 level configs are defined.
- Levels support move limit, time limit, or both.
- Objectives support score and collect.
- No UI needs to consume this yet, but code should be ready.

## Stop and Report

Stop after this phase and report back.

---

# Phase 3 — Asset Registration and Gem Asset Mapping

## Goal

Register the 6 tile assets properly and map each GemType to an asset path.

## What to Do

1. Create `assets/tiles/`.
2. Move/rename the user’s tile PNG files into clean names.
3. Register the folder in `pubspec.yaml`.
4. Create a gem asset mapping file.
5. Confirm Flutter can load the assets.

## Required Final Asset Paths

```text
assets/tiles/red_funtumfunefu_denkyemfunefu.png
assets/tiles/silver_nsoromma.png
assets/tiles/yellow_sankofa.png
assets/tiles/purple_akofena.png
assets/tiles/green_gye_nyame.png
assets/tiles/blue_dwennimmen.png
```

## pubspec.yaml Asset Entry

Use:

```yaml
flutter:
  assets:
    - assets/tiles/
```

Do not list the old folder name with spaces unless absolutely necessary.

## Gem Asset Mapping

Create something like:

```dart
class GemAssets {
  static String pathFor(GemType type) {
    switch (type) {
      case GemType.redFuntumfunefuDenkyemfunefu:
        return 'assets/tiles/red_funtumfunefu_denkyemfunefu.png';
      case GemType.silverNsoromma:
        return 'assets/tiles/silver_nsoromma.png';
      case GemType.yellowSankofa:
        return 'assets/tiles/yellow_sankofa.png';
      case GemType.purpleAkofena:
        return 'assets/tiles/purple_akofena.png';
      case GemType.greenGyeNyame:
        return 'assets/tiles/green_gye_nyame.png';
      case GemType.blueDwennimmen:
        return 'assets/tiles/blue_dwennimmen.png';
    }
  }
}
```

## Files/Folders to Create or Edit

Likely:

```text
assets/tiles/
pubspec.yaml
lib/game/data/gem_assets.dart
```

## Acceptance Criteria

- Assets exist in the clean folder.
- Assets are registered in `pubspec.yaml`.
- No missing asset errors.
- A simple test or placeholder widget can display one tile asset.

## Stop and Report

Stop after this phase and report back.

---

# Phase 4 — Board Logic Foundation

## Goal

Build the pure Dart board engine before Flame visuals.

## What to Build

Create:

- BoardModel
- BoardGenerator
- MoveValidator
- MatchFinder
- Basic board utility methods

## Board Requirements

For the first version:

```text
Rows: 8
Columns: 8
Tile types: 6
Starting board: no automatic matches
Starting board: at least one valid move
```

## BoardModel Responsibilities

- Store cells in a 2D grid.
- Get tile at position.
- Set tile at position.
- Swap two positions.
- Clone board for move simulation.
- Check bounds.

## BoardGenerator Responsibilities

- Generate an 8x8 board.
- Use available gem types from LevelConfig.
- Avoid immediate 3-matches during generation.
- Ensure at least one valid move exists.

## MoveValidator Responsibilities

- Check adjacency.
- Simulate swap.
- Check if swap creates a match.
- Return true/false.

## MatchFinder Responsibilities

At this phase, detect:

- Horizontal match 3+
- Vertical match 3+

L/T and special tile classification can come later.

## Files/Folders to Create or Edit

Likely:

```text
lib/game/board/board_model.dart
lib/game/board/board_generator.dart
lib/game/board/move_validator.dart
lib/game/board/match_finder.dart
lib/game/models/match_group.dart
```

## Acceptance Criteria

- Board generates successfully.
- Board has no matches at start.
- Board has at least one valid move.
- Valid swaps are detected.
- Invalid swaps are rejected.
- Horizontal and vertical matches are detected.

## Recommended Tests

Create unit tests if the project has test setup:

```text
test/game/board_generator_test.dart
test/game/move_validator_test.dart
test/game/match_finder_test.dart
```

Test:

- board generation creates 8x8
- no starting matches
- at least one valid move
- invalid non-adjacent swap rejected
- adjacent no-match swap rejected
- adjacent match swap accepted
- horizontal match detected
- vertical match detected

## Stop and Report

Stop after this phase and report back.

---

# Phase 5 — Flame Game Foundation and Board Rendering

## Goal

Create the Flame game and visually render the 8x8 board using the tile assets.

No swapping or match resolution required yet.

## What to Build

Create:

- AdinkraGemsGame
- BoardComponent
- TileComponent

## Flame Requirements

The Game Screen should host a Flame `GameWidget`.

The board should:

- Render centered on screen.
- Fit mobile portrait layout.
- Display 8x8 tiles.
- Use the 6 tile assets.
- Respect aspect ratio.
- Leave space for HUD above.

## Tile Rendering Requirements

Each TileComponent should:

- Use the correct sprite for its GemType.
- Have a consistent tile size.
- Be positioned based on grid row/column.
- Be visually aligned within the board.

## Files/Folders to Create or Edit

Likely:

```text
lib/screens/game/game_screen.dart
lib/game/adinkra_gems_game.dart
lib/game/components/board_component.dart
lib/game/components/tile_component.dart
```

## Acceptance Criteria

- Game screen shows Flame board.
- 8x8 grid appears.
- Tile assets display correctly.
- Board is centered and not clipped.
- App does not crash when entering game screen.

## Stop and Report

Stop after this phase and report back.

---

# Phase 6 — Input, Tile Selection, and Swap Animation

## Goal

Allow the player to interact with the board and attempt swaps.

Do not implement full cascade yet.

## What to Build

- Tile tap or swipe detection
- Selection highlight
- Adjacent swap attempt
- Valid swap animation
- Invalid swap bounce-back
- Move validation integration

## Input Rules

Allowed:

- Tap a tile then tap adjacent tile
- Or swipe a tile toward adjacent tile

Preferred:

- Implement tap-tap first if faster.
- Add swipe after tap-tap works.

## Swap Rules

- Only adjacent tiles can be swapped.
- Swap is allowed only if it creates a match.
- Invalid swap should animate forward slightly or swap then bounce back.
- Invalid swap should not consume a move.

## Visual Requirements

- Selected tile should glow, pulse, or scale slightly.
- Valid swap should animate smoothly.
- Invalid swap should feel responsive and bounce back.

## Files/Folders to Create or Edit

Likely:

```text
lib/game/adinkra_gems_game.dart
lib/game/components/board_component.dart
lib/game/components/tile_component.dart
lib/game/systems/input_controller.dart
lib/game/board/move_validator.dart
```

## Acceptance Criteria

- Player can select tiles.
- Player can attempt swaps.
- Valid swaps animate.
- Invalid swaps bounce back.
- Input is ignored while a swap animation is running.
- Move count is not required yet unless already implemented.

## Stop and Report

Stop after this phase and report back.

---

# Phase 7 — Match Resolution, Tile Removal, Falling, and Cascades

## Goal

Complete the main match-3 loop.

After a valid swap:

1. Detect matches.
2. Remove matched tiles.
3. Drop tiles down.
4. Spawn new tiles.
5. Continue cascades until stable.
6. Re-enable input.

## What to Build

- CascadeResolver
- Tile removal animation
- Falling animation
- New tile spawn
- Automatic cascade loop
- Input lock during resolution

## Cascade Rules

- Cascades continue automatically until no matches remain.
- Cascades should not consume additional moves.
- New tiles should spawn from above the board.
- Falling tiles should bounce slightly when landing.

## Match Removal Visuals

At this phase, use simple animation:

- scale up slightly
- fade out or pop
- remove from board

Particles can come later.

## Files/Folders to Create or Edit

Likely:

```text
lib/game/board/cascade_resolver.dart
lib/game/board/board_controller.dart
lib/game/components/tile_component.dart
lib/game/adinkra_gems_game.dart
```

## Acceptance Criteria

- Valid swap creates match.
- Matched tiles disappear.
- Tiles above fall into empty spaces.
- New tiles spawn from top.
- Cascades continue until stable.
- Player cannot interact during cascade.
- Player can make another move after cascade finishes.

## Stop and Report

Stop after this phase and report back.

---

# Phase 8 — Score, Moves, Timer, Objectives, and HUD

## Goal

Add level rules and the basic game HUD.

## What to Build

- LevelController
- ScoreSystem
- ObjectiveSystem
- Move counter
- Timer support
- Score objective
- Collect objective
- Game HUD
- GameUiState or notifier bridge between Flame and Flutter

## Required Level Rules

- Valid swap consumes 1 move on move-based levels.
- Invalid swap consumes 0 moves.
- Cascades consume 0 moves.
- Timer counts down for timed levels.
- Some levels can have both moves and timer.
- Player wins only when all objectives are complete.
- Player loses when moves or time run out before objectives complete.
- If objective completes during final cascade, player should win.

## HUD Must Show

- Level number
- Score
- Objective progress
- Moves left if applicable
- Timer if applicable
- Star progress or star indicators

## Files/Folders to Create or Edit

Likely:

```text
lib/game/systems/level_controller.dart
lib/game/systems/score_system.dart
lib/game/systems/objective_system.dart
lib/screens/game/game_hud.dart
lib/screens/game/game_screen.dart
lib/game/models/level_objective.dart
```

## Acceptance Criteria

- Level 1 can show score target.
- Moves decrease only after valid swaps.
- Score increases after matches.
- Collect objective updates when target tiles are cleared.
- Timer levels count down.
- Mixed move/time levels support both.
- HUD updates during gameplay.

## Stop and Report

Stop after this phase and report back.

---

# Phase 9 — Win/Lose Flow, Stars, and Local Progress Saving

## Goal

Make the game feel like a complete level-based product.

## What to Build

- Win screen/overlay
- Lose screen/overlay
- Star calculation
- Local progress save
- Level unlocks
- Best score save
- Best stars save
- Level select map state

## Star Rules

Each level has:

- 1-star score threshold
- 2-star score threshold
- 3-star score threshold

If player wins, minimum is 1 star.

Save the highest stars achieved per level.

## Progress Rules

- Level 1 is unlocked by default.
- Winning Level N unlocks Level N+1.
- Completed levels can be replayed.
- Locked levels cannot be opened.
- Best score and best stars are saved.
- Losing does not reset progress.

## Save System

Use SharedPreferences for first playable version.

Save:

```text
highestUnlockedLevel
bestScore_level_1
bestStars_level_1
...
soundEnabled
musicEnabled
```

## Files/Folders to Create or Edit

Likely:

```text
lib/services/progress_service.dart
lib/screens/game/win_overlay.dart
lib/screens/game/lose_overlay.dart
lib/screens/level_select/level_select_screen.dart
lib/screens/level_select/level_node_widget.dart
lib/game/models/star_thresholds.dart
```

## Acceptance Criteria

- Winning shows win overlay.
- Losing shows lose overlay.
- Stars are calculated correctly.
- Level 2 unlocks after Level 1 win.
- Progress remains after app restart.
- Best score and best stars display on level map.
- Retry works.
- Next level works.
- Map button works.

## Stop and Report

Stop after this phase and report back.

---

# Phase 10 — No Valid Moves Detection and Automatic Reshuffle

## Goal

Add automatic reshuffle when no valid moves remain.

## Rule

When the board is stable after cascades:

1. Check if at least one valid move exists.
2. If no valid moves exist:
   - show “No moves left!”
   - show “Reshuffling...”
   - animate reshuffle
   - produce a board with no starting matches
   - ensure at least one valid move
   - resume input

## What to Build

- Board valid move scanner
- ReshuffleService
- Reshuffle animation
- UI message/overlay

## Files/Folders to Create or Edit

Likely:

```text
lib/game/board/reshuffle_service.dart
lib/game/board/move_validator.dart
lib/game/board/board_generator.dart
lib/game/components/board_component.dart
lib/game/adinkra_gems_game.dart
```

## Acceptance Criteria

- Game detects no available moves.
- Board reshuffles automatically.
- No move is consumed by reshuffle.
- Reshuffled board has no immediate matches.
- Reshuffled board has at least one valid move.
- Player can continue after reshuffle.
- Message appears briefly.

## Stop and Report

Stop after this phase and report back.

---

# Phase 11 — Special Tiles: Match 4, Match 5, L/T Bomb

## Goal

Add MVP special tile system.

## Special Tile Rules

### Match 4

Creates a blast tile.

- Horizontal match 4 creates horizontal blast.
- Vertical match 4 creates vertical blast.

Activation:

- Horizontal blast clears the full row.
- Vertical blast clears the full column.

### Match 5

Creates Color Clear Gem.

Activation:

- Swap Color Clear Gem with a normal tile.
- Clear all tiles of that normal tile’s GemType.

### L-shape / T-shape

Creates Bomb Gem.

Activation:

- Clears 3x3 area around itself.

## What to Build

- Improved MatchFinder that detects:
  - match 4
  - match 5
  - L-shape
  - T-shape
- Special tile creation logic
- Special tile activation logic
- Special tile visual indicators
- Score integration for special clears
- Objective integration for special clears

## MVP Simplification

Do not implement full advanced special-special combos yet.

If two special tiles are swapped together:

- activate both sequentially, or
- choose a simple predictable behavior.

Do not overbuild combo logic in this phase.

## Files/Folders to Create or Edit

Likely:

```text
lib/game/models/special_gem_type.dart
lib/game/models/match_group.dart
lib/game/board/match_finder.dart
lib/game/board/cascade_resolver.dart
lib/game/components/tile_component.dart
lib/game/components/special_effect_component.dart
lib/game/systems/score_system.dart
lib/game/systems/objective_system.dart
```

## Acceptance Criteria

- Match 4 creates a blast tile.
- Horizontal blast clears row.
- Vertical blast clears column.
- Match 5 creates color clear tile.
- Color clear clears all swapped tile type.
- L/T match creates bomb tile.
- Bomb clears 3x3.
- Special-cleared tiles count toward collection objectives.
- Special-cleared tiles award points.
- Game does not freeze during special cascades.

## Stop and Report

Stop after this phase and report back.

---

# Phase 12 — Juice and Polish: Particles, Pop, Shake, Bounce, Sounds

## Goal

Make the game feel satisfying and polished.

## Required Game Feel

When tiles match:

- Small shake
- Pop animation
- Particle burst
- Score number floats up
- Tiny sound effect
- Tiles fall with bounce

## What to Build

- Particle burst per matched tile or per match center
- Floating score popup
- Tile shake before pop
- Tile scale pop
- Bounce effect on falling tiles
- Special tile effects:
  - row beam
  - column beam
  - bomb shockwave
  - color clear pulse
- Basic SFX integration
- Settings toggles for sound/music

## Animation Timing Guide

```text
Swap animation: 120–180ms
Invalid swap bounce-back: 120ms
Tile pop: 120ms
Particle burst: 300–500ms
Tile fall: 200–350ms
Score popup: 500–700ms
Board reshuffle: 700–1000ms
```

## Files/Folders to Create or Edit

Likely:

```text
lib/game/systems/effects_manager.dart
lib/game/components/score_popup_component.dart
lib/game/components/gem_particle_component.dart
lib/game/components/special_effect_component.dart
lib/game/components/tile_component.dart
lib/services/audio_service.dart
lib/services/settings_service.dart
lib/screens/settings/settings_screen.dart
```

## Acceptance Criteria

- Match pop feels clear.
- Particles appear when matches clear.
- Score popup appears.
- Falling tiles bounce slightly.
- Special effects feel different from normal matches.
- Sound effects play if sound is enabled.
- Sound settings persist.
- Game remains smooth.

## Stop and Report

Stop after this phase and report back.

---

# Phase 13 — Full 10-Level Playthrough and Difficulty Tuning

## Goal

Make all 10 levels playable from start to finish and tune obvious difficulty issues.

## What to Do

Play through all 10 levels.

Check:

- Level objectives are possible.
- Move limits are not too harsh.
- Timer levels are playable.
- Stars are achievable.
- Level 10 feels like a small challenge.
- Special tiles appear often enough to be fun.
- Collect objectives update properly.
- The game does not soft-lock.

## Recommended Tuning

Adjust:

- target scores
- move limits
- timer limits
- collect counts
- star thresholds
- available gem types if needed

## Files/Folders to Create or Edit

Likely:

```text
lib/game/data/levels.dart
lib/game/models/star_thresholds.dart
lib/game/systems/score_system.dart
```

## Acceptance Criteria

- All 10 levels can be completed.
- All 10 levels can be lost.
- All levels unlock correctly.
- Stars feel fair.
- No level is impossible due to objective values.
- No level is too slow or too chaotic.

## Stop and Report

Stop after this phase and report back.

---

# Phase 14 — Cleanup, Testing, and Build Readiness

## Goal

Prepare the project for a stable test build.

## What to Do

- Run `flutter analyze`.
- Run tests if available.
- Fix warnings that matter.
- Remove unused files/imports.
- Confirm asset paths.
- Confirm no debug-only test code breaks gameplay.
- Confirm app name is correct.
- Confirm icon/splash placeholders are acceptable or clearly marked TODO.
- Build debug APK.
- Optionally build release APK/AAB later.

## Suggested Commands

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run
```

For Android test build:

```bash
flutter build apk --debug
```

Later release build:

```bash
flutter build appbundle --release
```

Do not configure release signing unless Edwin asks for Play Store build readiness.

## Acceptance Criteria

- `flutter analyze` has no serious errors.
- App builds.
- App runs.
- 10-level flow works.
- No missing asset crashes.
- No navigation dead ends.
- Progress saves.
- Game can be restarted and resumed from level map.

## Stop and Report

Stop after this phase and report back.

---

# 6. Phase Review Checklist for Edwin

After every phase, Edwin should check:

```text
1. Did the app still run?
2. Did the agent only work on the requested phase?
3. Did the agent list changed files?
4. Did the agent explain how to test?
5. Did anything break from previous phases?
6. Is the game moving toward the planned MVP?
```

Do not continue to the next phase until the current phase is accepted.

---

# 7. Final First Playable Definition

The first playable version is complete when:

- The app opens.
- Home screen works.
- Level select map shows 10 levels.
- Level locking/unlocking works.
- Game board displays 6 Adinkra gem tiles.
- Player can only make valid swaps.
- Matches clear correctly.
- Cascades continue until stable.
- No valid moves triggers reshuffle.
- Score objective works.
- Collect objective works.
- Move levels work.
- Timed levels work.
- Mixed move/timed level works.
- Win screen appears.
- Lose screen appears.
- Stars are awarded and saved.
- Best score is saved.
- Progress persists after app restart.
- Match 4 creates blast tile.
- Match 5 creates color clear tile.
- L/T match creates bomb tile.
- Particles, pop, bounce, shake, score popup, and sounds are present.
- All 10 levels can be played.

---

# 8. Final Note to the Agent

This project should be built like a real game, but in controlled steps.

The most important first milestone is:

> One level that feels smooth, satisfying, and fun.

After that, expand to all 10 levels and polish.

Do not rush into boosters, ads, shop, or extra features until the base match-3 gameplay feels good.
