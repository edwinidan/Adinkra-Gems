# Adinkra Gems Match-3 Level, Power-Up, Difficulty & Progression System

## Purpose of This File

This Markdown file gives context and phased implementation instructions for building the match-3 gameplay system for **Adinkra Gems**, a culturally themed Candy-Crush-inspired puzzle game built in Flutter.

The work must **not** be implemented in one huge pass. Each phase should be completed, tested, and committed before moving to the next phase. The goal is to avoid overwhelming the agent and to keep the game engine stable.

This project is inspired by match-3 games like Candy Crush, but it must remain original. Do not copy Candy Crush level layouts, art, names, UI, exact values, proprietary systems, or copyrighted assets. Use the design ideas only as general genre inspiration.

---

## Big Picture Goal

Build a scalable match-3 system for Adinkra Gems that supports:

- Objective-based levels
- Move-limited gameplay
- Difficulty tags
- Star ratings
- Special gems / power-ups
- Boosters
- Blockers
- Level progression
- Episode structure
- JSON/Dart level definitions
- Analytics/debug balancing hooks
- A future path toward hundreds of levels

The final system should allow the developer to create, test, tune, and expand levels without rewriting the engine.

---

## Recommended Number of Phases

This should be done in **10 phases**.

Do not merge phases unless the current codebase is already very advanced. Each phase should end with working code and a simple way to test it.

| Phase | Name | Main Goal |
|---|---|---|
| Phase 1 | Audit & Architecture | Understand the current codebase and design the level engine structure |
| Phase 2 | Core Level Model | Create the data models for levels, goals, tiles, board cells, and difficulty |
| Phase 3 | Match & Cascade Engine | Implement stable match detection, clearing, falling, spawning, and reshuffling |
| Phase 4 | Basic Objectives | Implement move limits and simple objective-based level completion |
| Phase 5 | Star & Scoring System | Add 1-star, 2-star, 3-star, and mastery logic |
| Phase 6 | Special Gems | Add Line Gem, Burst Gem, Unity Orb, and Spirit Guide |
| Phase 7 | Special Gem Combos | Add special + special combination effects |
| Phase 8 | Blockers | Add layered blockers, locked gems, spreading blockers, and spawners |
| Phase 9 | Boosters | Add pre-game, in-game, and end-game boosters |
| Phase 10 | Level Pack & Balancing Tools | Create first level pack and debug tools for tuning difficulty |

---

# Phase 1 — Audit & Architecture

## Goal

Before writing new gameplay systems, inspect the existing Adinkra Gems codebase and identify what already exists.

## Tasks

1. Locate the current game board implementation.
2. Locate existing tile/gem models.
3. Locate any current level data or hardcoded board setup.
4. Locate game state management.
5. Locate animation, sound, scoring, and UI logic.
6. Identify whether the game uses Provider, Riverpod, Bloc, GetX, setState, ValueNotifier, or another state system.
7. Create a short implementation note before making big changes.

## Output

Create or update a document such as:

```text
docs/match3_engine_audit.md
```

It should explain:

- Current files involved in gameplay
- What should be reused
- What should be refactored
- Suggested folder structure
- Risks before implementation

## Acceptance Criteria

- No major gameplay rewrite happens before the audit.
- The agent understands the current architecture.
- The next phases have a clear place to be implemented.

---

# Phase 2 — Core Level Model

## Goal

Create the foundation for data-driven levels.

## Required Models / Enums

Create models similar to these, adjusted to the existing project structure:

```dart
enum LevelDifficulty {
  tutorial,
  easy,
  normal,
  hard,
  superHard,
  nightmare,
  legendary,
}

enum GoalType {
  collectColor,
  clearMark,
  dropRelic,
  collectBlocker,
  collectSpecial,
  pathClear,
  mixed,
}

enum TileType {
  normal,
  line,
  burst,
  unityOrb,
  spiritGuide,
  blocker,
  empty,
}

enum BlockerType {
  none,
  clayPot,
  lockedGem,
  wovenNet,
  spreadingInk,
  shrineGate,
  ananseSpinner,
  festivalCake,
}
```

