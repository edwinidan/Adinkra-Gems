# Adinkra Gems — Project Report

**Date:** 2026-06-12
**Version:** 1.0.0+1 (MVP Complete)
**Repository:** `Adinkra Gems`

---

## 1. Executive Summary

Adinkra Gems is a polished match-3 puzzle game for Android (Flutter + Flame), themed around Ghanaian Adinkra symbols rendered as glossy crystal gem tiles. The game follows a Candy Crush-style core loop: players swap adjacent gems on an 8×8 board to form matches of 3+, triggering cascades, special tile creation, and particle-heavy visual effects.

The MVP is **feature-complete**: 30 levels across an expandable episode structure, 4 objective types, 4 special tile types, special combo system, clear marks and clay pot blocker mechanics, local progress persistence, tutorial hints, balancing telemetry, and a full set of UI screens (splash, home, level select, game, settings, game-over dialogs, pause menu, about sheet).

---

## 2. Technical Stack

| Layer | Technology | Version |
|---|---|---|
| Framework | Flutter | SDK ^3.11.5 |
| Game Engine | Flame | ^1.37.0 |
| Persistence | shared_preferences | ^2.5.5 |
| Audio | audioplayers | ^6.7.1 |
| Crash Reporting | firebase_core + firebase_crashlytics | ^4.10.0 / ^5.2.3 |
| Linting | flutter_lints | ^6.0.0 |

Target: **Android first** (portrait-only), iOS-ready.

---

## 3. Architecture

The codebase strictly separates **pure Dart game logic** from **Flame rendering** and **Flutter UI/shell**:

```
lib/
  main.dart                          # Entry point, orientation lock, immersive mode
  app/
    app.dart                         # MaterialApp, route registration
    routes.dart                      # Named route constants
    theme.dart                       # AdinkraTheme (cocoa/cream/terracotta palette)
    woven_background.dart            # Branded background decorator
  screens/
    splash/splash_screen.dart        # Logo + auto-navigate
    home/home_screen.dart            # Play, Settings, About (bottom sheet with symbol guide)
    level_select/
      level_select_screen.dart       # Grid of 30 level nodes, star/score display
      level_node_widget.dart         # Individual level card (locked/unlocked/completed)
    game/
      game_screen.dart               # Hosts Flame GameWidget + HUD + overlays
      game_hud.dart                  # Score, moves, timer, objectives, pause button
      game_over_dialog.dart          # Win/lose dialog with stars, retry/next/map
    settings/settings_screen.dart    # Sound, Music, Tile Version toggles
  game/
    adinkra_gems_game.dart           # FlameGame root — asset preloading, board init, timer tick
    board/
      board_model.dart               # 2D grid of TileModel + CellState, swap/clone/bounds
      board_generator.dart           # No-match initial fill, respects layout & blockers
      grid_position.dart             # (row, col) value class
      match_finder.dart              # Horizontal/vertical/L/T match detection + classification
      move_validator.dart            # Adjacency, swap simulation, combo validation
      cascade_resolver.dart          # Match resolution → gravity drop → spawn → chain
      reshuffle_service.dart         # In-place shuffle when no valid moves remain
    components/
      board_component.dart           # Flame PositionComponent — input handling, cascade orchestration, rendering, clay pot drawing
      tile_component.dart            # Flame SpriteComponent — sprite, selection pulse, pop animation, special overlays
      gem_particle_component.dart    # Colored particle burst on match
      score_popup_component.dart     # Floating score number
      special_effect_component.dart  # Beam, shockwave, color-clear pulse effects
    models/
      gem_type.dart                  # 6 Adinkra gem types enum
      special_gem_type.dart          # none/horizontalBlast/verticalBlast/colorClear/bomb
      tile_model.dart                # Per-gem data (id, gemType, specialType, flags)
      level_config.dart              # Full level definition (objectives, limits, layout, blockers)
      level_objective.dart           # Sealed class: Score/Collect/ClearMark/ClearBlocker
      star_thresholds.dart           # 1/2/3-star score bands
      match_group.dart               # Detected match with positions, special spawn info
      board_layout.dart              # Rectangular grid with optional inactive cells
      cell_state.dart                # Per-cell terrain (clearMark, clayPot with layers)
      cell_blocker_definition.dart   # Blocker placement config
      initial_tile_definition.dart   # Pre-placed tile config
      level_difficulty.dart          # tutorial/easy/normal/hard enum
      combo_type.dart                # lineLine/lineBurst/burstBurst/unityNormal enum
    systems/
      level_controller.dart          # ChangeNotifier — score, moves, timer, objectives, win/lose evaluation
      effects_manager.dart           # Static factory for particles, beams, shakes, popups
    data/
      levels.dart                    # Static list of all 30 LevelConfig definitions
      level_catalog.dart             # Indexed catalog with startup validation
      gem_assets.dart                # GemType → asset path mapping (v1, v2, horizontal, vertical)
  services/
    progress_service.dart            # SharedPreferences — unlocks, best scores, best stars
    settings_service.dart            # SharedPreferences — sound, music, tile version
    audio_service.dart               # audioplayers wrapper for 5 SFX
    tutorial_service.dart            # SharedPreferences — per-level hint "seen" tracking
    balancing_service.dart           # Local JSON metrics: attempts, wins, cascades, progress
```

