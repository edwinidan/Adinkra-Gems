# Adinkra Gems — Technical Product Requirements Document (PRD)

**Project Name:** Adinkra Gems  
**Document Type:** Technical PRD / Game Design + Implementation Specification  
**Target Platform:** Android first, with future iOS support possible  
**Primary Stack:** Flutter + Flame  
**Current Product Stage:** Pre-development planning for first playable MVP  
**Related Existing Game:** Adinkra Tiles, currently in Google Play closed testing  
**Main Inspiration:** Candy Crush-style match-3 puzzle gameplay, redesigned with Adinkra/Ghanaian identity  
**Visual Direction:** Bright, colorful, glossy crystal/gem tiles with embossed Adinkra symbols  
**Document Purpose:** Define the gameplay, visuals, architecture, MVP scope, technical systems, screens, level rules, and implementation priorities before development begins.

---

## 1. Executive Summary

Adinkra Gems is a colorful match-3 puzzle game inspired by the gameplay feel of Candy Crush-style casual puzzle games, but built around a unique Ghanaian/Adinkra identity.

The game uses a grid-based board where players swap adjacent gem tiles to create matches of 3 or more. Matched tiles disappear with polished visual effects such as small shakes, pop animations, particle bursts, floating scores, tiny sound effects, and bouncing cascades. The player completes level objectives such as reaching a target score or collecting a specific number of tile types before running out of moves or time.

The game will be built using Flutter + Flame:

- Flutter handles app shell, screens, navigation, menus, settings, overlays, level map, local save, and platform integration.
- Flame handles the actual match-3 board, tile rendering, touch input, animations, particles, cascades, special tile effects, and game loop behavior.

The first playable version will include 10 levels, a home screen, level select map, win/lose flow, stars, local progress saving, special tiles, smooth match animations, and polished core gameplay. Boosters are intentionally excluded from the first playable version and will be added after the base game feels good.

---

## 2. Product Vision

### 2.1 Vision Statement

Adinkra Gems should feel like a polished, bright, satisfying, culturally inspired match-3 puzzle game where players match magical Adinkra gem tiles across short, replayable levels.

The player should understand the game immediately, but the visual identity should feel different from generic candy or jewel games.

### 2.2 Core Experience

The core player feeling should be:

> “I am matching colorful magical Adinkra gems, watching them pop, burst, fall, cascade, and unlock new levels.”

### 2.3 Desired Game Feel

The game should feel:

- Bright
- Smooth
- Satisfying
- Colorful
- Playful
- Magical
- Ghanaian-inspired
- Casual but polished
- Easy to understand
- Rewarding within the first 30 seconds

### 2.4 Product Positioning

Adinkra Tiles is calm, board-game-like, and more traditional.  
Adinkra Gems should be the more energetic, colorful, casual puzzle game in the same broader Adinkra game family.

Potential brand relationship:

> “From the creator of Adinkra Tiles comes Adinkra Gems.”

---

## 3. Goals and Non-Goals

## 3.1 MVP Goals

The MVP should prove that:

1. Matching colorful Adinkra gem tiles is fun.
2. The game feels smooth and polished from the beginning.
3. Flutter + Flame can support the desired animation, particles, and board logic.
4. A 10-level version can feel like a complete mini-game.
5. The visual style is strong enough to stand apart from generic match-3 games.
6. The game can later expand into worlds, boosters, ads, and more level mechanics.

## 3.2 First Playable Goals

The first playable version should include:

- 10 playable levels
- 8x8 match-3 board
- 6 gem tile types
- Valid-match-only swaps
- Automatic cascade resolution
- Automatic reshuffle when no valid moves remain
- Reach-score objectives
- Collect-specific-tile objectives
- Move-based levels
- Time-based levels
- Some levels with both moves and timer
- Special tiles:
  - Match 4 = row/column blast tile
  - Match 5 = color clear tile
  - L-shape/T-shape = bomb tile
- Home screen
- Level select map
- Game screen
- Win screen
- Lose screen
- Star rating system
- Local save progress
- Basic sound effects
- Smooth animations and particle effects

## 3.3 Non-Goals for First Playable Version

The following should not be included in the first playable version:

- Real-money purchases
- Ads
- Rewarded ads
- Daily rewards
- Lives system
- Online accounts
- Cloud save
- Leaderboards
- Shop
- Booster inventory
- Complex blockers such as chocolate, jelly, portals, locked chains, bombs with countdowns, etc.
- Hundreds of levels
- Multiple worlds
- Multiplayer
- Social sharing
- Remote config
- Seasonal events

These can be considered after the game’s core loop feels good.

---

## 4. Target Audience

### 4.1 Primary Audience

- Casual mobile puzzle players
- Players who enjoy Candy Crush-style gameplay
- Players who like colorful, satisfying, short-session games
- Ghanaian/African users who may appreciate the Adinkra theme
- General Android users looking for a simple puzzle game

### 4.2 Session Length

Expected session length:

- Short session: 1–3 minutes
- Normal session: 5–10 minutes
- Replay session: player repeats levels to improve stars

### 4.3 Player Skill Level

The game should be accessible to:

- First-time match-3 players
- Casual puzzle players
- Users familiar with Candy Crush-like rules
- Younger and older players

The first 10 levels should not be too difficult. They should teach the core mechanics and show off the effects.

---

## 5. Game Identity

## 5.1 Name

Current chosen name:

**Adinkra Gems**

This name fits the crystal/gem tile direction and avoids sounding too close to Candy Crush.

## 5.2 Theme

The theme is:

> Magical Adinkra symbols turned into colorful crystal gems.

The game should not look like a direct Candy Crush clone. The inspiration is gameplay structure and game feel, not visual copying.

## 5.3 Cultural Identity

The game uses Adinkra symbols as the main tile identity.

The symbols should be treated respectfully and beautifully. They are not just decorative shapes; they are part of the game’s visual and cultural identity.

For the first playable version, the symbols can be used mainly as tile identifiers. Later versions can include short symbol meanings, unlockable symbol cards, or cultural information.

---

## 6. Visual Style

## 6.1 Tile Mockup Reference

The attached first mockup tile shows the preferred direction:

- Glossy crystal/gem material
- Rounded square tile shape
- Bright golden color
- Embossed Adinkra symbol
- Strong highlights
- Soft bevels
- Chunky casual-game silhouette
- High readability
- Polished mobile puzzle feel