## LevelDefinition Should Support

Each level should have:

- `id`
- `episodeId`
- `levelNumber`
- `difficultyTag`
- `moveLimit`
- `boardWidth`
- `boardHeight`
- `availableGemColors`
- `boardLayout`
- `initialTiles`
- `blockers`
- `goals`
- `allowedBoosters`
- `preGameBoosters`
- `tutorialHint`
- `targetPassRate`
- `starTargets`
- `rewardConfig`

## Important Design Rule

The level engine should be data-driven. The developer should be able to add levels without editing core engine logic.

## Acceptance Criteria

- Level models compile.
- At least 3 sample levels can be represented using the model.
- The game can load a `LevelDefinition` object.
- No full gameplay balancing is required yet.

---

# Phase 3 — Match & Cascade Engine

## Goal

Implement the core match-3 loop cleanly and safely.

## Required Mechanics

1. Swap two adjacent gems.
2. Reject invalid swaps unless a booster allows it.
3. Detect horizontal matches of 3+.
4. Detect vertical matches of 3+.
5. Clear matched gems.
6. Apply gravity.
7. Spawn new gems.
8. Resolve cascades until no more matches exist.
9. Detect when no legal moves exist.
10. Reshuffle the board safely.

## Core Loop

The move resolution should roughly follow this order:

```text
player swaps tiles
→ validate move
→ consume move if valid
→ detect matches
→ create special gem if pattern qualifies
→ clear matched tiles
→ damage blockers if applicable
→ apply gravity
→ spawn new gems
→ resolve cascades
→ update goals
→ check win/loss
```

## Acceptance Criteria

- Normal match-3 gameplay works.
- Cascades do not cause infinite loops.
- Board does not spawn impossible/null tiles.
- Reshuffling works when no moves exist.
- Move count is consumed only for valid player moves.

---

# Phase 4 — Basic Objectives

## Goal

Move from simple matching to real level goals.

## Implement First

Start with these objective types:

1. `CollectColorGoal`
   - Example: collect 40 blue gems.
2. `ClearMarkGoal`
   - Similar to clearing jelly/marked cells.
3. `CollectBlockerGoal`
   - Destroy a certain number of blocker layers.

## Implement Later in This Phase or Next

4. `DropRelicGoal`
   - Bring relics to exits.
5. `CollectSpecialGoal`
   - Create or activate special gems.
6. `PathClearGoal`
   - Clear a route from source to target.
7. `MixedGoal`
   - Combine two or more goals.

## Win/Loss Logic

- Win when all goals are completed before or on the final move.
- Lose when moves reach 0 and goals are incomplete.
- The final move must fully resolve cascades before deciding win/loss.

## Acceptance Criteria

- Levels can have one or more goals.
- UI can show goal progress.
- Goals update after matches and special effects.
- Move counter works.
- Win/loss state is reliable.

---

# Phase 5 — Star & Scoring System

## Goal

Add scoring and star rewards so levels feel rewarding.

## Star System

Implement:

- 0 stars: fail
- 1 star: pass barely
- 2 stars: pass comfortably
- 3 stars: strong pass
- Gold/Sugar Mastery: excellent pass

## Recommended Star Logic

Use a mix of:

- Score
- Moves left
- Objective completion speed
- Cascades
- Special gem usage
- First-try win, optional

## Suggested Simple Formula

```text
score = baseGemScore
      + blockerDamageScore
      + specialGemScore
      + cascadeBonus
      + movesLeftBonus
```

Suggested scoring values:

- Normal gem cleared: 40 points
- Blocker layer damaged: 100–500 points
- Line Gem activated: 1,000 points
- Burst Gem activated: 1,500 points
- Unity Orb activated: 2,500 points
- Each move left: bonus points

## Recommended Star Thresholds

Each level can define its own thresholds:

```dart
class StarTargets {
  final int oneStarScore;
  final int twoStarScore;
  final int threeStarScore;
  final int masteryScore;
}
```

