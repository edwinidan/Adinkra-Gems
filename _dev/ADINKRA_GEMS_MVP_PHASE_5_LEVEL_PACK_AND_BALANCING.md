# MVP Phase 5 - Level Pack And Balancing

## Goal

Turn the stable mechanics into a polished 10-15 level MVP experience.

The existing 30 levels should be treated as draft material. Quality, teaching,
and variety matter more than retaining all 30 for the first release.

## Recommended MVP Sequence

| Level | Main Purpose |
|---|---|
| 1 | Basic match and score tutorial |
| 2 | Collect one gem type |
| 3 | Teach cascades |
| 4 | Teach Line Gem |
| 5 | Easy mixed score and collection checkpoint |
| 6 | Teach Burst Gem |
| 7 | Teach Unity Orb |
| 8 | Introduce Clear Mark |
| 9 | Clear Mark with special-gem assistance |
| 10 | Introduce one-layer Clay Pots |
| 11 | Clay Pots plus collection |
| 12 | Teach Line + Line combination |
| 13 | Introduce two-layer Clay Pots |
| 14 | Mixed marks and Clay Pots |
| 15 | MVP finale using multiple learned mechanics |

Shipping 10 levels is acceptable if Levels 11-15 are not polished enough.

## Implementation Checklist

### Level Design

- [ ] Give every level one clear teaching or testing purpose.
- [ ] Avoid introducing more than one major mechanic at once.
- [ ] Add relief levels after difficult levels.
- [ ] Use board shape and available gem count to create variety.
- [ ] Place fixed starting specials only when teaching a mechanic.
- [ ] Avoid relying only on lower move counts for difficulty.
- [ ] Confirm every level has a sensible star curve.
- [ ] Add concise tutorial hints for first appearances.

### Difficulty Rhythm

- [ ] Levels 1-3 are highly forgiving.
- [ ] Levels 4-7 introduce specials without severe failure pressure.
- [ ] Levels 8-11 introduce board goals and blockers gradually.
- [ ] Levels 12-15 combine learned mechanics.
- [ ] At least two relief levels follow difficulty spikes.
- [ ] The final level feels challenging but fair.

### Lightweight Balancing Data

- [ ] Track attempts per level.
- [ ] Track wins per level.
- [ ] Calculate local pass rate.
- [ ] Track moves remaining on wins.
- [ ] Track approximate remaining goal progress on failures.
- [ ] Track reshuffle count.
- [ ] Track cascade count.
- [ ] Track completion time.
- [ ] Provide a developer-only way to inspect or export the data.
- [ ] Keep all tracking local for the MVP.

### Progress And Content

- [ ] Ensure level unlocks stop at the final shipped level.
- [ ] Ensure the map only presents shipped levels.
- [ ] Confirm stars and best scores save for every shipped level.
- [ ] Confirm progress reset covers every shipped level.
- [ ] Decide whether draft levels 16-30 are hidden or moved to a development pack.

## Suggested Tuning Targets

| Difficulty | Early Target Pass Rate |
|---|---:|
| Tutorial | 90-98% |
| Easy | 70-90% |
| Normal | 45-70% |
| Hard | 25-45% |

These targets are starting points. Small internal playtest samples are noisy, so
also review why players fail rather than tuning only from percentages.

## Automated Checks

- [ ] Every shipped level passes definition validation.
- [ ] Every generated start has at least one legal move.
- [ ] No shipped level starts with an unintended match.
- [ ] Star thresholds are ordered for every level.
- [ ] Every referenced tutorial and mechanic is supported.
- [ ] Progress save/reset covers the shipped level range.
- [ ] A smoke test can initialize every shipped level.

## Manual Playtest Checklist

- [ ] Complete every level from a fresh save.
- [ ] Replay every level for improved stars.
- [ ] Test deliberate failure on every goal type.
- [ ] Test the final move on representative levels.
- [ ] Record confusing goals or unreadable board states.
- [ ] Record levels with frequent reshuffles.
- [ ] Record levels usually failed with only one target remaining.
- [ ] Test on at least one lower-performance Android device.
- [ ] Test sound on/off and both supported tile themes.
- [ ] Verify the full flow from splash screen through the final level.

## Release Checkpoint

- [ ] All automated tests pass.
- [ ] `flutter analyze` has no errors or gameplay-affecting warnings.
- [ ] Android debug build succeeds.
- [ ] Android release build succeeds.
- [ ] No known progression blockers remain.
- [ ] No level is impossible under its configured rules.
- [ ] Text and controls fit supported screen sizes.
- [ ] Save data survives app restart.
- [ ] A clean-install playthrough is complete.

## Acceptance Criteria

- The MVP contains 10-15 polished, ordered levels.
- Each mechanic is introduced before it is tested under pressure.
- Difficulty rises with intentional relief points.
- Local balancing data can guide later tuning.
- The complete Android gameplay flow is stable enough for closed testing.

## Out Of Scope

- Expanding to 120 levels
- Live analytics or remote telemetry
- Ads, purchases, lives, or economy
- Boosters
- Seasonal content
- Advanced blockers and objectives

## Decisions To Record

- Final shipped level count:
- Draft-level storage approach:
- Final difficulty rhythm:
- Local balancing-data format:
- Closed-testing entry criteria:

## Completion

- [ ] Level pack complete
- [ ] Automated checks complete
- [ ] Full manual playthrough complete
- [ ] Android build verification complete
- [ ] MVP approved for closed testing
