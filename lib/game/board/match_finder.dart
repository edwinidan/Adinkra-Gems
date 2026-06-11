import '../models/gem_type.dart';
import '../models/match_group.dart';
import '../models/special_gem_type.dart';
import 'board_model.dart';
import 'grid_position.dart';

/// Scans a [BoardModel] and returns all horizontal, vertical, L-shape,
/// and T-shape match groups of 3 or more tiles of the same [GemType].
///
/// Classifies matches of 4+ or intersections to trigger special tiles creation.
class MatchFinder {
  /// Returns every match currently present on [board].
  ///
  /// Checks intersections to form L/T bomb shapes, then runs standard runs.
  /// Passes optional [swapA] and [swapB] to spawn special gems exactly where
  /// the player initiated their swap gesture.
  List<MatchGroup> findMatches(
    BoardModel board, {
    GridPosition? swapA,
    GridPosition? swapB,
  }) {
    final horizontal = _scanHorizontal(board);
    final vertical = _scanVertical(board);

    final resolved = <MatchGroup>[];
    final usedHorizontal = <MatchGroup>{};
    final usedVertical = <MatchGroup>{};

    // 1. Detect L-shape and T-shape intersections (creates Bomb special tiles)
    for (final h in horizontal) {
      for (final v in vertical) {
        if (h.gemType == v.gemType) {
          GridPosition? intersectPos;
          for (final pos in h.positions) {
            if (v.positions.contains(pos)) {
              intersectPos = pos;
              break;
            }
          }

          if (intersectPos != null) {
            final combined = <GridPosition>{
              ...h.positions,
              ...v.positions,
            }.toList();

            resolved.add(
              MatchGroup(
                positions: combined,
                gemType: h.gemType,
                specialCreated: SpecialGemType.bomb,
                specialSpawnPosition: intersectPos,
              ),
            );

            usedHorizontal.add(h);
            usedVertical.add(v);
          }
        }
      }
    }

    // 2. Process remaining horizontal groups (checks for match-4/5)
    for (final h in horizontal) {
      if (!usedHorizontal.contains(h)) {
        SpecialGemType special = SpecialGemType.none;
        GridPosition? spawnPos;

        if (h.length >= 5) {
          special = SpecialGemType.colorClear;
          spawnPos = _chooseSpawnPos(h.positions, swapA, swapB);
        } else if (h.length == 4) {
          special = SpecialGemType.horizontalBlast;
          spawnPos = _chooseSpawnPos(h.positions, swapA, swapB);
        }

        resolved.add(
          MatchGroup(
            positions: h.positions,
            gemType: h.gemType,
            specialCreated: special,
            specialSpawnPosition: spawnPos,
          ),
        );
      }
    }

    // 3. Process remaining vertical groups (checks for match-4/5)
    for (final v in vertical) {
      if (!usedVertical.contains(v)) {
        SpecialGemType special = SpecialGemType.none;
        GridPosition? spawnPos;

        if (v.length >= 5) {
          special = SpecialGemType.colorClear;
          spawnPos = _chooseSpawnPos(v.positions, swapA, swapB);
        } else if (v.length == 4) {
          special = SpecialGemType.verticalBlast;
          spawnPos = _chooseSpawnPos(v.positions, swapA, swapB);
        }

        resolved.add(
          MatchGroup(
            positions: v.positions,
            gemType: v.gemType,
            specialCreated: special,
            specialSpawnPosition: spawnPos,
          ),
        );
      }
    }

    return resolved;
  }

  // ── Horizontal scan ───────────────────────────────────────────────────────

  List<MatchGroup> _scanHorizontal(BoardModel board) {
    final matches = <MatchGroup>[];

    for (int r = 0; r < board.rowCount; r++) {
      int c = 0;
      while (c < board.colCount) {
        final start = board.get(GridPosition(r, c));
        if (start == null) {
          c++;
          continue;
        }

        final positions = [GridPosition(r, c)];
        int nc = c + 1;
        while (nc < board.colCount) {
          final next = board.get(GridPosition(r, nc));
          if (next?.gemType == start.gemType) {
            positions.add(GridPosition(r, nc));
            nc++;
          } else {
            break;
          }
        }

        if (positions.length >= 3) {
          matches.add(MatchGroup(positions: positions, gemType: start.gemType));
        }

        c = nc;
      }
    }

    return matches;
  }

  // ── Vertical scan ─────────────────────────────────────────────────────────

  List<MatchGroup> _scanVertical(BoardModel board) {
    final matches = <MatchGroup>[];

    for (int c = 0; c < board.colCount; c++) {
      int r = 0;
      while (r < board.rowCount) {
        final start = board.get(GridPosition(r, c));
        if (start == null) {
          r++;
          continue;
        }

        final positions = [GridPosition(r, c)];
        int nr = r + 1;
        while (nr < board.rowCount) {
          final next = board.get(GridPosition(nr, c));
          if (next?.gemType == start.gemType) {
            positions.add(GridPosition(nr, c));
            nr++;
          } else {
            break;
          }
        }

        if (positions.length >= 3) {
          matches.add(MatchGroup(positions: positions, gemType: start.gemType));
        }

        r = nr;
      }
    }

    return matches;
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  static GridPosition _chooseSpawnPos(
    List<GridPosition> positions,
    GridPosition? swapA,
    GridPosition? swapB,
  ) {
    if (swapA != null && positions.contains(swapA)) return swapA;
    if (swapB != null && positions.contains(swapB)) return swapB;
    return positions[positions.length ~/ 2]; // Default to center
  }

  // ── Targeted checks ───────────────────────────────────────────────────────

  /// Returns true if there is at least one match on [board].
  bool hasAnyMatch(BoardModel board) => findMatches(board).isNotEmpty;

  /// Returns only the matches that involve [pos].
  List<MatchGroup> matchesAt(BoardModel board, GridPosition pos) {
    return findMatches(board).where((m) => m.positions.contains(pos)).toList();
  }
}