This mockup should be used as the style anchor for all first tile designs.

## 6.2 Tile Style Requirements

Each tile should have:

- Rounded square gem shape
- Glossy highlight
- Soft bevel/depth
- Embossed or engraved Adinkra symbol
- Strong readable color
- Slight inner shadow around symbol
- Outer shine/highlight
- Consistent lighting direction
- Consistent perspective
- Transparent background asset
- Clear silhouette at small mobile sizes

## 6.3 Tile Color Set

The first playable version should use 6 tile colors:

1. Gold / Yellow
2. Red
3. Green
4. Blue
5. Purple
6. Orange

The player should be able to recognize tile types primarily by color and secondarily by symbol.

## 6.4 Suggested Starting Adinkra Symbols

The first 6 symbols should be readable and recognizable.

Recommended first set:

1. Gye Nyame
2. Sankofa
3. Adinkrahene
4. Akoma
5. Dwennimmen
6. Fawohodie

These can be adjusted depending on asset quality and symbol readability.

## 6.5 Tile Asset Rules

Each tile type should have:

- Normal tile asset
- Selected/highlight state, either separate asset or runtime glow
- Optional special-tile overlay compatibility
- Particle color mapping
- Small icon version for UI objective display

Recommended asset naming:

```text
assets/images/tiles/gem_gold_gye_nyame.png
assets/images/tiles/gem_red_sankofa.png
assets/images/tiles/gem_green_adinkrahene.png
assets/images/tiles/gem_blue_akoma.png
assets/images/tiles/gem_purple_dwennimmen.png
assets/images/tiles/gem_orange_fawohodie.png
```

## 6.6 Special Tile Visual Direction

### Row/Column Blast Tile

Should be visually distinct from normal tile.

Possible visual indicators:

- Horizontal glowing stripe for row blast
- Vertical glowing stripe for column blast
- Sparkle line overlay
- Brighter border

### Color Clear Tile

Should feel powerful.

Possible visual indicators:

- Rainbow gem
- White-gold glowing Adinkra symbol
- Rotating sparkle aura
- Multicolor shine

### Bomb Tile

Should feel explosive but still gem-like.

Possible visual indicators:

- Circular glowing core
- Pulse effect
- Cracked-gem energy lines
- Spark aura

## 6.7 Board Visual Style

The board should contrast with the colorful gems.

Recommended board background options:

- Deep royal blue
- Dark warm purple
- Deep emerald green
- Dark wooden/gold frame with subtle kente pattern
- Soft glowing board cells

The board should not be too visually busy. The gems are the star of the screen.

## 6.8 UI Style Direction

UI should use:

- Rounded panels
- Gold accents
- Soft green or blue highlights
- Kente-inspired subtle trim
- Big readable numbers
- Friendly casual-game buttons
- Bright win effects
- Clean objective icons

---

## 7. Core Gameplay

## 7.1 Core Loop

The main gameplay loop:

1. Player starts a level.
2. Board is filled with gem tiles.
3. Player swaps two adjacent tiles.
4. Swap is allowed only if it creates a match.
5. Matching tiles pop and disappear.
6. Particles and score popups play.
7. Tiles above fall down.
8. New tiles spawn from top.
9. Cascades continue until no matches remain.
10. Objective progress updates.
11. Player wins if objectives are completed before limits run out.
12. Player loses if moves or time run out before objectives are completed.
13. Stars are calculated.
14. Progress is saved.
15. Next level unlocks.

## 7.2 Swap Rule

The player can only swap adjacent tiles if the swap creates a match.

If the move does not create a match:

- Swap animation should start briefly.
- Tiles should bounce back.
- Move count should not decrease.
- No match effects should trigger.
- Optional invalid sound can play.

## 7.3 Adjacency Rule

Only orthogonally adjacent tiles can be swapped:

- Left
- Right
- Up
- Down

Diagonal swapping is not allowed.

## 7.4 Match Rule

A match is created when 3 or more same-type tiles align horizontally or vertically.

Match types:

- Match 3
- Match 4
- Match 5
- L-shape
- T-shape
- Multiple simultaneous matches

## 7.5 Cascades

Cascades continue automatically until the board becomes stable.

During cascade resolution:

- Player input is disabled.
- Matches are detected.
- Tiles are removed.
- Tiles fall.
- New tiles spawn.
- New matches are checked.
- This repeats until there are no matches.

After the board is stable:

- Input is enabled again.
- Valid moves are checked.
- If no valid moves remain, reshuffle begins.

## 7.6 No Valid Moves Rule

If there are no valid moves:

1. Show message: “No moves left!”
2. Show message: “Reshuffling...”
3. Animate board shuffle.
4. Ensure the new board has at least one valid move.
5. Ensure the new board does not start with automatic matches unless intentionally allowed.
6. Resume player input.

## 7.7 Initial Board Generation

Initial board must satisfy:

- No automatic matches at level start.
- At least one valid move exists.
- Tile distribution feels fair.
- Board uses the tile types allowed by the level config.

Algorithm requirement:

1. Fill board tile by tile.
2. For each cell, choose a tile that does not create an immediate 3-match.
3. After board is filled, check for at least one valid move.
4. If no valid move exists, regenerate or reshuffle.
5. Return valid board.

---

## 8. Board System

## 8.1 MVP Board Size

Primary board size:

```text
8 columns x 8 rows
```

This should be the default for all first 10 levels.

## 8.2 Future Board Variation

Future versions may support:

- 7x7 board
- 8x8 board
- 9x9 board
- Irregular board shapes
- Blocked cells
- Holes
- Portals

For the first playable version, keep all boards rectangular 8x8.

## 8.3 Coordinate System

Use a grid coordinate system:

```dart
class GridPosition {
  final int row;
  final int col;
}
```

Recommended convention:

- row 0 is top
- row increases downward
- col 0 is left
- col increases rightward

## 8.4 Board Model

The board model should store logical tile state separately from Flame visual components.

Example:

```dart
class BoardModel {
  final int rows;
  final int cols;
  final List<List<TileModel?>> cells;
}
```

Each cell can hold:

- Normal tile
- Special tile
- Empty/null during cascades
- Future blockers later

## 8.5 Board State Machine

The board should have explicit states:

```dart
enum BoardState {
  idle,
  swapping,
  resolvingMatches,
  removingTiles,
  cascading,
  spawning,
  reshuffling,
  levelComplete,
  levelFailed,
}
```

