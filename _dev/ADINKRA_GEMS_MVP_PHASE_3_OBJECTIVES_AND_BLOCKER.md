# MVP Phase 3 - Clear Mark Objective And Clay Pot Blocker

## Goal

Add one board-based objective and one understandable blocker to create meaningful
level variety without overloading the MVP.

## MVP Mechanics

### Clear Mark

A mark exists beneath a playable board cell. The mark is removed when a match
or special effect clears the gem on that cell.

### Clay Pot

A Clay Pot is a layered blocker placed in a board cell. It is damaged by
adjacent matches and by applicable special-gem effects.

Start with one or two layers. More layers can be represented by the model but
do not need to appear in early MVP levels.

## Implementation Checklist

### Cell State

- [ ] Separate cell/terrain state from the gem occupying the cell.
- [ ] Represent marks independently from normal gems.
- [ ] Represent Clay Pot type and remaining layers.
- [ ] Define whether a Clay Pot blocks movement, gravity, and spawning.
- [ ] Preserve cell state during swaps, falls, spawns, and reshuffles.

### Clear Mark Objective

- [ ] Add a clear-mark objective model.
- [ ] Count total and remaining marked cells.
- [ ] Remove marks from normal matches.
- [ ] Remove marks from Line, Burst, and Unity Orb effects.
- [ ] Show mark progress in the HUD.
- [ ] Include marks in final win/loss evaluation.

### Clay Pot Behavior

- [ ] Place Clay Pots from level definitions.
- [ ] Damage a pot from an adjacent normal match.
- [ ] Damage a pot from applicable special effects.
- [ ] Remove the pot when its final layer is destroyed.
- [ ] Prevent a pot from being swapped like a gem.
- [ ] Ensure gravity behaves correctly around pot cells.
- [ ] Add clear visual states for each supported layer.
- [ ] Add suitable hit and destruction feedback.

### Blocker Objective

- [ ] Add a collect/clear-blocker objective if required by MVP levels.
- [ ] Track destroyed pots or removed pot layers consistently.
- [ ] Display blocker progress in the HUD.
- [ ] Support a level containing collect-gem plus blocker goals.

## Automated Tests

- [ ] A normal match removes a mark beneath cleared gems.
- [ ] A cascade removes marks.
- [ ] Line and Burst effects remove marks.
- [ ] Adjacent matches damage Clay Pots once per resolution step.
- [ ] Special effects damage Clay Pots correctly.
- [ ] Clay Pots cannot be swapped.
- [ ] Gravity respects occupied blocker cells.
- [ ] Reshuffling preserves marks and blockers.
- [ ] Mixed objectives complete only when every goal is met.
- [ ] The final move can complete a blocker or mark objective.

## Manual Checkpoint

- [ ] Play a marks-only level.
- [ ] Play a Clay Pot-only level.
- [ ] Play a mixed collect-gem and Clay Pot level.
- [ ] Hit edge and corner pots with special gems.
- [ ] Verify each pot layer is visually readable.
- [ ] Verify the HUD accurately reports remaining goals.
- [ ] Complete both mechanics on the final move.

## Acceptance Criteria

- Clear Mark and Clay Pot mechanics are level-definition driven.
- Both mechanics work with matches, cascades, and existing special gems.
- Players can identify the mechanic and remaining goal without explanation.
- Mixed objectives complete reliably.
- No advanced blocker behavior is required by the implementation.

## Out Of Scope

- Locked Gem
- Woven Net
- Spreading Ink
- Shrine Gate
- Ananse Spinner
- Festival Cake
- Drop Relic and Path Clear goals

## Decisions To Record

- Clay Pot movement/gravity rules:
- Clay Pot damage rules:
- Mark visual treatment:
- Whether MVP tracks pot layers or destroyed pots:

## Completion

- [ ] Implementation complete
- [ ] Tests complete
- [ ] Manual checks complete
- [ ] Approved for Phase 4