---

## 4. Features Implemented

### 4.1 Core Match-3 Loop
- 8×8 board (configurable per level)
- 6 Adinkra gem types (Red Funtumfunefu, Silver Nsoromma, Yellow Sankofa, Purple Akofena, Green Gye Nyame, Blue Dwennimmen)
- Valid-match-only swaps (tap-tap and drag/swipe input)
- Invalid swap bounce-back animation
- Match-3+, match-4, match-5, L-shape, T-shape detection
- Automatic cascade resolution with gravity drop and tile spawn
- Cascade score multiplier (1.0× → 1.5× → 2.0× → 2.5×)

### 4.2 Special Tiles & Combos
| Trigger | Special Tile Created | Effect on Activation |
|---|---|---|
| Match-4 horizontal | Horizontal Blast | Clears entire row |
| Match-4 vertical | Vertical Blast | Clears entire column |
| Match-5 | Color Clear ("Unity") | Swap with any tile → clears all of that tile's color |
| L-shape / T-shape | Bomb ("Burst") | Clears 3×3 area |

**Special combos** (swapping two special tiles together):
| Combo | Effect |
|---|---|
| Line + Line | Clears row + column (cross blast) |
| Line + Burst | Clears 3 rows + 3 columns |
| Burst + Burst | Clears 5×5 area |
| Unity + Normal | Clears all tiles of the normal tile's color |

### 4.3 Level Objectives (4 types)
- **Score Objective** — reach a target score
- **Collect Objective** — clear N tiles of a specific gem type
- **Clear Mark Objective** — clear all gold-marked cells by matching gems on them
- **Clear Blocker Objective** — destroy all Clay Pot blockers (1 or 2 layers each, damaged by adjacent matches)

### 4.4 Level Limits
- Move-based levels (fixed number of swaps)
- Time-based levels (countdown timer)
- Mixed move + time levels (both limits apply simultaneously)

### 4.5 Board Mechanics
- **Inactive cells** — holes in the board breaking matches (Level 2 uses 4 corner holes)
- **Clear Marks** — gold underlay on specific cells; a gem matched on a marked cell clears the mark
- **Clay Pots** — 1 or 2-layer blockers; destroyed by matching adjacent gems; each match damages 1 layer
- **Initial tiles** — pre-placed gems (including special gems) at level start (Level 3 starts with a Color Clear gem)
- **Reshuffle** — automatic when no valid moves remain; tiles gather to center, shuffle, disperse
- **Board regeneration** — fresh board as fallback if reshuffle fails or cascade exceeds 100 steps

### 4.6 Star Rating & Progress
- 3-star thresholds per level (score-based)
- Best score and best stars persisted per level
- Linear unlock: winning level N → unlocks N+1
- Level select grid shows locked/unlocked/completed state with stars

### 4.7 UI & Polish
- **Splash Screen** — logo + auto-navigate
- **Home Screen** — Play, Settings, About (scrollable sheet with Adinkra symbol guide)
- **Level Select** — 3-column grid, 30 nodes with star/score display
- **Game HUD** — level number, score, star progress bar, objectives progress, moves/timer, pause button
- **Win Dialog** — stars animation, score, next/retry/map buttons
- **Lose Dialog** — score, objective progress, retry/map buttons
- **Pause Dialog** — resume/quit to menu
- **Settings** — sound toggle, music toggle, tile version selector (v1/v2)
- Cohesive warm cocoa/cream/terracotta color palette (AdinkraTheme)
- WovenBackground decorator with branded imagery
- Tutorial hint dialogs (per-level, shown once)

### 4.8 Audio
- 5 sound effects: swap, match, special clear, win, lose
- Respects sound enabled setting
- Graceful failure (no crash if audio unavailable)

### 4.9 Game Feel (Juice)
- Tile scale-in entrance animation (easeOutBack)
- Selected tile pulse
- Valid swap: smooth move → cascade chain
- Invalid swap: forward-then-bounce-back
- Match pop: scale up (1.25×) → shrink to zero
- Falling tile squash-and-stretch landing (3-step scale sequence)
- Particle bursts (color-matched to gem type)
- Floating score popups
- Special effect beams, shockwaves, and color-clear pulses
- Board shake on special activations and combos
- Reshuffle: tiles gather to center, shrink, then bounce out to new positions