Player input should only be allowed in `BoardState.idle`.

---

## 9. Tile System

## 9.1 Tile Type

A tile type represents the normal matchable identity of a gem.

Example:

```dart
enum GemType {
  goldGyeNyame,
  redSankofa,
  greenAdinkrahene,
  blueAkoma,
  purpleDwennimmen,
  orangeFawohodie,
}
```

## 9.2 Special Type

Special tiles should be represented separately from normal tile color/type.

Example:

```dart
enum SpecialGemType {
  none,
  horizontalBlast,
  verticalBlast,
  colorClear,
  bomb,
}
```

## 9.3 Tile Model

Example:

```dart
class TileModel {
  final String id;
  final GemType gemType;
  final SpecialGemType specialType;
  GridPosition position;
}
```

## 9.4 Tile Component

The Flame component should be visual only.

Responsibilities:

- Render tile sprite
- Render special overlay
- Animate movement
- Animate selection
- Animate pop/removal
- Animate shake
- Play glow effects
- Expose position conversion between grid and screen

The TileComponent should not decide level rules, score, match logic, or win/lose.

---

## 10. Match Detection

## 10.1 Match Finder Responsibilities

The MatchFinder should:

- Scan rows for horizontal matches.
- Scan columns for vertical matches.
- Detect match length.
- Detect L-shape and T-shape matches.
- Return match groups.
- Mark which match should create a special tile.
- Avoid double-counting tiles where possible.

## 10.2 Match Group

Example:

```dart
class MatchGroup {
  final List<GridPosition> positions;
  final MatchShape shape;
  final GemType gemType;
  final GridPosition specialSpawnPosition;
}
```

## 10.3 Match Shape

Example:

```dart
enum MatchShape {
  line3,
  line4Horizontal,
  line4Vertical,
  line5Horizontal,
  line5Vertical,
  lShape,
  tShape,
}
```

## 10.4 Special Tile Creation Rules

### Match 3

- Clears matched tiles.
- No special tile is created.

### Match 4

Creates row or column blast tile.

Decision:

- Horizontal match 4 creates horizontal blast tile.
- Vertical match 4 creates vertical blast tile.

Alternative future rule:
- Direction can be based on swipe direction.

For MVP, keep it simple:
- Match orientation determines blast direction.

### Match 5

Creates Color Clear Gem.

- Match 5 horizontally or vertically creates a color clear tile.
- Color Clear Gem should appear at the tile position involved in the player’s swap if possible.
- If not possible, use the center tile of the match group.

### L-shape / T-shape

Creates Bomb Gem.

- Bomb Gem clears a 3x3 area when activated.
- Bomb should appear at the intersection/corner of the L/T match where possible.

---

## 11. Special Tile Activation

## 11.1 Activation Rule

For MVP:

> Special tiles activate when matched or swapped as part of a valid move.

They should not be tap-to-activate in the first version.

## 11.2 Horizontal Blast

Effect:

- Clears entire row of the tile.

Visual:

- Horizontal light beam
- Particles across the row
- Tiles pop left-to-right or center-out

## 11.3 Vertical Blast

Effect:

- Clears entire column of the tile.

Visual:

- Vertical light beam
- Particles along column
- Tiles pop top-to-bottom or center-out

## 11.4 Color Clear Gem

Effect:

- When swapped with a normal tile, clears all tiles of that normal tile’s GemType.

Example:

- Swap Color Clear Gem with blue Akoma.
- All blue Akoma tiles clear from the board.

Visual:

- Pulse from the color clear tile
- Small lightning/spark links to matching tiles
- All matching tiles pop with particles

## 11.5 Bomb Gem

Effect:

- Clears 3x3 area around itself.

Visual:

- Expanding circular shockwave
- Burst particles
- Screen/board micro-shake
- Nearby tiles pop

## 11.6 Special Tile Combinations

For the first playable version, special tile combinations can be simplified.

Recommended MVP handling:

- If two special tiles are swapped together, activate both sequentially.
- Full advanced combo logic can be added later.

Future advanced combos:

- Blast + Blast = row and column clear
- Bomb + Bomb = larger radius
- Color Clear + normal special = convert all of that color into special effect
- Color Clear + Color Clear = clear board

These are not required for the first playable version.

---

## 12. Level Objectives

## 12.1 MVP Objective Types

Only two objective types are required:

1. Reach target score
2. Collect a number of specific tile types

## 12.2 Score Objective

Player must reach a target score before moves/time run out.

Example:

```dart
class ScoreObjective {
  final int targetScore;
}
```

## 12.3 Collect Objective

Player must collect a specific number of one or more gem types.

Example:

```dart
class CollectObjective {
  final GemType gemType;
  final int targetCount;
  int currentCount;
}
```

A tile counts as collected when:

- It is cleared by a normal match.
- It is cleared by cascade.
- It is cleared by special tile effect.

## 12.4 Combined Objectives

The system should support multiple objectives in one level.

Example:

- Reach 3,500 points and collect 15 orange tiles.

The level is won only when all objectives are completed.

## 12.5 Objective UI

The game screen should show:

- Current level number
- Objective icons
- Target counts
- Progress counters
- Score
- Star progress
- Moves and/or timer

Example objective display:

```text
Collect: Gold 8/12
Score: 1,250 / 2,000
Moves: 14
```

---

## 13. Level Limits

## 13.1 Move-Based Levels

In move-based levels:

- Each valid swap consumes 1 move.
- Invalid swaps do not consume moves.
- Cascades do not consume extra moves.
- Special tile chain reactions do not consume extra moves.
- Player loses if moves reach 0 and objectives are not complete.

## 13.2 Time-Based Levels

In time-based levels:

- Timer starts when the board is ready.
- Timer pauses during win/lose overlay.
- Timer may continue during cascades unless the game design chooses to pause it.
- Recommended for MVP: timer continues during cascades for simplicity and urgency.
- Player loses if timer reaches 0 and objectives are not complete.

## 13.3 Levels With Both Moves and Timer

Some levels can have both moves and time.

Rule:

> Player loses when either moves reach 0 or time reaches 0 before objectives are complete.

The objective must be completed before either limit expires.

## 13.4 Recommended Limit Handling

When a player completes objectives:

- Immediately stop timer.
- Stop consuming moves.
- Finish current cascade if necessary or trigger win after resolution.
- Show win screen.

