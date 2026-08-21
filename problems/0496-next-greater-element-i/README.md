# 496. Next Greater Element I

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/next-greater-element-i/

The **next greater element** of some element `x` in an array is the *first
greater element that is to the right of* `x` **in the same array**.

You are given two distinct 0-indexed integer arrays `nums1` and `nums2`, where
`nums1` is a subset of `nums2`.

For each `0 <= i < nums1.length`, find the index `j` such that
`nums1[i] == nums2[j]` and determine the **next greater element** of `nums2[j]`
in `nums2`. If there is no next greater element, then the answer for this query
is `-1`.

Return an array `ans` of length `nums1.length` such that `ans[i]` is the next
greater element as described above.

**Example 1:**
```
Input:  nums1 = [4,1,2], nums2 = [1,3,4,2]
Output: [-1,3,-1]
```
- `4` sits in `nums2 = [1,3,4,2]`. Nothing to its right is greater → `-1`.
- `1` sits in `nums2 = [1,3,4,2]`. The next greater element is `3`.
- `2` sits in `nums2 = [1,3,4,2]`. Nothing to its right is greater → `-1`.

**Example 2:**
```
Input:  nums1 = [2,4], nums2 = [1,2,3,4]
Output: [3,-1]
```
- `2` sits in `nums2 = [1,2,3,4]`. The next greater element is `3`.
- `4` sits in `nums2 = [1,2,3,4]`. Nothing to its right is greater → `-1`.

Constraints:
- `1 <= nums1.length <= nums2.length <= 1000`
- `0 <= nums1[i], nums2[i] <= 10^4`
- All integers in `nums1` and `nums2` are **unique**.
- All the integers of `nums1` also appear in `nums2`.

**Follow up:** Could you find an `O(nums1.length + nums2.length)` solution?

## Approach

**The question never depends on `nums1`.** "What is the next greater element of
`x`?" is a fact about `nums2` alone — that relationship exists among `nums2`'s
elements whether anyone asks about it or not. `nums1` only decides *which* of
those answers get reported. That observation splits the problem in two:

1. **Precompute** every answer in one pass over `nums2`.
2. **Look up** each value of `nums1`. `n` dictionary hits, no scanning.

Which is `O(m) + O(n)` = **`O(n + m)`**, the follow-up's target.

**Sorting is disqualified.** "Next greater" is defined over *position* as well as
value. Sorting preserves the multiset and destroys the ordering, so it answers a
different question: sorted `[1,2,3,4]` claims `2 → 3`, while in the real
`[1,3,4,2]` the `2` is last and the answer is `-1`.

**The precompute pass — a monotonic stack.** Walk `nums2` left to right holding
a stack of values still waiting for a larger successor. That stack is always
descending, and it stays that way for free: any arrival larger than the top pops
it, so nothing small can ever sit beneath something smaller still.

When `value` arrives, it is the answer for every waiting element it exceeds —
settled nearest-waiter-first, which is exactly LIFO, which is why the structure
is a stack rather than a queue. Whatever remains on the stack is too large for
`value`, so it keeps waiting.

Trace on `[5, 4, 3, 2, 1, 3]`:

| arrival | pops (answer = arrival) | stack after |
|---|---|---|
| 5 | — | `[5]` |
| 4 | — | `[5,4]` |
| 3 | — | `[5,4,3]` |
| 2 | — | `[5,4,3,2]` |
| 1 | — | `[5,4,3,2,1]` |
| 3 | `1 → 3`, `2 → 3` | `[5,4,3,3]` |

`5`, `4` and the first `3` never get an answer and stay on the stack at the end —
correctly, since nothing larger ever follows them.

The inner `while` looks quadratic but isn't: each element is pushed exactly once
and popped at most once, so the pass is **O(m) amortized**.

**Absence beats a sentinel.** Elements with no answer are simply left out of the
dictionary, so the lookup returns `nil` naturally and `?? -1` applies the judge's
required sentinel once, at the boundary. `-1` is only safe here because the
constraints promise non-negative values; allow negatives and it becomes
ambiguous with a real answer, and the return type should widen to `[Int?]`.

**Which constraints are load-bearing:** uniqueness (a value maps to one position,
so `[value: answer]` is well-defined), the subset guarantee (every lookup
succeeds, so no "not found" branch and the return stays `[Int]`), and the
non-negative lower bound (makes `-1` unambiguous). The size bound `≤ 1000` is
merely a hint — brute force at 10⁶ operations passes comfortably.

**Brute force, for the record:** for each query, `firstIndex(of:)` then walk the
tail. `O(n · m)`, accepted by the judge. On 1000 descending values it does about
500,000 inspections (36 ms in this repo's test suite) versus roughly 2,000 for
the stack version (1 ms).

Complexity: **O(n + m) time, O(m) space.**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** — a `Dictionary` returning `Optional` on a missing key does the
  sentinel work for free: "this element has no next greater" is modeled by simply
  not storing the key, and `?? -1` converts to the judge's contract in one place.
  In C, where `-1` would be baked into every return path, that separation costs
  real effort. Also `while let waiting = pendingValues.last, waiting < value`
  reads as one condition and handles the empty-stack case in the same breath —
  no separate `isEmpty` guard.
