# MVP Phase 1 - Engine Stabilization

## Goal

Make the existing game loop reliable before adding new mechanics.

The most important correction is ensuring the final move fully resolves all
matches, special effects, cascades, scoring, and objectives before the game
decides whether the player won or lost.

## Current Risk

The board currently consumes a move before cascade resolution. The level
controller can declare a loss immediately when the move count reaches zero,
causing results from the final move to be ignored.

Timers can create a similar problem if they expire while a swap or cascade is
still resolving.

## Implementation Checklist

### Level Lifecycle

- [x] Define explicit gameplay states such as ready, resolving, won, and lost.
- [x] Consume a valid player move without immediately declaring a loss.
- [x] Resolve the complete cascade chain.
- [x] Evaluate objectives after the board becomes stable.
- [x] Declare a loss only when the stable board has unmet goals and no moves.
- [x] Ensure an objective completed on the final move results in a win.
- [x] Prevent duplicate win/lose dialogs.
- [x] Prevent input after a final result is decided.

### Timer Behavior

- [x] Decide whether the timer pauses during swap and cascade animations.
- [x] Pause the gameplay timer while the pause dialog is open.
- [x] Stop the timer when the level ends.
- [x] Ensure timer expiry waits for an active resolution cycle to finish.
- [x] Prevent timer-based and move-based endings from firing twice.

### Board Reliability

- [x] Confirm invalid swaps do not consume moves.
- [x] Confirm reshuffling does not consume moves.
- [x] Confirm reshuffling does not create immediate matches.
- [x] Add a safe fallback if reshuffling existing tiles fails.
- [x] Confirm cascades cannot continue indefinitely.
- [x] Confirm scoring and collection counts include special-gem clears once.

### Progress Reliability

- [x] Confirm only completed levels unlock the next level.
- [x] Clamp the highest unlocked level to the available level count.
- [x] Update progress-reset logic to cover all current levels.
- [x] Confirm replaying with a lower result does not overwrite a better result.

## Automated Tests

- [x] Final move completes a score objective.
- [x] Final move completes a collect objective through cascades.
- [x] Final move fails only after the cascade finishes.
- [x] A special clear on the final move updates the objective.
- [x] Invalid swaps do not consume a move.
- [x] Timer expiry during resolution waits for board stability.
- [x] Only one final result is emitted.
- [x] Resetting progress clears every configured level.

## Manual Checkpoint

- [ ] Win a level using the last available move.
- [ ] Fail a level after the last move fully settles.
- [ ] Pause and resume a timed level.
- [ ] Trigger a multi-cascade final move.
- [ ] Trigger a reshuffle near the end of a level.
- [ ] Retry, return to map, and advance to the next level.
- [ ] Restart the app and verify saved progress and stars.

## Acceptance Criteria

- The final move always receives its complete result.
- Win/lose dialogs appear once and only after gameplay settles.
- Timer behavior is predictable and documented.
- Existing engine tests still pass.
- New lifecycle tests pass.
- No gameplay-affecting analyzer warnings remain in touched files.

## Out Of Scope

- New objectives
- Blockers
- New special gems
- Special-gem combinations
- Booster systems
- Broad level balancing

## Decisions To Record

- Timer behavior during animations: paused while swaps/cascades resolve and
  while the pause dialog is open.
- Chosen gameplay state model: `ready`, `resolving`, `paused`, `won`, and
  `lost`, owned by `LevelController`.
- Reshuffle fallback: generate a fresh valid board when preserving and
  reshuffling the existing tiles fails.
- Known lifecycle limitations: browser-based manual verification was blocked
  by the local Flutter debug canvas rendering blank in the available headless
  browser. Device/manual checks remain open.

## Completion

- [x] Implementation complete
- [x] Tests complete
- [ ] Manual checks complete
- [ ] Approved for Phase 2

## Phase Completion Report

### Status

- [x] Implementation acceptance criteria satisfied
- [x] Automated tests pass
- [ ] Manual gameplay checks pass

### Verification

- `flutter test`: 43 tests passed.
- `flutter analyze`: no errors or warnings; 46 informational deprecation/style
  notices remain across the existing project.
- Flutter web debug server compiled and started successfully.
- Automated browser tooling could not complete visual verification because the
  available headless browser produced a blank Flutter debug canvas.

### Files Changed

- `lib/game/systems/level_controller.dart`
- `lib/game/components/board_component.dart`
- `lib/game/adinkra_gems_game.dart`
- `lib/screens/game/game_screen.dart`
- `lib/screens/level_select/level_select_screen.dart`
- `lib/services/progress_service.dart`
- `test/game/level_controller_test.dart`
- `test/game/progress_service_test.dart`
- `_dev/ADINKRA_GEMS_MVP_PHASE_1_ENGINE_STABILIZATION.md`
- `_dev/ADINKRA_GEMS_MVP_5_PHASE_ROADMAP.md`

### Approval

- [ ] Edwin has completed the manual checkpoint
- [ ] Approved to begin Phase 2
