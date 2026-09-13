# 463. Island Perimeter

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/island-perimeter/

You are given `row x col` `grid` representing a map where `grid[i][j] = 1`
represents land and `grid[i][j] = 0` represents water.

Grid cells are connected **horizontally/vertically** (not diagonally). The
`grid` is completely surrounded by water, and there is exactly one island
(i.e., one or more connected land cells).

The island doesn't have "lakes", meaning the water inside isn't connected to
the water around the island. One cell is a square with side length 1. The grid
is rectangular, width and height don't exceed 100. Determine the perimeter of
the island.

**Example 1:**
```
Input:  grid = [[0,1,0,0],
                [1,1,1,0],
                [0,1,0,0],
                [1,1,0,0]]
Output: 16
```
The perimeter is the 16 yellow stripes in the image above.

**Example 2:**
```
Input:  grid = [[1]]
Output: 4
```

**Example 3:**
```
Input:  grid = [[1,0]]
Output: 4
```

Constraints:
- `row == grid.length`
- `col == grid[i].length`
- `1 <= row, col <= 100`
- `grid[i][j]` is `0` or `1`
- There is exactly one island in `grid`

## Approach

**Count exposed sides per land cell — a plain scan, no traversal.** Every land
cell is a 1×1 square with four sides. A side belongs to the perimeter exactly
when the neighbor across it is water or off the board. Walk every cell; for each
land cell, check up, down, left, and right, and add one per exposed side. An edge
shared by two land cells is never counted, from either side.

```
[[1, 1]]

  ┌───┬───┐      left cell:  up, down, left exposed → 3
  │ 1 │ 1 │      right cell: up, down, right exposed → 3
  └───┴───┘      shared middle edge: hidden from both → 0
                                             total → 6
```

"Completely surrounded by water" is what lets the bounds check answer *exposed*
for an off-board neighbor: the edge of the grid is just more water.

### "Island" does not mean DFS here

The word *island* points at [733. Flood Fill](../0733-flood-fill/README.md) and
DFS, and recency makes that pull stronger. But perimeter is a **sum of per-cell
facts**: each cell's contribution depends only on its four immediate neighbors,
never on which cells are connected to which. No traversal, no visited marker, no
recursion. Ask whether the answer needs *connectivity* before reaching for a
flood fill.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `1 <= row, col <= 100` | **hint** | at most 10⁴ cells, so any per-cell scan is instant |
| `grid[i][j]` is `0` or `1` | **promise** | the code asks `== 1` for "is this cell land?" but `== 0` for "is this neighbor water?"; a `2` would hide its neighbors' sides like land while adding none of its own like water — a confident wrong answer |
| exactly one island | **promise the algorithm does not need** | summing exposed sides gives total shoreline for any number of islands |
| no lakes | **promise the algorithm does not need** | with a lake, its inner shoreline would be counted too; the promise shapes the problem's definition, not the scan |

### A second solution: count cells and shared edges

Every land cell brings four sides, and every edge shared by two land cells hides
one side from **each** of them. So `perimeter = 4 × landCells − 2 × sharedEdges`.
Check only the **right** and **down** neighbors so each shared edge is found once.
Same `O(m·n)`, fewer neighbor checks, but the reasoning lives in the formula
rather than in the code.

### Complexity

- **Time:** `O(m·n)` — every cell visited once, four constant-time checks each.
- **Space:** `O(1)` extra — no recursion stack and no visited set.

Solved 2026-09-08, the grid follow-up to 733.

## Solutions

| Language | Harness | Run from the leaf | Status |
|----------|---------|-------------------|--------|
| Swift | SwiftPM + Swift Testing | `swift test` | ✅ 8 tests |

## Idiom notes

_What each language made me see:_

- **Swift** — The nested helpers `isExposed` and `exposedSides` capture `grid`
  **read-only**. Compare 733, which needed `var image = image` because painting
  mutates; here nothing changes, so there is no copy and no visited marker.
- **Swift** — The bounds check is one `guard` with two conditions, and their
  order is load-bearing: conditions evaluate top to bottom and stop at the first
  false, so `grid.indices.contains(row)` protects the `grid[row]` subscript in
  the next line. Off-board returns `true`, which is "surrounded by water" in code.
- **Swift** — Four separate `if` blocks (up, down, left, right) instead of a loop
  over direction offsets like `[(-1, 0), (1, 0), (0, -1), (0, 1)]`. The offsets
  array is more compact; the four `if`s give each direction its own breakpoint.
