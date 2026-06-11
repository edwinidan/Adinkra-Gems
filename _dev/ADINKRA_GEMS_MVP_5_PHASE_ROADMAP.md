# Adinkra Gems MVP - Five-Phase Roadmap

## Purpose

This roadmap turns the larger match-3 plan into five implementation phases
focused on shipping a stable, enjoyable MVP.

The current project already has:

- An 8x8 match-3 board
- Swap validation, cascades, gravity, spawning, and reshuffling
- Score and collect-gem objectives
- Move and timed levels
- Line, Burst, and Unity-style special gems
- Stars and locally saved progress
- 30 draft level definitions
- Gameplay effects, audio, HUD, and win/lose screens
- Automated tests for the main board systems

The MVP work should improve reliability and variety before adding broad systems
such as boosters, complex blockers, or hundreds of levels.

## Phase Files

| Phase | Focus | Checkpoint File |
|---|---|---|
| 1 | Engine stabilization | `ADINKRA_GEMS_MVP_PHASE_1_ENGINE_STABILIZATION.md` |
| 2 | Level model upgrade | `ADINKRA_GEMS_MVP_PHASE_2_LEVEL_MODEL.md` |
| 3 | Clear-mark objective and Clay Pot blocker | `ADINKRA_GEMS_MVP_PHASE_3_OBJECTIVES_AND_BLOCKER.md` |
| 4 | Special-gem combinations and polish | `ADINKRA_GEMS_MVP_PHASE_4_SPECIAL_COMBOS.md` |
| 5 | MVP level pack and balancing | `ADINKRA_GEMS_MVP_PHASE_5_LEVEL_PACK_AND_BALANCING.md` |

## Checkpoint Status

Use these values:

- `[ ]` Not started
- `[~]` In progress
- `[x]` Complete
- `[!]` Blocked or needs a decision

| Phase | Status | Exit Requirement |
|---|---|---|
| Phase 1 | `[~]` | Implementation complete; manual gameplay approval pending |
| Phase 2 | `[~]` | Implementation complete; manual gameplay approval pending |
| Phase 3 | `[ ]` | Clear Mark and Clay Pot levels work from definition to UI |
| Phase 4 | `[ ]` | Four MVP special combinations resolve safely and clearly |
| Phase 5 | `[ ]` | A polished, tested 10-15 level pack is ready for MVP review |

## Working Rules

1. Complete, test, and review one phase before starting the next.
2. Keep the game playable at every checkpoint.
3. Add automated tests for engine and model behavior.
4. Perform manual gameplay checks for animation and UI behavior.
5. Do not add future-phase mechanics while completing the current phase.
6. Do not rebalance all 30 levels until the mechanics are stable.
7. Record important decisions and deferred work in the active phase file.

## MVP Definition Of Done

The MVP is ready for release-focused testing when:

- Final moves and timers cannot end a level during unresolved gameplay.
- All supported level definitions load safely.
- Players can understand every goal from the HUD.
- At least one board objective and one blocker create meaningful variety.
- Special gems and the selected MVP combinations behave consistently.
- The first 10-15 levels teach mechanics in a sensible order.
- Progress, score, and stars survive app restarts.
- Automated tests pass.
- Analyzer output has no errors or warnings affecting gameplay.
- The complete level flow has been manually tested on the target Android device.

## Deferred Until After MVP

- Spirit Guide special gem
- Advanced Unity Orb combinations
- Drop Relic and Path Clear goals
- Locked Gem, Woven Net, Spreading Ink, Shrine Gate, spawners, and large blockers
- Pre-game, in-game, and end-game boosters
- Booster inventory or economy
- Mastery or fourth-star rating
- Remote level configuration
- Expansion to 120 levels
- Live analytics service or online dashboard

## Phase Completion Report

At the end of each phase, record:

```markdown
## Phase Completion Report

### Status
- [ ] Acceptance criteria satisfied
- [ ] Automated tests pass
- [ ] Manual checks pass

### Files Changed
- ...

### Decisions Made
- ...

### Deferred Work
- ...

### Known Issues
- ...

### Approval
- [ ] Approved to begin the next phase
```
