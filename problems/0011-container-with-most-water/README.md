# 11. Container With Most Water

**Difficulty:** Medium
**Link:** https://leetcode.com/problems/container-with-most-water/

You are given an integer array `height` of length `n`. There are `n` vertical
lines drawn such that the two endpoints of the `i`th line are `(i, 0)` and
`(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the
container contains the most water.

Return _the maximum amount of water a container can store_.

**Notice** that you may not slant the container.

**Example 1:**
```
Input:  height = [1,8,6,2,5,4,8,3,7]
Output: 49
```
The vertical lines are drawn at each index. The max area of water the container
can contain is 49.

**Example 2:**
```
Input:  height = [1,1]
Output: 1
```

Constraints:
- `n == height.length`
- `2 <= n <= 10^5`
- `0 <= height[i] <= 10^4`

## Approach

**This is a converging two-pointer problem solved by always moving the shorter wall
inward, in $O(n)$ time and $O(1)$ extra space.**

**The water in one bucket** is `min(height[left], height[right]) × (right - left)`.
Height comes from the **values**; width comes from the **indices**. Width counts
the *gaps* between walls, not the walls: nut to 8th fret is 8 fret spaces.

**Brute force** tries every pair: about `n²/2` buckets, roughly 5 billion at
`n = 10^5`. Too slow.

**The elimination argument.** Start at the widest bucket (`left = 0`,
`right = n - 1`). After measuring it, the **shorter** wall is finished. Every
future partner is closer (smaller width), and the water is still capped by
this wall's height, so no bucket using it can beat the one just measured. Drop
it and move it inward. On a tie, both walls are finished, so moving either one
is safe.

Sibling of [167](../0167-two-sum-ii-input-array-is-sorted/README.md), with the
same skeleton and a different drop rule. 167 compares a **sum** against a
target and leans on sorting. 11 compares the **two heights** and needs no
sorting, because the width shrinking on every step does that work.

### Pseudocode

```
left = 0, right = n - 1, maxWater = 0
while left < right:
    water = min(height[left], height[right]) * (right - left)
    maxWater = max(maxWater, water)
    if height[left] < height[right]: move left in
    else: move right in          # tie lands here, safe
return maxWater
```

## Reflection

**Not solved cold.** The solution was first seen at the end of the session, and
Claude wrote the Swift while Jeff was driving. Schedule a cold re-solve.

**A (understanding) ate the session; B was quick once A landed.** This is the
reverse of 167, where A was fine and B cost an hour.

- **Read the water as a sum** of heights at GOAL. That's the 167 shape carrying
  over (the recency trap). Fixed by tracing one bucket: `min(8, 7) × 7 = 49`.
- **Index/value slip on width:** `8 × 8`, then `width = right - left` computed
  on the heights.
- **Fenceposts:** counting walls instead of gaps, or subtracting 2 for the
  walls. The unlock was the guitar neck: nut to 8th fret is 8 fret spaces.
- **Took the taller wall** once (`3 × 7 = 21`).

**B was derived unaided** once the picture was right: "the left wall is 1, so
nothing will ever be greater moving the right wall in," which generalizes to
**move the shorter wall**. The tie case needed a worked example: on a tie both
walls are finished, so the `else` is safe.

## Idiom notes

### Swift