If moves/time run out during a cascade:

- Let the cascade finish.
- Check if objectives completed during final cascade.
- If completed, player wins.
- If not completed, player loses.

This avoids unfair losses during automatic chain reactions.

---

## 14. Scoring System

## 14.1 Base Scoring

Recommended MVP scoring:

```text
Match 3 = 60 points
Match 4 = 120 points
Match 5 = 250 points
L/T match = 300 points
Each special-cleared tile = 20 points
```

## 14.2 Cascade Multiplier

Cascades should feel rewarding.

Recommended multiplier:

```text
Initial match = x1.0
Second cascade = x1.5
Third cascade = x2.0
Fourth cascade and above = x2.5
```

## 14.3 Score Popup

When points are awarded:

- Floating number appears near match center.
- Number moves upward.
- Number fades out.
- Larger cascades can have bigger number scale.

## 14.4 Star Score

Each level has:

- 1-star threshold
- 2-star threshold
- 3-star threshold

The 1-star threshold can be the minimum target score for score-based levels.

For collect-based levels, stars still depend on score.

---

## 15. Star System

## 15.1 Star Rules

At the end of a won level:

```text
Score >= 3-star threshold = 3 stars
Score >= 2-star threshold = 2 stars
Score >= 1-star threshold = 1 star
```

If a level is won but score is below 1-star threshold, award 1 star minimum.

## 15.2 Stored Star Data

The game should store the best star rating achieved per level.

If the player replays a level and gets fewer stars, keep the higher previous star count.

## 15.3 Star UI

Level select should show:

- Locked levels
- Unlocked levels
- Completed levels
- Star count under each completed level

Win screen should show:

- Score
- Stars earned
- Objective completion
- Next button
- Replay button
- Level map button

---

## 16. First 10 Levels

## 16.1 Level Design Principles

The first 10 levels should:

- Teach basic matching
- Introduce collection objectives
- Introduce scoring
- Introduce timed pressure
- Introduce combined objectives
- Encourage special tile use
- Stay forgiving
- Feel rewarding
- Avoid blockers and complex mechanics

## 16.2 Recommended Level Table

| Level | Objective | Limit | Purpose |
|---|---|---:|---|
| 1 | Reach 1,000 points | 20 moves | Teach basic matching |
| 2 | Collect 12 gold tiles | 22 moves | Introduce collect objective |
| 3 | Reach 1,800 points | 20 moves | Introduce cascades and scoring |
| 4 | Collect 15 blue tiles | 24 moves | Focused tile collection |
| 5 | Reach 2,500 points | 60 seconds | Introduce timed level |
| 6 | Collect 12 red tiles and 12 green tiles | 25 moves | Multi-tile collection |
| 7 | Reach 3,000 points | 22 moves | Encourage special tiles |
| 8 | Collect 20 purple tiles | 75 seconds | Timed collect level |
| 9 | Reach 3,500 points and collect 15 orange tiles | 28 moves | Combined objective |
| 10 | Reach 5,000 points | 30 moves + 90 seconds | First mini challenge |

## 16.3 Example Level Config Structure

```dart
class LevelConfig {
  final int levelNumber;
  final int rows;
  final int cols;
  final List<GemType> availableGemTypes;
  final int? moveLimit;
  final int? timeLimitSeconds;
  final List<LevelObjective> objectives;
  final StarThresholds starThresholds;
}
```

## 16.4 Suggested Star Thresholds

| Level | 1 Star | 2 Stars | 3 Stars |
|---|---:|---:|---:|
| 1 | 1,000 | 1,500 | 2,200 |
| 2 | 1,000 | 1,600 | 2,400 |
| 3 | 1,800 | 2,600 | 3,500 |
| 4 | 1,600 | 2,400 | 3,400 |
| 5 | 2,500 | 3,500 | 5,000 |
| 6 | 2,200 | 3,200 | 4,500 |
| 7 | 3,000 | 4,200 | 5,800 |
| 8 | 2,800 | 4,000 | 5,500 |
| 9 | 3,500 | 5,000 | 6,800 |
| 10 | 5,000 | 7,000 | 9,000 |

These values should be playtested and adjusted.

---

## 17. Game Feel and Animation

## 17.1 Animation Goals

Animations should make the game feel polished without slowing gameplay too much.

The player should feel:

- Swaps are responsive.
- Matches are satisfying.
- Cascades are exciting.
- Special tiles feel powerful.
- Win moments feel rewarding.
- Lose moments feel clear but not harsh.

## 17.2 Recommended Timing

```text
Swap animation: 120–180ms
Invalid swap bounce-back: 120ms
Tile selected pulse: continuous subtle effect
Tile pop before disappearing: 120ms
Particle burst: 300–500ms
Tile fall: 200–350ms depending on distance
Score popup: 500–700ms
Special tile blast: 350–700ms depending on effect
Board reshuffle: 700–1000ms
Win celebration: 1000–1800ms
```

## 17.3 Match Animation Sequence

When a match happens:

1. Matched tiles shake slightly.
2. Tiles scale up slightly.
3. Tiles pop/disappear.
4. Particle burst plays.
5. Score popup appears.
6. Objective counters update.
7. Tiles above fall with bounce.
8. New tiles spawn from top.

## 17.4 Tile Falling

Tiles should fall vertically into empty cells.

Fall movement:

- Smooth downward motion
- Slight bounce at landing
- Delay based on row distance if needed
- New tiles spawn just above the board

## 17.5 Board Shake

Use small shake only for:

- Bomb tile activation
- Large special effect
- Big cascade
- Win celebration

Avoid shaking too much during normal matches.

## 17.6 Particles

Particle effects should use the cleared tile’s color.

For example:

- Gold tile = gold sparkles
- Blue tile = blue sparkles
- Red tile = red/orange sparkles

Particle effects should be visible but not overwhelming.

## 17.7 Sound Effects

First playable sound list:

- Button tap
- Tile select
- Valid swap
- Invalid swap
- Match pop
- Cascade sparkle
- Special tile created
- Row/column blast
- Bomb explosion
- Color clear activation
- Win sound
- Lose sound

Music is optional for first playable. If added, it should be soft, bright, and loopable.

---

## 18. Screen Flow

## 18.1 Required Screens

First playable version requires:

