# 80. Remove Duplicates from Sorted Array II

**Difficulty:** Medium  
**Link:** https://leetcode.com/problems/remove-duplicates-from-sorted-array-ii/  
**List:** Top Interview 150

## Goal

Keep at most two occurrences of each value in a sorted integer array, preserving
order. Put the keepers into the front of the original array and return their
count, `k`. The array's length stays unchanged; indices `k...` are ignored.
The underscores in examples mean ignored slots, not values to write.

| Input | Kept prefix | Return `k` |
|---|---|---|
| `[1,1,1,2,2,3]` | `[1,1,2,2,3]` | 5 |
| `[0,0,1,1,1,1,2,3,3]` | `[0,0,1,1,2,3,3]` | 7 |

## Constraints

- `1 <= nums.count <= 30_000`: never empty; avoid repeated full scans.
- Values are in `-10_000...10_000`; negatives use the same keep rule.
- Sorted in non-decreasing order: equal values form consecutive groups.
- Modify the original array using O(1) extra space; no second keeper array.

## Approach

**This is a read/write two-pointer problem solved with a single compaction pass
in O(n) time and O(1) extra space.**

`read` is the index of the candidate. `write` is the next keeper slot and the
count of keepers so far. The decision is: **"Keep this candidate, or skip it?"**

Keep when either condition is true:

1. `write < 2`: fewer than two elements have been kept in total, so another
   cannot create a third copy. Check this first to avoid a negative subscript.
2. `nums[read] != nums[write - 2]`: the second-to-last keeper differs from the
   candidate, so the sorted kept prefix cannot already end in two copies of it.

The conditions use **OR**, because either is sufficient. Compare against
`write - 2`, not `read - 2`: skipped candidates are not part of the kept prefix.
When keeping, copy into `nums[write]` and increment `write`. Return `write`.

The implementation uses `nums.indices.reduce(into: 0)`. Its accumulator, `write`,
starts at zero, and each index becomes `read`. The same keep rule handles the
first two elements. The reduction returns the final keeper count. Empty input
returns the initial zero, so no separate empty-input guard is needed.

## Solutions and tests

| Language | Harness | Run from the leaf |
|---|---|---|
| Swift | SwiftPM + Swift Testing | `swift test` |

Tests check `k`, the kept prefix, and unchanged array length. They ignore the
tail. Fixtures cover both examples, singles, pairs, third copies, long runs,
new groups after discards, negative values, value bounds, and 30,000 elements.
An empty-input fixture checks that the reduction returns zero outside the judge's domain.

**Validation:** all 12 local Swift tests passed. Jeff's screenshot of the
`reduce(into:)` submission shows LeetCode accepted all 170 cases, with 31 ms
runtime and 19.48 MB memory. One submission does not establish a performance
difference from the original loop.

## Reflection — 2026-10-08

- **A — Understanding:** underscores were initially read as values to fill;
  then `k` was read as a count of pairs. Traces established that singles stay,
  `k` counts individual kept elements, and indices `0..<k` hold the result.
- **B — Identifying:** Jeff named the main difficulty: recognizing `write - 2`,
  recognizing `write < 2`, and recognizing that the two conditions use OR.
  The rule from 26 skipped the second copy; comparing the second-to-last
  keeper distinguishes an allowed second copy from a forbidden third.
- **C — Writing:** Jeff wrote the Swift in LeetCode's browser editor and reported
  that it passed on the first attempt, without AI completion or IDE assistance.
- **Credit:** Jeff wrote the implementation. The coach guided the condition,
  supplied pseudocode at Jeff's request, and reviewed the submitted code.
  Afterward, at Jeff's request, the coach changed the initialization and loop
  range to handle every candidate uniformly and remove the empty guard, then
  rewrote that pass using `reduce(into:)` at Jeff's request.

## Idiom notes

- **Swift:** `inout [Int]` modifies the caller's array. `||` short-circuits,
  protecting `write - 2` when fewer than two keepers exist. Assignment copies
  one value; a swap is unnecessary because the discarded tail is ignored.
- **`reduce(into:)`:** supplies a mutable integer accumulator without allocating
  a second keeper array. Reducing the indices lets the closure modify `nums`.
  The function consists of one expression, so `return` can be omitted. The
  original `for` loop remains an equally idiomatic way to express this mutation;
  Jeff chose the reduction version for practice.
- **Connection to 26 and 283:** the same read/write skeleton, with a different
  keep predicate. In 26 compare the last keeper; here compare two keepers back.
