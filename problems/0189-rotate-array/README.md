# 189. Rotate Array

**Difficulty:** Medium  
**Link:** https://leetcode.com/problems/rotate-array/  
**List:** Top Interview 150  
**Status:** Swift solution implemented; 15 local tests pass; LeetCode accepted 695/695 cases (2026-10-09).

## Problem

Move each element of `nums` right by `k` positions, wrapping around to the front
when it goes beyond the last position. Modify the original array; the function
does not return a separate array. `k` is non-negative.

| Input | Steps `k` | Result |
|---|---|---|
| `[1,2,3,4,5,6,7]` | 3 | `[5,6,7,1,2,3,4]` |
| `[-1,-100,3,99]` | 2 | `[3,99,-1,-100]` |

For the first example, successive one-step moves give:

```text
start: [1,2,3,4,5,6,7]
1:     [7,1,2,3,4,5,6]
2:     [6,7,1,2,3,4,5]
3:     [5,6,7,1,2,3,4]
```

## Constraints

- `1 <= nums.count <= 100_000`
- `-2^31 <= nums[i] <= 2^31 - 1`
- `0 <= k <= 100_000`

**Follow-ups:** explore multiple approaches; can the operation use O(1) extra space?

## Approach

**This is an array-rotation problem solved with three reversals using converging
two pointers in O(n) time and O(1) extra space.**

Calculate `shift = k % nums.count`. Full turns restore the original array, so
only the remainder matters; if it is zero, return immediately.

Reverse the following inclusive index ranges in the same array:

1. Entire array: `0...nums.count - 1`.
2. Front group: `0...shift - 1`.
3. Remaining group: `shift...nums.count - 1`.

```text
[1,2,3,4,5]   start, shift = 2
[5,4,3,2,1]   reverse all
[4,5,3,2,1]   reverse the first 2
[4,5,1,2,3]   reverse the remaining 3
```

Write the input as two blocks, `A B`, where `B` contains the last `shift`
elements. Reversing everything produces `reverse(B) reverse(A)`: both blocks
are in their destination positions, but internally backward. Reversing each
block gives `B A`, preserving the original order within each block.

The helper swaps the range's endpoints, moves both indices inward, and stops
when they meet or cross. The whole-array pass plus the two group passes is still
O(n): the groups together cover one array length. The helper is iterative and
needs only two local integers.

## Swift solution and tests

Signature: `public func rotate(_ nums: inout [Int], _ k: Int)`.
All three passes call the same in-place range-reversal helper.

Run `swift test` from `swift/`. The suite contains 15 tests covering the given
examples, zero steps, singleton inputs, repeated full turns, steps beyond the
array length, odd/even lengths, repeated values, value bounds, and 100,000 elements.
The submitted solution passed 695/695 LeetCode cases on 2026-10-09; the judge
reported 0 ms. That timing is a submission measurement; the algorithm is O(n).

## Reflection

- **A — Understanding:** Jeff traced right rotation correctly and recognized
  that complete turns restore the original array. `k` specifies the final
  arrangement, not a requirement to perform `k` separate operations.
- **B — Identifying:** the coach connected the reversal from 344 to three
  reversals. The difficult picture was distinguishing successive states of one
  array from separate arrays, then recognizing the two groups and restoring
  each group's internal order.
- **C — Writing:** Jeff wrote the main function, helper, pointer updates, and
  group bounds. `shift - 1` needed reinforcement as a count-to-index conversion.
  The compiling attempt returned an unused reversed view instead of reversing
  the original array before the group passes.
- **Debugging:** Example 1 produced `[3,2,1,7,6,5,4]` instead of
  `[5,6,7,1,2,3,4]`. The compiler's unused-`reversedArray` warning identified
  work disconnected from the output. Replacing that line with the whole-array
  helper call made all 15 tests pass.
- **Credit:** the coach supplied the reversal strategy and pseudocode at Jeff's request.
  Jeff wrote the helper and group calls. At the time limit, Jeff requested a
  direct fix; the coach corrected the whole-array pass and changed the
  unmodified `shift` variable to `let`. This was coached, not a cold solve.

## Idiom notes

- **Swift:** `reversed()` returns a reversed view; it does not modify the array.
  `reverse()` mutates the whole collection, while this solution reuses the
  range helper for all three passes. No separate keeper or temporary array is needed.
- **`inout`:** pass `&nums` to the helper to modify the same array.
- **Parameters are immutable:** copy the range bounds into local `var left`
  and `var right` before moving them.
- **`let` versus `var`:** `shift` is calculated once and never changes, so it
  is a constant. The moving indices are variables.