1. Splash Screen
2. Home Screen
3. Level Select Map
4. Game Screen
5. Win Screen
6. Lose Screen
7. Settings Screen

## 18.2 Splash Screen

Purpose:

- Show app logo/name.
- Load assets.
- Initialize services.
- Navigate to home.

Recommended content:

- Adinkra Gems logo
- Glowing gem background
- Short loading animation

## 18.3 Home Screen

Buttons:

- Play
- Settings
- About

Possible visual elements:

- Game title
- Floating gem tiles
- Bright Ghanaian-inspired background
- Subtle particles

## 18.4 Level Select Map

First version should have a simple map, not a complex world system.

Requirements:

- 10 level nodes
- Level 1 unlocked by default
- Next level unlocks after win
- Locked levels visually disabled
- Completed levels show stars
- Current highest unlocked level highlighted
- Tap unlocked level to play

Recommended map style:

- Curved path
- Bright Adinkra/Ghanaian-inspired background
- Gold level circles
- Star display under completed nodes

## 18.5 Game Screen

Main sections:

### Top HUD

- Level number
- Objective display
- Score
- Star progress bar
- Moves counter and/or timer

### Middle

- Flame GameWidget containing board

### Bottom

- Optional footer area
- Booster placeholder can be hidden for first playable

## 18.6 Win Screen

Show:

- “Level Complete!”
- Stars earned
- Final score
- Objectives completed
- Next Level button
- Replay button
- Map button

## 18.7 Lose Screen

Show:

- “Out of moves!” or “Time’s up!”
- Score
- Objective progress
- Retry button
- Map button

## 18.8 Settings Screen

Settings required for first playable:

- Sound on/off
- Music on/off
- Reset progress button, optional/debug-only
- About game

---

## 19. Save and Progress System

## 19.1 Save Type

For MVP:

```text
Local save only
```

Recommended storage:

- SharedPreferences for simple MVP
- Hive if a more scalable structure is desired

For first playable, SharedPreferences is enough.

## 19.2 Data to Save

Save:

- Highest unlocked level
- Best score per level
- Best stars per level
- Sound enabled
- Music enabled
- Has completed tutorial/first level intro, if tutorials are added
- Last played level, optional

## 19.3 Save Model

Example:

```dart
class PlayerProgress {
  final int highestUnlockedLevel;
  final Map<int, int> bestScores;
  final Map<int, int> bestStars;
  final bool soundEnabled;
  final bool musicEnabled;
}
```

## 19.4 Unlock Rule

- Level 1 unlocked by default.
- Winning level N unlocks level N+1.
- Replaying completed levels is allowed.
- Losing does not lock anything.
- Stars update only if new star count is higher than saved star count.
- Best score updates only if new score is higher.

---

## 20. Tutorial and Onboarding

## 20.1 First Playable Tutorial Scope

A full tutorial is not required, but Level 1 should teach through simple UI hints.

Recommended Level 1 hints:

- “Swap gems to match 3!”
- Highlight a possible move.
- After first match: “Great! Match more to score points.”
- After special tile appears: “Special gems clear more tiles!”

## 20.2 Tutorial Technical Approach

Use lightweight overlays controlled by Flutter or Flame.

For the first version:

- Keep tutorial minimal.
- Do not block too many interactions.
- Store whether the first hint has been shown.

---

## 21. Architecture Overview

## 21.1 High-Level Architecture

```text
Flutter App
│
├── Screens
│   ├── Splash
│   ├── Home
│   ├── Level Select
│   ├── Game Screen
│   ├── Settings
│
├── State / Services
│   ├── Progress Service
│   ├── Audio Service
│   ├── Analytics Service, later
│   ├── Settings Service
│
└── Flame Game
    ├── AdinkraGemsGame
    ├── BoardController
    ├── BoardModel
    ├── MatchFinder
    ├── CascadeResolver
    ├── LevelController
    ├── Components
    │   ├── BoardComponent
    │   ├── TileComponent
    │   ├── ScorePopupComponent
    │   ├── ParticleEffectComponent
    │
    └── Effects
        ├── MatchEffect
        ├── BlastEffect
        ├── BombEffect
        ├── ColorClearEffect
```

## 21.2 Separation of Concerns

### Flutter should handle:

- Routing
- Screens
- Menus
- Settings
- Save data
- Win/lose overlays
- Level selection
- App lifecycle
- Platform services

### Flame should handle:

- Board rendering
- Tile sprites
- Board input
- Drag/swipe detection
- Tile movement
- Match animations
- Particle effects
- Cascade animations
- Special tile effects

### Pure Dart game logic should handle:

- Board data
- Match detection
- Move validation
- Cascade calculation
- Objective progress
- Score calculation
- Level config parsing

Pure game logic should be testable without rendering.

---

## 22. Recommended Folder Structure

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

---

## 23. Technical Systems

## 23.1 Board Generator

Responsibilities:

- Generate board for level.
- Use level’s available gem types.
- Avoid starting matches.
- Ensure at least one valid move.
- Provide regenerated board if invalid.

## 23.2 Move Validator

Responsibilities:

- Check if two selected tiles are adjacent.
- Simulate swap.
- Check if swap produces match.
- Return valid/invalid.

## 23.3 Match Finder

Responsibilities:

- Find horizontal matches.
- Find vertical matches.
- Merge overlapping matches.
- Detect L/T shapes.
- Identify match type.
- Provide special tile spawn location.

## 23.4 Cascade Resolver

Responsibilities:

- Remove matched tiles.
- Drop tiles into empty cells.
- Spawn new tiles.
- Repeat until stable.
- Return animation instructions to Flame.

## 23.5 Level Controller

Responsibilities:

- Track current level.
- Track moves.
- Track timer.
- Track objectives.
- Check win/lose.
- Notify UI of changes.

## 23.6 Score System

Responsibilities:

- Calculate base points.
- Apply cascade multiplier.
- Add special clear points.
- Trigger score popup.

## 23.7 Effects Manager

Responsibilities:

- Spawn particles.
- Trigger tile shake/pop.
- Trigger score popup.
- Trigger special effects.
- Trigger board shake.
- Coordinate effect timing.

## 23.8 Progress Service

Responsibilities:

- Load local progress.
- Save unlocked levels.
- Save stars.
- Save best scores.
- Save settings.

## 23.9 Audio Service

Responsibilities:

- Preload sound effects.
- Play one-shot SFX.
- Respect sound enabled setting.
- Later handle background music.

