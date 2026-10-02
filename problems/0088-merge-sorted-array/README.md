# 88. Merge Sorted Array

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/merge-sorted-array/
**List:** Top Interview 150

You are given two integer arrays `nums1` and `nums2`, sorted in **non-decreasing
order**, and two integers `m` and `n`, representing the number of elements in
`nums1` and `nums2` respectively.

**Merge** `nums1` and `nums2` into a single array sorted in non-decreasing order.

The final sorted array should not be returned by the function, but instead be
*stored inside the array* `nums1`. To accommodate this, `nums1` has a length of
`m + n`, where the first `m` elements denote the elements that should be merged,
and the last `n` elements are set to `0` and should be ignored. `nums2` has a
length of `n`.

**Example 1:**
```
Input:  nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
Output: [1,2,2,3,5,6]
```
The arrays being merged are `[1,2,3]` and `[2,5,6]`.

**Example 2:**
```
Input:  nums1 = [1], m = 1, nums2 = [], n = 0
Output: [1]
```

**Example 3:**
```
Input:  nums1 = [0], m = 0, nums2 = [1], n = 1
Output: [1]
```
There are no elements in `nums1`; the `0` is only there so the merge result fits.

Constraints:
- `nums1.length == m + n`
- `nums2.length == n`
- `0 <= m, n <= 200`
- `1 <= m + n <= 200`
- `-10^9 <= nums1[i], nums2[j] <= 10^9`

**Follow up:** Can you come up with an algorithm that runs in `O(m + n)` time?

## Approach

**This is a merge of two sorted sequences, filled from the back, solved with
three pointers in `O(m + n)` time and `O(1)` space.**

### Three hints that get you 90% of the way

1. **One pointer per job, not one per array.**
2. **Fill from the back.**
3. **Check `read1 >= 0` before reading `nums1[read1]`.**

### The data

```
index:   0  1  2 | 3  4  5
nums1: [ 1  2  3 | _  _  _ ]     m = 3 real values | n = 3 open seats
nums2: [ 2  5  6 ]
```

The open seats are the last `n` slots, and only `m` says where they start. Never
search for "the first zero": a `0` can be real data (`[0, 0, 0, 0], m = 2`).

### Why the back, not the front

Merging smallest-first (the way 21 merges lists) writes the first winner into
index 0, which holds a real `nums1` value that hasn't been read yet. All the free
space is at the **back**, so place the **largest** value first and work left.

### The bottleneck: a hidden third pointer

Two arrays suggest two pointers. But `nums1` has **two jobs**: it is read from
*and* written to, at different positions. One pointer can't do both.

- `read1 = m - 1`: the biggest unplaced value in `nums1` (its last *real* value)
- `read2 = n - 1`: the biggest unplaced value in `nums2`
- `write = m + n - 1`: the back of the bus, the seat the next winner goes into

`write` moves left after **every** placement; it never stays at the very end. It
can walk into `nums1`'s real section, but only onto values already copied
(`write` never passes `read1`). A copy leaves a stale duplicate behind, and the
next placement overwrites it.

### When to stop: the asymmetry

- **`nums2` runs out first:** done. The leftover `nums1` values are already in
  their seats, sorted. (`write == read1 + read2 + 1` holds every step, so at
  `read2 == -1`, `write == read1`.)
- **`nums1` runs out first:** keep going, copying the rest of `nums2`.

So the one loop condition is `while read2 >= 0`, and `read1 >= 0` guards the
comparison. No cleanup loop afterward.

### Trace, Example 1

| step | compare | winner → seat | `nums1` after | `read1` | `read2` | `write` |
|---|---|---|---|---|---|---|
| start | | | `[1,2,3,_,_,_]` | 2 | 2 | 5 |
| 1 | 3 vs 6 | 6 → 5 | `[1,2,3,_,_,6]` | 2 | 1 | 4 |
| 2 | 3 vs 5 | 5 → 4 | `[1,2,3,_,5,6]` | 2 | 0 | 3 |
| 3 | 3 vs 2 | 3 → 3 | `[1,2,3,3,5,6]` | 1 | 0 | 2 |
| 4 | 2 vs 2 (tie, nums2 wins) | 2 → 2 | `[1,2,2,3,5,6]` | 1 | -1 | 1 |

`read2 == -1`: stop. `read1 == write == 1`, and `[1, 2]` already sits in seats 0–1.

### Two solutions, one tradeoff

| | time | extra space |
|---|---|---|
| Copy the `m` real values out, merge front-to-back into `nums1` | `O(m + n)` | `O(m)` |
| Three pointers from the back (this one) | `O(m + n)` | `O(1)` |

(Copy everything in and sort also works, at `O((m + n) log(m + n))`.)

### Siblings

- [21. Merge Two Sorted Lists](../0021-merge-two-sorted-lists/README.md): the
  same compare-the-heads merge, but list nodes splice for free; array slots don't.
- 977 Squares of a Sorted Array (read, not solved): the same back-fill with a
  `write` pointer.
- [283. Move Zeroes](../0283-move-zeroes/README.md): `read` and `write` share one
  array, and `write` never overtakes `read`.

### Reflect (2026-10-02)

"Easy" describes the code (one loop), not how hard the idea is to *see*. Most of
the time went to A and B, with a lot of round-tripping between them: the memory
layout (who reads where, who writes where) belonged in A but only surfaced while
hunting for B. The round-tripping stopped as soon as the three pointers were
written out with their jobs and starting indices.

## Idiom notes

### Swift

- `inout` plus `&nums1` at the call site: the output is a side effect, not a
  return value.
- `&&` short-circuits, so `read1 >= 0 && nums1[read1] > nums2[read2]` never
  evaluates `nums1[-1]`. The order of the two checks is load-bearing.
