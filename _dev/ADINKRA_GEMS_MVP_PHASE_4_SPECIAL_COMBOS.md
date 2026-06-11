# MVP Phase 4 - Special-Gem Combinations And Polish

## Goal

Make existing special gems more satisfying and strategic by supporting a small,
well-tested set of combinations.

## MVP Combination Set

1. Line Gem + Line Gem
2. Line Gem + Burst Gem
3. Burst Gem + Burst Gem
4. Unity Orb + normal gem

Unity Orb plus normal gem already has partial engine support and should be
standardized under the same combination-resolution system.

## Expected Effects

### Line + Line

Clear the swapped cell's row and column.

### Line + Burst

Clear three rows and three columns centered on the activation position.

### Burst + Burst

Perform a larger area explosion. Choose and document one deterministic radius.

### Unity Orb + Normal

Clear every normal and special gem matching the selected gem's type. Triggered
special gems should resolve using the normal chain-reaction rules.

## Implementation Checklist

### Resolution Architecture

- [ ] Detect a special combination before normal swap validation.
- [ ] Consume one move for a valid special combination.
- [ ] Represent combination results as deterministic affected positions.
- [ ] Deduplicate cells affected by overlapping effects.
- [ ] Trigger secondary special gems once.
- [ ] Apply mark and Clay Pot effects consistently.
- [ ] Continue gravity and cascades after the combination.
- [ ] Evaluate goals only after the complete resolution chain.

### Scoring

- [ ] Define points for each combination.
- [ ] Avoid double-counting overlapping clears.
- [ ] Apply cascade multipliers consistently.
- [ ] Count cleared gems toward collection objectives.
- [ ] Count mark and blocker effects toward their objectives.

### Presentation

- [ ] Give each combination a readable visual effect.
- [ ] Synchronize board shake, particles, sound, and tile removal.
- [ ] Keep effects readable on small Android screens.
- [ ] Prevent long effects from making the board feel unresponsive.
- [ ] Confirm input stays locked until resolution is complete.

## Automated Tests

- [ ] Line + Line clears the expected row and column.
- [ ] Line + Burst clears the expected three rows and columns.
- [ ] Burst + Burst handles edges and corners safely.
- [ ] Unity Orb + normal clears all matching gems.
- [ ] Combination effects damage Clay Pots correctly.
- [ ] Combination effects clear marks correctly.
- [ ] Overlapping cells score and count once.
- [ ] Secondary specials trigger once.
- [ ] Cascades continue after each combination.
- [ ] Final-move combinations can win a level.

## Manual Checkpoint

- [ ] Trigger every combination near the board center.
- [ ] Trigger every applicable combination at an edge or corner.
- [ ] Trigger combinations near marks and Clay Pots.
- [ ] Trigger a combination that starts a secondary special chain.
- [ ] Confirm effects, audio, scoring, and HUD updates feel synchronized.
- [ ] Confirm the board remains playable after large clears.

## Acceptance Criteria

- All four MVP combinations behave predictably.
- Combination clears update every supported objective.
- Overlapping and chained effects do not duplicate results.
- The board remains valid after large clears.
- Effects are satisfying without obscuring gameplay.

## Out Of Scope

- Unity Orb + Line
- Unity Orb + Burst
- Unity Orb + Unity Orb
- Spirit Guide
- Spirit Guide combinations
- Booster-created combinations

## Decisions To Record

- Burst + Burst radius:
- Combo scoring values:
- Chain-reaction ordering:
- Visual duration target:

## Completion

- [ ] Implementation complete
- [ ] Tests complete
- [ ] Manual checks complete
- [ ] Approved for Phase 5
