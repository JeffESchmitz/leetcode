# 733. Flood Fill

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/flood-fill/

You are given an image represented by an `m x n` grid of integers `image`,
where `image[i][j]` represents the pixel value of the image. You are also given
three integers `sr`, `sc`, and `color`. Your task is to perform a **flood
fill** on the image starting from the pixel `image[sr][sc]`.

To perform a flood fill:

1. Begin with the starting pixel and change its color to `color`.
2. Perform the same process for each pixel that is directly adjacent (pixels
   that share a side with the original pixel, either horizontally or
   vertically) and shares the **same color** as the starting pixel.
3. Keep repeating this process by checking neighboring pixels of the *updated*
   pixels and modifying their color if it matches the original color of the
   starting pixel.
4. The process stops when there are no more adjacent pixels of the original
   color to update.

Return the modified image after performing the flood fill.

**Example 1:**
```
Input:  image = [[1,1,1],
                 [1,1,0],
                 [1,0,1]], sr = 1, sc = 1, color = 2
Output:         [[2,2,2],
                 [2,2,0],
                 [2,0,1]]
```
From the center of the image with position `(sr, sc) = (1, 1)` (the underlined
pixel), all pixels connected by a path of the same color as the starting pixel
(the blue pixels) are colored with the new color. Note the bottom corner is
**not** colored 2, because it is not 4-directionally connected to the starting
pixel.

**Example 2:**
```
Input:  image = [[0,0,0],
                 [0,0,0]], sr = 0, sc = 0, color = 0
Output:         [[0,0,0],
                 [0,0,0]]
```
The starting pixel is already colored `0`, which is the same as the target
color. Therefore, no changes are made to the image.

Constraints:
- `m == image.length`
- `n == image[i].length`
- `1 <= m, n <= 50`
- `0 <= image[i][j], color < 2^16`
- `0 <= sr < m`
- `0 <= sc < n`

## Approach

**Depth-first search (recursion) from the clicked cell.** Remember the
starting pixel's original color. If it already equals the new color, return the
image untouched (otherwise the fill never terminates: painting changes nothing,
so every cell looks unvisited forever). Otherwise, a nested `fill(row, column)`
helper does four things: bail if off the board, bail if this cell isn't the
original color, paint it, then recurse up/down/left/right. Painting the cell
*is* the visited marker; the color check on re-entry is what stops the recursion.

The paint moves like a rook: one square at a time, horizontally or vertically,
never diagonal, and it cannot pass through a different color.

- Time O(m·n), every cell painted at most once.
- Space O(m·n) worst case for the call stack (a winding single-color path).

Solved 2026-09-07, about an hour. Twenty minutes of that was understanding: the
`sr`/`sc` names, four inputs, and a grid return type were all firsts.

## Solutions

| Language | Harness | Run from the leaf | Status |
|----------|---------|-------------------|--------|
| Swift | SwiftPM + Swift Testing | `swift test` | ✅ 8 tests |

## Idiom notes

_What each language made me see:_

- **Swift** — A nested `func` inside the solution method captures the mutable
  copy of the grid, the original color, and the new color, so the recursive
  step only needs `(row, column)`. Nesting is not a smell here: the helper is
  meaningless without that captured state, and the alternative is threading
  three extra parameters through every call. Swift also allows calling a
  nested function before its declaration as long as everything it captures is
  already declared above the call site.