Also support a move-based mastery option:

```text
Mastery if level is completed with 5+ moves left and strong score.
```

## Acceptance Criteria

- Player receives stars after a win.
- Stars persist per level if saving already exists.
- Higher replay score should update the saved star count.
- Failing a level gives no stars.

---

# Phase 6 — Special Gems

## Goal

Add the main power-up gems created from match patterns.

## Special Gem Types

Use original Adinkra Gems names:

| Generic Match-3 Type | Adinkra Gems Name | Effect |
|---|---|---|
| Striped candy style | Line Gem | Clears row or column |
| Wrapped candy style | Burst Gem | Clears 3x3 area |
| Color bomb style | Unity Orb | Clears all gems of selected color/symbol |
| Fish style | Spirit Guide | Targets useful cells related to the goal |

## Creation Rules

- Match 4 in a row or column → create Line Gem.
- Match 5 in T or L shape → create Burst Gem.
- Match 5 in a straight line → create Unity Orb.
- Match 2x2 square → create Spirit Guide.

## Effects

### Line Gem

- Horizontal Line Gem clears the full row.
- Vertical Line Gem clears the full column.

### Burst Gem

- Clears a 3x3 area.
- Damages blockers in the blast radius.

### Unity Orb

- When swapped with a normal gem, clears every gem of that color/symbol.

### Spirit Guide

Targets useful cells in this priority order:

1. Goal blocker
2. Marked cell
3. Relic path blocker
4. Required collectible
5. Random useful tile

## Acceptance Criteria

- Special gems are created correctly.
- Special gems activate correctly.
- Special effects update objectives.
- Effects damage blockers where appropriate.
- Effects do not crash on board edges or empty cells.

---

# Phase 7 — Special Gem Combos

## Goal

Make special gems feel powerful by combining them.

## Required Combos

Implement these combinations:

| Combo | Effect |
|---|---|
| Line + Line | Clear row and column |
| Line + Burst | Clear 3 rows and 3 columns |
| Burst + Burst | Large double explosion |
| Unity Orb + Normal Gem | Clear all gems of that color |
| Unity Orb + Line Gem | Convert all gems of that color into Line Gems and activate them |
| Unity Orb + Burst Gem | Convert all gems of that color into Burst Gems and activate them |
| Unity Orb + Unity Orb | Clear entire board and damage all blockers |
| Spirit Guide + Line Gem | Spirit Guide targets goals and triggers line clears |
| Spirit Guide + Burst Gem | Spirit Guide targets goals and triggers explosions |
| Spirit Guide + Unity Orb | Spawn multiple Spirit Guides toward high-priority goals |

## Acceptance Criteria

- Special combos work consistently.
- Combo effects are resolved in a predictable order.
- Board state remains valid after large clears.
- Cascades continue after combo resolution.
- UI/animation hooks exist even if final animations are added later.

---

# Phase 8 — Blockers

## Goal

Add puzzle friction and difficulty using blockers.

## Blocker Design

Every blocker should support:

- HP/layers
- Whether it blocks movement
- Whether it blocks spawning
- Whether it blocks special effects
- Whether it spreads
- Whether it contains a hidden item
- How it receives damage

## Recommended Blockers

### 1. ClayPot

Basic layered blocker.

- Has 1–5 layers.
- Damaged by adjacent matches.
- Damaged by special effects.

### 2. LockedGem

A gem trapped inside a lock.

- Cannot move.
- Can be cleared by matching the trapped gem color or hitting it with special effects.

### 3. WovenNet

A blocker that weakens special effects.

- Blocks one special effect hit.
- Can be cleared by adjacent matches.

### 4. SpreadingInk

A spreading blocker.

- If not damaged during a move, it spreads to nearby cells.
- Use only in harder levels.

### 5. ShrineGate

A locked gate requiring key gems.

- Opens after collecting required key gems.
- May protect relics, blockers, or marked cells.

### 6. AnanseSpinner

A spawner blocker.