### 4.10 Balancing Telemetry
- `BalancingService` records per-level: attempts, wins, moves remaining, time taken, reshuffles, max cascade chain, loss progress
- Console export via `BalancingService.exportBalancingData()`
- No remote reporting — all data stored locally in SharedPreferences

---

## 5. Levels Summary

| Levels | Episode | Theme |
|---|---|---|
| 1–10 | Episode 1: The Awakening | Tutorial → easy → normal difficulty ramp |
| 11–15 | Episode 1 (Chapter 2) | Higher score targets, multi-collect, timed blitz |

- Level 1: Score 1,000 (20 moves) — tutorial with hint dialog
- Level 2: Collect 12 Yellow Sankofa (22 moves) — 4 corner inactive cells
- Level 3: Score 1,800 (20 moves) — starts with pre-placed Color Clear gem
- Level 4: Collect 15 Blue Dwennimmen (24 moves)
- Level 5: Score 2,500 (60 seconds) — first timed level
- Level 6: Collect 12 Red + 12 Green (25 moves)
- Level 7: Score 3,000 (22 moves)
- Level 8: Collect 20 Purple (75 seconds)
- Level 9: Score 3,500 + Collect 15 Silver (28 moves)
- Level 10: Score 5,000 (30 moves + 90 seconds)
- Levels 11–15: Higher difficulty, tighter limits

Levels 16–30 are scaffold space; configs are prepared in the catalog structure.

---

## 6. Asset Inventory

| Directory | Contents | Count |
|---|---|---|
| `assets/tiles/` | v1 gem tile PNGs (6 colors) | 6 |
| `assets/tiles_v2/` | v2 gem tile PNGs (alternate style) | 6 |
| `assets/stripped_tile_horizontal/` | Horizontal blast special tile overlays | 6 |
| `assets/stripped_tile_vertical/` | Vertical blast special tile overlays | 6 |
| `assets/audio/` | SFX (swap, match, special_clear, win, lose) | 5 WAV |
| `assets/` | Home screen logo, gameplay background | 2 |
| `assets/new/` | Updated home screen + text logo | 2 |

---

## 7. Testing

13 unit test files covering all pure-logic systems:
- `board_generator_test.dart` — no-match generation, valid move guarantee
- `match_finder_test.dart` — horizontal, vertical, L/T shape detection
- `move_validator_test.dart` — adjacency, validity, combo validation
- `cascade_resolver_test.dart` — gravity, spawn, chain resolution
- `cascade_resolver_special_test.dart` — special tile creation and activation chains
- `cascade_resolver_combo_test.dart` — special combo effects
- `level_controller_test.dart` — score, objectives, win/lose evaluation
- `level_catalog_test.dart` — config validation
- `dynamic_board_test.dart` — variable board sizes and inactive cells
- `progress_service_test.dart` — save/load logic
- `settings_service_test.dart` — settings persistence
- `reshuffle_service_test.dart` — reshuffle constraints
- `tutorial_service_test.dart` — hint tracking

---

## 8. Current State & Known Gaps

### Complete
- Full match-3 gameplay loop with all special tiles and combos
- 30 level configs (15 fully specified, 15 scaffold)
- All UI screens and dialogs
- Local progress and settings persistence
- Audio system with 5 SFX
- Particle effects, animations, board shake
- Clear marks and clay pot blocker mechanics
- Tutorial hints
- Balancing telemetry
- Unit test suite (13 files)

### Gaps / Future Work
- Levels 16–30 need full objective/limit specification (currently scaffold)
- Firebase Crashlytics is added as dependency but not wired into a running Firebase project
- No music (only SFX)
- No boosters, shop, ads, IAP, lives system (per original MVP non-goals)
- No cloud save or online accounts
- No leaderboards
- Android release signing not configured
- App icon is default Flutter icon

---

## 9. Project Documentation

| Document | Purpose |
|---|---|
| `ADINKRA_GEMS_TECHNICAL_PRD.md` | Original 41-section technical PRD defining every system, mechanic, and acceptance criterion |
| `ADINKRA_GEMS_PHASED_CODEX_PLAN.md` | 14-phase implementation plan originally used to build the project incrementally |
| `_dev/ADINKRA_GEMS_MVP_5_PHASE_ROADMAP.md` | High-level 5-phase roadmap summary |
| `_dev/ADINKRA_GEMS_MVP_PHASE_*.md` | Phase-by-phase detailed implementation specs (5 documents) |
| `_dev/ADINKRA_GEMS_MATCH3_PHASED_AGENT_PLAN.md` | Alternative phased agent plan |

---

## 10. Build & Run Commands

```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run static analysis
flutter analyze

# Run all tests
flutter test

# Build debug APK
flutter build apk --debug

# Build release app bundle
flutter build appbundle --release
```
