# MVP Phase 2 - Level Model Upgrade

## Goal

Upgrade the level model so gameplay variety can come from data rather than
hardcoded engine behavior.

Keep Dart definitions for the MVP. JSON loading is useful later, but it is not
required to prove the game.

## Recommended Model Additions

- `id`
- `episodeId` or `chapterId`
- `difficulty`
- `boardWidth`
- `boardHeight`
- `boardLayout`
- `initialTiles`
- `tutorialHint`
- `targetPassRate`
- Existing objectives, limits, gems, and star thresholds

## Implementation Checklist

### Difficulty

- [x] Add tutorial, easy, normal, hard, and super-hard difficulty values.
- [x] Avoid nightmare and legendary until post-MVP content exists.
- [x] Display difficulty only where it helps the player.
- [x] Keep target pass rate as internal tuning metadata.

### Board Definition

- [x] Replace fixed board-size assumptions in models where necessary.
- [x] Define active cells, inactive holes, and transient empty active cells.
- [x] Reserve blocked-cell behavior for the Phase 3 blocker model.
- [x] Support irregular board shapes without using blocker logic.
- [x] Support fixed starting normal gems.
- [x] Support fixed starting special gems.
- [x] Validate every configured position is within board bounds.
- [x] Ensure gravity and spawning respect inactive cells.
- [x] Ensure legal-move detection respects the configured layout.

### Level Loading

- [x] Add a single level lookup API instead of direct list indexing.
- [x] Handle missing or invalid level IDs safely.
- [x] Validate unique level IDs and level numbers.
- [x] Keep existing saved progress compatible.
- [x] Keep the current definition file until chapter splitting becomes useful.

### Tutorial Metadata

- [x] Support an optional pre-level hint.
- [x] Support an optional in-game mechanic hint.
- [x] Ensure hints can be marked as already seen.
- [x] Keep tutorials dismissible and replay-safe.

## Validation Rules

- [x] At least one objective exists.
- [x] At least one move or time limit exists.
- [x] At least three gem types are available.
- [x] Star thresholds are ordered correctly.
- [x] Initial tiles only use available gem types.
- [x] Initial layout does not contain impossible coordinates.
- [x] A generated starting board has at least one valid move.

## Automated Tests

- [x] Load a standard 8x8 level.
- [x] Load an irregular board layout.
- [x] Load a level with initial normal and special tiles.
- [x] Reject duplicate IDs.
- [x] Reject out-of-bounds initial content.
- [x] Reject unordered star thresholds.
- [x] Generate a playable board for every MVP level definition.
- [x] Preserve compatibility with existing progress keys.

## Manual Checkpoint

- [ ] Open levels from the map using the new lookup.
- [ ] Play a normal rectangular level.
- [ ] Play an irregular layout.
- [ ] Verify fixed starting tiles appear correctly.
- [ ] Verify tutorial text appears only when intended.
- [ ] Complete, retry, and replay the configured levels.

## Acceptance Criteria

- Level-specific board layouts work without gameplay code changes.
- Invalid definitions fail clearly during development.
- Existing progress remains usable.
- At least three sample levels demonstrate the upgraded model.
- The board engine no longer relies unnecessarily on a global fixed layout.

## Out Of Scope

- JSON or server-hosted level loading
- Blockers and blocker damage
- Boosters
- Remote configuration
- Full episode-map redesign

## Decisions To Record

- Board-layout representation: rectangular width/height plus a list of inactive
  hole positions. Active cells may temporarily be empty during resolution.
- Level ID format: explicit string IDs where supplied, with `level_N` fallback
  for existing definitions.
- Difficulty values kept for MVP: tutorial, easy, normal, hard, and super-hard.
- Tutorial persistence approach: `SharedPreferences` keys based on stable level
  IDs. Pre-level hints appear once; optional in-game reminders remain visible.

## Completion

- [x] Implementation complete
- [x] Tests complete
- [ ] Manual checks complete
- [ ] Approved for Phase 3

## Phase Completion Report

### Status

- [x] Implementation acceptance criteria satisfied
- [x] Automated tests pass
- [ ] Manual gameplay checks pass

### Verification

- `flutter test`: 54 tests passed.
- `flutter analyze`: no errors or warnings; 46 informational deprecation/style
  notices remain across the existing project.
- `flutter build web`: succeeded.
- Every shipped level definition validates and generates a match-free board
  with at least one legal move.

### Representative Levels

- Level 1: standard 8x8 tutorial level with a one-time pre-level hint.
- Level 2: irregular 8x8 board with inactive corner cells.
- Level 3: fixed starting Unity-style special and in-game mechanic reminder.

### Files Added

- `lib/game/models/level_difficulty.dart`
- `lib/game/models/board_layout.dart`
- `lib/game/models/initial_tile_definition.dart`
- `lib/game/data/level_catalog.dart`
- `lib/services/tutorial_service.dart`
- `test/game/level_catalog_test.dart`
- `test/game/dynamic_board_test.dart`
- `test/game/tutorial_service_test.dart`

### Main Files Updated

- `lib/game/models/level_config.dart`
- `lib/game/data/levels.dart`
- `lib/game/board/board_model.dart`
- `lib/game/board/board_generator.dart`
- `lib/game/board/match_finder.dart`
- `lib/game/board/move_validator.dart`
- `lib/game/board/cascade_resolver.dart`
- `lib/game/board/reshuffle_service.dart`
- `lib/game/adinkra_gems_game.dart`
- `lib/game/components/board_component.dart`
- `lib/screens/game/game_screen.dart`
- `lib/screens/game/game_hud.dart`
- `lib/screens/level_select/level_select_screen.dart`

### Known Issues

- Automated visual verification is still unavailable because the local
  headless browser renders the Flutter debug canvas blank.
- Hands-on checks of the irregular layout, starting special, and tutorial
  presentation remain pending.

### Approval

- [ ] Edwin has completed the manual checkpoint
- [ ] Approved to begin Phase 3