---

## 24. Flutter + Flame Integration

## 24.1 Game Screen Integration

The game screen should host Flame inside Flutter.

Example:

```dart
GameWidget(
  game: AdinkraGemsGame(levelConfig: selectedLevel),
)
```

Flutter can overlay HUD and buttons above the Flame board using Stack.

Example layout:

```dart
Stack(
  children: [
    GameWidget(game: game),
    Positioned(top: 0, child: GameHud(...)),
    if (showWin) WinOverlay(...),
    if (showLose) LoseOverlay(...),
  ],
)
```

## 24.2 Communication Between Flame and Flutter

Use callbacks, ValueNotifier, ChangeNotifier, Riverpod, or another state mechanism.

Game should notify Flutter when:

- Score changes
- Moves change
- Timer changes
- Objective progress changes
- Level is won
- Level is lost
- Stars are earned

For MVP, a simple `ValueNotifier<GameUiState>` is enough.

## 24.3 Avoiding Overcoupling

Do not let Flutter UI directly modify internal board cells.

Use commands:

- startLevel()
- restartLevel()
- pauseGame()
- resumeGame()
- handleSwap()
- quitLevel()

---

## 25. Input Handling

## 25.1 Input Method

The game should support:

- Tap tile then tap adjacent tile
- Swipe tile toward adjacent tile

For first playable, implement swipe first if possible. Tap-tap can be added for accessibility.

## 25.2 Input Flow

1. Player touches tile.
2. Game detects selected tile.
3. Player drags/swipes toward direction or taps adjacent tile.
4. Game identifies target tile.
5. Board checks if move is valid.
6. If valid:
   - Consume move.
   - Animate swap.
   - Resolve matches.
7. If invalid:
   - Animate bounce-back.
   - Do not consume move.

## 25.3 Input Lock

Input must be locked during:

- Swap animation
- Match resolution
- Tile removal
- Cascade
- Spawn
- Reshuffle
- Win/lose sequence
- Pause

---

## 26. Performance Requirements

## 26.1 Target Devices

Primary target:

- Android mobile phones
- Mid-range Android devices should run smoothly

## 26.2 Performance Target

Target:

```text
60 FPS on common Android devices
```

## 26.3 Performance Guidelines

- Preload tile sprites.
- Use sprite sheets later if asset count grows.
- Reuse particles where practical.
- Avoid excessive overdraw.
- Keep board effects efficient.
- Avoid creating too many objects per frame.
- Use Flame components responsibly.
- Keep all heavy board logic outside render loops.
- Avoid doing expensive match checks every frame; only check after relevant actions.

## 26.4 Asset Size Considerations

Tile assets should be optimized.

Recommended:

- Use PNG/WebP as appropriate.
- Keep tile images clean and not unnecessarily huge.
- Consider 512x512 source images, scaled down in-game.
- Use consistent dimensions.
- Compress assets before release.

---

## 27. Platform and Build Requirements

## 27.1 Flutter

Use current stable Flutter.

## 27.2 Dependencies

Expected dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flame: latest_stable
  shared_preferences: latest_stable
  audioplayers: latest_stable