- Every N moves, it spawns blockers or locked gems.
- Can be destroyed by adjacent matches and special effects.

### 7. FestivalCake

Large multi-hit blocker.

- Has multiple slices/hit points.
- When fully cleared, it damages the board and blockers.

## Acceptance Criteria

- At least ClayPot, LockedGem, and WovenNet work before moving on.
- Blockers can be placed from level definitions.
- Blockers interact correctly with matches and special gems.
- Harder blockers can be added without rewriting the engine.

---

# Phase 9 — Boosters

## Goal

Add player-controlled helpers.

## Booster Categories

### Pre-Game Boosters

These are selected before the level starts:

- StartWithLineGem
- StartWithBurstGem
- StartWithUnityOrb
- StartWithSpiritGuide
- StartWithLineAndBurst
- ExtraMovesPlus3
- LuckyAdinkraGem

### In-Game Boosters

These are used during a level:

- GoldenStaff: remove one tile or blocker layer.
- AnanseHand: swap two adjacent gems without using a move.
- LineBrush: turn one normal gem into a Line Gem and choose direction.
- SpiritRain: place 3 Burst Gems near active goal targets.
- FestivalDrum: clear board once, damage blockers, then spawn random specials.

### End-Game Boosters

These appear when the player fails or is close to winning:

- ExtraMovesPlus5
- ContinueOffer
- SoftHelpAfterRepeatedFailures, optional

## Acceptance Criteria

- Boosters are represented as models/enums.
- Boosters can be enabled/disabled per level.
- In-game boosters can be selected from UI.
- Booster effects update board, goals, and score.
- Boosters do not break move counter logic.

---

# Phase 10 — Level Pack & Balancing Tools

## Goal

Create an initial level pack and tools to tune difficulty.

## First Level Pack

Create the first **30 levels** first, not 120 or 1,000.

Recommended structure:

| Level Range | Purpose |
|---|---|
| 1–5 | Basic matching and collecting colors |
| 6–10 | Teach Line Gem, Burst Gem, Unity Orb |
| 11–15 | Introduce ClayPot blocker |
| 16–20 | Introduce ClearMarkGoal |
| 21–25 | Introduce LockedGem and WovenNet |
| 26–30 | Introduce mixed goals and first hard level |

After these work, expand to 120 levels:

| Level Range | Purpose |
|---|---|
| 1–10 | Teach basic matching and specials |
| 11–25 | Simple blockers and 1-objective levels |
| 26–45 | Mark-clearing levels |
| 46–65 | Collect-color and collect-blocker levels |
| 66–85 | Drop-relic levels |
| 86–105 | Mixed-goal levels |
| 106–120 | Hard, super-hard, and nightmare levels |

## Difficulty Rhythm

Do not make every level harder than the previous one.

Use an up-and-down rhythm:

```text
Easy → Normal → Normal → Hard → Easy/Relief → Normal → Hard → Normal → Super Hard → Relief
```

After a very hard level, add a relief level.

## Suggested Pass Rate Targets

| Difficulty | Target Pass Rate |
|---|---:|
| tutorial | 90–98% |
| easy | 70–90% |
| normal | 45–70% |
| hard | 25–45% |
| superHard | 10–25% |
| nightmare | 5–12% |
| legendary | 2–8% |

These are internal tuning targets, not public Candy Crush numbers.

## Move Limit Guidelines

| Difficulty | Suggested Moves |
|---|---:|
| tutorial | 20–30 |
| easy | 18–30 |
| normal | 18–28 |
| hard | 18–27 |
| superHard | 20–27 |
| nightmare | 18–25 |
| legendary | 18–24 |

Difficulty should come mostly from board shape, blockers, goals, and special-gem requirements, not only from low move counts.

## Debug / Analytics Data

Add a simple debug tracker that records:

- attempts
- wins
- passRate
- averageMovesLeftOnWin
- averageFailRemainingGoalCount
- reshuffleCount
- boostersUsed
- mostFailedGoalType
- blockerDamageRemainingOnFail
- averageCascadesPerMove
- timeToComplete