```

Potential alternatives:

- flame_audio instead of audioplayers
- hive instead of shared_preferences
- flutter_riverpod/provider for state management
- firebase_core/firebase_crashlytics/firebase_analytics later

## 27.3 Android Requirements

For first playable internal testing:

- Android package name should be chosen carefully.
- App icon and splash can be basic but branded.
- Internet permission is not required unless Firebase/ads are added.
- No ads for first playable.
- No login.
- No user data collection except optional analytics later.

---

## 28. Analytics and Crash Reporting

## 28.1 First Playable

For local development, analytics is optional.

If Firebase is already comfortable from Adinkra Tiles, it can be added early.

## 28.2 Recommended Analytics Events Later

When analytics is added, track:

- level_start
- level_complete
- level_fail
- level_retry
- move_made
- special_tile_created
- special_tile_used
- reshuffle_triggered
- stars_earned
- settings_sound_changed
- settings_music_changed

## 28.3 Crashlytics

Crashlytics is recommended before Play Store testing.

Track non-fatal errors for:

- asset loading failures
- level config parsing failures
- save/load failures
- unexpected board state
- animation/effect exceptions

---

## 29. Monetization Plan, Later

## 29.1 Not in First Playable

No monetization should be implemented in the first playable version.

## 29.2 Future Monetization Options

Possible later additions:

- Rewarded ad for extra moves
- Rewarded ad for extra time
- Rewarded ad for free booster
- Interstitial ad after selected levels
- Remove ads purchase
- Booster packs
- Starter pack
- Extra lives system

## 29.3 Suggested Future Order

1. First make the game fun.
2. Add basic boosters.
3. Add rewarded ads.
4. Add optional in-app purchases.
5. Add daily rewards/lives only if needed.

---

## 30. Boosters, Later

## 30.1 Booster Decision

Boosters are not part of the first playable version.

They will be added after:

- core board works
- special tiles work
- 10 levels are playable
- save/progress works
- game feel is satisfying

## 30.2 Future Booster Types

Recommended future boosters:

1. Hammer  
   - Destroys one selected tile.

2. Shuffle  
   - Reshuffles board manually.

3. Cross Blast  
   - Clears one row and column.

4. Extra Moves  
   - Adds 5 moves.

5. Extra Time  
   - Adds 30 seconds.

6. Color Remove  
   - Removes all of one selected tile type.

## 30.3 Code Preparation

Even though boosters are later, the architecture should allow them.

Avoid hardcoding board changes in UI. Use action methods such as:

```dart
boardController.applyBooster(BoosterType.hammer, targetPosition);
```

---

## 31. Edge Cases

## 31.1 Invalid Swap

- Animate swap forward then back.
- No move consumed.
- No score awarded.
- Input re-enabled.

## 31.2 Level Complete During Cascade

If objectives are completed during cascade:

- Allow cascade to complete or stop after current resolution.
- Stop timer.
- Show win overlay.

Recommended MVP behavior:
- Complete current cascade, then show win.

## 31.3 Moves Run Out During Cascade

If final valid move triggers cascade and objectives complete during cascade:

- Player wins.

If cascade ends and objectives are incomplete:

- Player loses.

## 31.4 Timer Runs Out During Cascade

If timer reaches zero during cascade:

- Let current cascade finish.
- Check objectives.
- If complete, win.
- If incomplete, lose.

## 31.5 No Valid Moves After Cascade

- Automatically reshuffle.
- Do not consume move.
- Show reshuffle message.
- Ensure reshuffled board has at least one valid move.

## 31.6 Special Tile Created in Match

When a match creates a special tile:

- The special tile should remain at the preferred spawn position.
- Other matched tiles clear.
- The created special tile should not immediately clear unless part of a separate cascade rule.
- Keep behavior simple and predictable.

## 31.7 Multiple Matches at Once

If one swap creates multiple matches:

- Clear all match groups.
- Award score for all groups.
- Create special tile for highest-priority match only, or one per independent match if implementation is stable.

Recommended MVP:
- Create only one special tile from the player-triggered main match.
- Clear all other matched tiles normally.

## 31.8 Special Tile in a Match

If a special tile is included in a normal match:

- Activate the special tile.
- Clear the match group.
- Apply special effect.
- Score all cleared tiles.

---

## 32. Testing Requirements

## 32.1 Unit Tests

Pure Dart logic should be testable.

Test:

- Board generation produces no starting matches.
- Board generation produces valid moves.
- Move validator rejects non-adjacent swaps.
- Move validator rejects swaps with no match.
- Move validator accepts valid swaps.
- MatchFinder detects horizontal match 3.
- MatchFinder detects vertical match 3.
- MatchFinder detects match 4.
- MatchFinder detects match 5.
- MatchFinder detects L-shape.
- MatchFinder detects T-shape.
- CascadeResolver drops tiles correctly.
- Objective system updates collect progress.
- Score system applies cascade multipliers.
- Level win/lose logic works.
- Save system stores and loads progress.

## 32.2 Manual Tests

Manual playtesting checklist:

- Level 1 can be completed.
- Level 2 collect objective works.
- Timed level counts down properly.
- Moves decrease only for valid swaps.
- Invalid swaps bounce back.
- No valid moves triggers reshuffle.
- Cascades continue until stable.
- Special tiles create correctly.
- Special tiles activate correctly.
- Stars are awarded correctly.
- Progress saves after app restart.
- Locked levels cannot be opened.
- Completed levels can be replayed.
- Sound settings work.
- Game does not freeze during cascades.

## 32.3 Performance Tests

Test on:

- Developer device
- At least one mid-range Android phone
- Slow animations/cascade-heavy scenarios
- Repeated level restarts
- Long sessions

---

## 33. Development Phases

## 33.1 Phase 0 — Project Setup

Tasks:

- Create Flutter project.
- Add Flame.
- Add folder structure.
- Add placeholder assets.
- Set orientation decision.
- Create basic app theme.
- Create route structure.
- Create splash/home/level select placeholder screens.

Deliverable:

- App launches and navigates between basic screens.

## 33.2 Phase 1 — Board Logic

Tasks:

- Implement BoardModel.
- Implement GemType.
- Implement board generator.
- Implement match finder.
- Implement move validator.
- Implement cascade resolver.
- Add tests for board logic.

Deliverable:

- Board can generate, validate moves, detect matches, remove tiles, and cascade in pure Dart.

## 33.3 Phase 2 — Flame Board Rendering

Tasks:

- Implement AdinkraGemsGame.
- Implement BoardComponent.
- Implement TileComponent.
- Render 8x8 board.
- Map grid position to screen position.
- Load placeholder tile sprites.
- Support tile selection/swipe.

Deliverable:

- Player can see and interact with the board.

## 33.4 Phase 3 — Swap, Match, Cascade

Tasks:

- Animate valid swaps.
- Animate invalid swaps.
- Trigger match detection after swap.
- Animate tile popping.
- Drop tiles.
- Spawn new tiles.
- Continue cascades until stable.
- Lock input during resolution.

Deliverable:

- Complete playable match-3 loop.

## 33.5 Phase 4 — Effects and Game Feel

Tasks:

- Add small shake.
- Add pop animation.
- Add particle burst.
- Add score popup.
- Add bounce on tile fall.
- Add tiny sound effects.
- Add reshuffle animation/message.

Deliverable:

- Core gameplay feels juicy and satisfying.

## 33.6 Phase 5 — Level System

Tasks:

- Add LevelConfig.
- Add 10 level configs.
- Add move limit.
- Add timer.
- Add score objective.
- Add collect objective.
- Add win/lose logic.
- Add HUD.

Deliverable:

- 10 levels are playable with objectives and limits.

## 33.7 Phase 6 — Special Tiles

Tasks:

- Implement match 4 special creation.
- Implement horizontal/vertical blast.
- Implement match 5 color clear.
- Implement L/T bomb.
- Add special tile visuals/overlays.
- Add special tile activation logic.
- Add special tile effects.

Deliverable:

- Special tile system works in gameplay.

## 33.8 Phase 7 — Screens and Progress

Tasks:

- Build home screen.
- Build level select map.
- Build win screen.
- Build lose screen.
- Build settings screen.
- Implement local progress save.
- Implement stars.
- Unlock next level after win.

Deliverable:

- Game feels like a complete mini product.

## 33.9 Phase 8 — Polish and Testing

Tasks:

- Replace placeholder tiles with final gem assets.
- Tune level difficulty.
- Fix bugs.
- Add sound/music toggle.
- Improve animations.
- Test performance.
- Prepare internal APK/AAB.

Deliverable:

- First playable MVP ready for closed/internal testing.

---

## 34. Recommended 14-Day Sprint Plan

## Day 1

- Project setup
- Folder structure
- Add Flame
- Create placeholder screens
- Create level config model

## Day 2

- Board model
- Gem type model
- Board generator
- Initial board validation

## Day 3

- Match detection
- Move validation
- Unit tests for matching

## Day 4

- Cascade resolver
- Tile dropping logic
- Spawn logic
- No-valid-moves detection

## Day 5

- Flame board rendering
- Tile components
- Placeholder assets
- Grid positioning

## Day 6

- Swap input
- Valid/invalid swap animation
- Input locking

## Day 7

- Match removal
- Tile pop animation
- Cascades visually working

## Day 8

- Particles
- Score popup
- Bounce fall
- Basic SFX

## Day 9

- Level objectives
- Move limits
- Timer levels
- HUD

## Day 10

- 10 level configs
- Win/lose flow
- Stars

## Day 11

- Level select map
- Save progress
- Replay levels
- Locked/unlocked states

## Day 12

- Special tiles:
  - Match 4 blast
  - Match 5 color clear

## Day 13

- Bomb tile
- Special effects
- Reshuffle polish
- Difficulty tuning

## Day 14

- Bug fixing
- Performance testing
- Replace main tile assets
- Build test release

---

## 35. Asset Requirements

## 35.1 Required First Assets

Tiles:

- 6 normal gem tiles
- 1 horizontal blast overlay or tile
- 1 vertical blast overlay or tile
- 1 color clear gem
- 1 bomb gem

UI:

- Game logo
- Home background
- Level map background
- Board frame
- Level node locked/unlocked/completed
- Star icon filled/empty
- Button assets or Flutter-styled buttons
- Objective icons

Effects:

- Particle sprites, optional
- Glow sprites, optional
- Beam sprite for blasts, optional

Audio:

- button tap
- swap
- invalid swap
- match pop
- special tile created
- blast
- bomb
- color clear
- win
- lose

## 35.2 Asset Priority

Highest priority:

1. 6 normal tiles
2. Board frame/background
3. Match particle effects
4. Win/lose UI
5. Level map

Special tile art can start as overlays and be improved later.

---

## 36. Open Decisions

The following still need final decisions before or during development:

1. Exact package name.
2. Final 6 Adinkra symbols.
3. Exact color-symbol pairing.
4. Portrait-only or flexible orientation.
5. Whether to use SharedPreferences or Hive.
6. Whether to add Firebase immediately or after first playable.
7. Final art dimensions for tile assets.
8. Whether Level 1 includes guided tutorial hints.
9. Exact background music decision.
10. Whether special tile combos are skipped or simplified in first playable.

Recommended defaults:

- Package name: decide later before Play Store setup.
- Orientation: portrait only.
- Storage: SharedPreferences.
- Firebase: add after first playable works unless easy to add early.
- Tutorial: minimal hints only.
- Special combos: simplified.

---

## 37. Acceptance Criteria

The first playable version is considered complete when:

1. App opens successfully.
2. Home screen works.
3. Level select map shows 10 levels.
4. Locked/unlocked level states work.
5. Player can start Level 1.
6. Board loads with no starting matches.
7. Board has at least one valid move.
8. Player can only make valid swaps.
9. Invalid swaps bounce back and do not consume moves.
10. Match 3 clears tiles.
11. Cascades continue until stable.
12. No valid moves triggers automatic reshuffle.
13. Score updates correctly.
14. Collect objectives update correctly.
15. Move-based levels can be won/lost.
16. Time-based levels can be won/lost.
17. Mixed move/time level works.
18. Match 4 creates blast tile.
19. Match 5 creates color clear tile.
20. L/T match creates bomb tile.
21. Special tiles activate correctly.
22. Stars are awarded.
23. Progress is saved locally.
24. Completed levels can be replayed.
25. Next level unlocks after win.
26. Win screen displays correctly.
27. Lose screen displays correctly.
28. Basic sound effects work.
29. Tile pop, particles, bounce, and score popup are visible.
30. Game remains stable after repeated play.

---

## 38. Risks and Mitigation

## 38.1 Risk: Overbuilding Too Early

Problem:
Trying to build full Candy Crush-like features immediately may delay MVP.

Mitigation:
Focus on 10 levels, 2 objective types, and no boosters.

## 38.2 Risk: Special Tile Logic Complexity

Problem:
Special tile combinations can become complicated.

Mitigation:
Implement simple activation first. Add advanced combos later.

## 38.3 Risk: Animation Timing Slows Gameplay

Problem:
Too many effects may make gameplay feel slow.

Mitigation:
Keep animations short and responsive.

## 38.4 Risk: Board Logic Bugs

Problem:
Match-3 games can easily have cascade, no-move, and special tile bugs.

Mitigation:
Keep logic separate from visuals and write unit tests.

## 38.5 Risk: Art Consistency

Problem:
Tiles may look inconsistent if generated separately.

Mitigation:
Use the first yellow tile mockup as a strict style reference.

## 38.6 Risk: 14-Day Scope Too Large

Problem:
10 levels plus special tiles plus screens may be heavy.

Mitigation:
Prioritize in this order:
1. Board loop
2. Game feel
3. Level objectives
4. Save/progress
5. Special tiles
6. Polish

If needed, special tiles can be completed after core 10-level loop.

---

## 39. Future Roadmap

## 39.1 After First Playable

Potential additions:

- Boosters
- More levels
- More tile types
- More board sizes
- Blockers
- World map
- Better tutorial
- Shop
- Rewarded ads
- In-app purchases
- Daily rewards
- Lives system
- Symbol meanings collection
- More Ghanaian-themed worlds
- Play Store closed testing

## 39.2 Possible Future Worlds

1. Adinkra Village
2. Kente Trail
3. Golden Forest
4. Festival Night
5. Royal Palace
6. Ancient Symbols Temple

## 39.3 Possible Future Mechanics

- Wooden block tiles
- Locked gems
- Ice/frozen gems
- Clay blockers
- Hidden symbol tiles
- Portal tiles
- Countdown bombs
- Mystery gems
- Symbol collection album

---

## 40. Final MVP Definition

Adinkra Gems first playable MVP is:

> A Flutter + Flame match-3 puzzle game with 10 levels, 6 glossy Adinkra gem tiles, an 8x8 board, valid-match-only swaps, automatic reshuffle when no moves remain, automatic cascades, score and collect objectives, move/time limits, special tiles from match 4/match 5/L-T matches, 3-star level ratings, local save progress, home screen, level map, win/lose screens, polished particles, bounce, pop, shake, sound, and smooth tile movement.

This is the foundation to build before expanding into boosters, monetization, worlds, and more complex level mechanics.

---

## 41. Development Priority Summary

Build in this order:

1. Flutter project shell
2. Flame board rendering
3. Board logic
4. Valid swaps
5. Match detection
6. Cascades
7. Particles and polish
8. Score and objectives
9. 10 levels
10. Win/lose
11. Stars
12. Save progress
13. Level map
14. Special tiles
15. Audio
16. Final polish

The first big milestone is not “many features.”  
The first big milestone is:

> One level that feels fun, smooth, and satisfying.

Once one level feels right, the 10-level MVP becomes much easier to finish.