## Balancing Rules

If pass rate is too low:

- Increase move limit.
- Reduce blocker layers.
- Open more board space.
- Reduce number of gem colors.
- Reduce objective count.
- Add helper special gems.

If pass rate is too high:

- Reduce move limit.
- Increase blocker layers.
- Add isolated cells.
- Increase objective count.
- Add more colors.
- Reduce helper specials.

If reshuffles are too frequent:

- Open the board more.
- Reduce blockers near spawn points.
- Reduce gem colors carefully.
- Improve starting layout.

If players usually fail with only 1–2 targets left:

- The level may already be exciting.
- Consider offering extra moves instead of nerfing immediately.

## Acceptance Criteria

- First 30 levels are playable.
- Levels are loaded from definitions, not hardcoded manually into the engine.
- Each level has goals, moves, difficulty tag, and star targets.
- Debug data can help tune difficulty.
- The system can be expanded to 120 levels later.

---

# Overall Implementation Rules for the Agent

## Do

- Work phase by phase.
- Keep the game playable after every phase.
- Commit or summarize changes after each phase.
- Use original Adinkra Gems names and cultural theming.
- Keep code modular and testable.
- Prefer level definitions over hardcoded level behavior.
- Add comments where gameplay logic is complex.
- Make sure cascades, special gems, and blockers update goals correctly.

## Do Not

- Do not implement all 10 phases in one pass.
- Do not copy Candy Crush assets, layouts, names, or UI.
- Do not hardcode hundreds of levels directly into gameplay files.
- Do not add boosters before the base engine is stable.
- Do not add complex blockers before simple blockers work.
- Do not make every level harder than the previous level.
- Do not break existing screens while refactoring gameplay.

---

# Suggested Folder Structure

Adjust this to the current project structure if needed.

```text
lib/
  game/
    engine/
      match_engine.dart
      cascade_engine.dart
      gravity_engine.dart
      reshuffle_engine.dart
      special_gem_engine.dart
      blocker_engine.dart
      booster_engine.dart
      scoring_engine.dart
    models/
      level_definition.dart
      board_cell.dart
      gem_tile.dart
      level_goal.dart
      blocker.dart
      booster.dart
      star_targets.dart
      level_result.dart
    data/
      levels/
        episode_001.dart
        episode_002.dart
      level_loader.dart
    balancing/
      level_debug_stats.dart
      level_balance_report.dart
    ui/
      game_board.dart
      goal_tracker.dart
      move_counter.dart
      booster_bar.dart
      level_complete_dialog.dart
      level_failed_dialog.dart
```

---

# Phase-by-Phase Agent Prompt Template

Use this format when asking the agent to work on one phase:

```text
Read ADINKRA_GEMS_MATCH3_PHASED_AGENT_PLAN.md first.

Only work on Phase [NUMBER]: [PHASE NAME].

Do not implement future phases yet.

Before editing, inspect the existing codebase and identify the files involved.
Then implement only the required tasks for this phase.
Keep the app compiling and playable.
At the end, summarize:
1. Files changed
2. What was implemented
3. How to test it
4. What should be done in the next phase
```

---

# Recommended First Agent Task

Start with this:

```text
Read ADINKRA_GEMS_MATCH3_PHASED_AGENT_PLAN.md.

Start with Phase 1 only: Audit & Architecture.

Do not implement the match engine yet.
Inspect the current Adinkra Gems Flutter codebase and create a short audit document explaining the current game board, tile model, level flow, state management, and recommended folder structure for the new match-3 engine.

At the end, summarize the files inspected and the safest implementation path for Phase 2.
```

---

# Final Note

The most important thing is to avoid overwhelming the code agent. Build the system like this:

```text
Models first
→ basic matching
→ objectives
→ stars
→ special gems
→ combos
→ blockers
→ boosters
→ level pack
→ balancing tools
```

That order is safer than trying to build power-ups, blockers, levels, UI, and balancing all at once.
