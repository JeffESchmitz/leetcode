# 169. Majority Element

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/majority-element/](https://leetcode.com/problems/majority-element/)

## Problem

Given an array `nums` of size `n`, return *the majority element*.

The majority element is the element that appears more than `⌊n / 2⌋` times. You may assume that the majority element always exists in the array.

**Example 1:**
```
Input: nums = [3,2,3]
Output: 3
```

**Example 2:**
```
Input: nums = [2,2,1,1,1,2,2]
Output: 2
```

**Constraints:**
- `n == nums.length`
- `1 <= n <= 5 * 10^4`
- `-10^9 <= nums[i] <= 10^9`

**Follow-up:** Could you solve the problem in linear time and in `O(1)` space?

## Approach

_Worked through the 8-step framework from `COACH.md`. Filled in as we go._

1. **GOAL** — an `Int`: the *value* that appears more than `⌊n/2⌋` times. Not an
   index, not a count, not an optional — the function is total, because the problem
   guarantees a majority element exists.

   Three spellings of "is a majority" are equivalent for integers, and the doubled
   form is the one that does real work:

   ```
   count > ⌊n/2⌋        ⟺        count > n/2        ⟺        2·count > n
   ```

   Why the floor washes out — `count` and `⌊n/2⌋` are both integers, so
   `count > ⌊n/2⌋` means `count ≥ ⌊n/2⌋ + 1`:

   ```
   n even, n = 2k:   ⌊n/2⌋ = k → count ≥ k+1 → 2·count ≥ 2k+2 = n+2 > n   ✓
   n odd,  n = 2k+1: ⌊n/2⌋ = k → count ≥ k+1 → 2·count ≥ 2k+2 = n+1 > n   ✓
   ```

   **No tie-breaking rule is needed, and that is a theorem rather than a courtesy
   of the problem statement.** The guarantee says *at least one* majority exists;
   it is silent on *at most one*. Uniqueness has to be proved separately:

   > Suppose value `x` occurs `a` times and value `y` occurs `b` times, `x ≠ y`,
   > and both are majorities. Then `2a > n` and `2b > n`. Adding:
   > `2(a + b) > 2n`, so `a + b > n`. But `x ≠ y` means no slot holds both, so the
   > `a` slots and the `b` slots are disjoint subsets of the same `n` slots, giving
   > `a + b ≤ n`. Both cannot hold. ∎

   Equivalently: the cheapest possible majority costs `⌊n/2⌋ + 1` slots, so two of
   them cost `2⌊n/2⌋ + 2` — which is `n + 2` for even `n` and `n + 1` for odd `n`.
   Even the two smallest majorities overflow the array. There is never room.

   Note how tight that is at odd `n`: it overflows by exactly **1**. Majority is a
   one-vote-of-slack property, which is what the 1001-element fixture pins down.

   Same lesson as [704. Binary Search](../0704-binary-search/README.md), where
   uniqueness is what made an arbitrary landing spot a *correct* answer:
   **uniqueness is what lets you stop caring which one you found.**
2. **SHAPE** — `[Int]`. Unsorted, repeats allowed, and **no positional guarantee** —
   nothing says the majority occurrences are clustered, centered, or anywhere in
   particular. So no "just look at position `k`" shortcut exists *on the input as
   given*. (Worth revisiting once you're willing to rearrange it first.)

   Mutation, mechanically: the parameter is `[Int]`, a value-type struct, and it is
   not `inout` — so `nums` is a `let` inside the body and `nums[0] = 99` will not
   compile. `var local = nums` or `nums.sorted()` is legal and the caller's array is
   untouched, but copy-on-write means the first write triggers a **full O(n)
   duplication**. Sorting is therefore *permitted* but not *free*: O(n) extra space
   and O(n log n) time. "I'm allowed to sort" and "I can afford to sort" are
   different sentences — and the `O(1)`-space follow-up is asking about the second.
3. **CONSTRAINTS** — _TBD_
4. **SIGNATURE** — _TBD_
5. **EXAMPLE TRACE** — _TBD_
6. **PATTERN → ALGORITHM** — _TBD_
7. **EDGE CASES** — _TBD_
8. **DATA STRUCTURES** — _TBD_

**This is a [PATTERN] problem solved with [ALGORITHM] in [BIG-O].**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Test fixtures

Every fixture honors the problem's guarantee that a majority element exists, so
no test depends on undefined behavior when it doesn't.

| Case | Why it's there |
|---|---|
| `[3,2,3]`, `[2,2,1,1,1,2,2]` | the two given examples |
| `[1]` | smallest legal input; the lone element is trivially the majority |
| `[4,4]` | even `n`: 2 > ⌊2/2⌋ = 1 |
| `[7,7,7,7]` | no minority elements at all |
| `[5,5,5,1,2]` / `[1,2,5,5,5]` | majority bunched at one end — catches position assumptions |
| `[1,2,1,2,1]` | majority never appears twice in a row — kills "longest run" thinking |
| `[-1,-1,-1,2,3]` | negative values |
| 1001 elements, interleaved | majority clears ⌊n/2⌋ by exactly one vote, maximally spread out |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **When two forms are equivalent, prefer the one that mirrors how the problem
    states it.** The majority test can be written either way:

    ```swift
    2 * tally > nums.count      // "twice this exceeds the whole"
    tally > nums.count / 2      // "this exceeds half"
    ```

    They agree on every input. They are not equally trustworthy. The first is the
    problem's sentence transcribed — nothing is computed, nothing is discarded. The
    second invents `nums.count / 2`, a quantity that appears nowhere in the problem,
    and then relies on integer division truncating in your favor: `7 / 2 == 3`, the
    `.5` silently gone. That truncation *does* land correctly here (it is exactly
    `⌊n/2⌋`), but "correct because I checked the rounding" is a weaker guarantee than
    "correct because there was no rounding."

    The tell is the near-miss. `tally >= nums.count / 2` is wrong — at `n = 7` it
    accepts a tally of 3 — and it looks completely reasonable on the page. The
    doubled form has no such neighbor. Overflow isn't a concern either: `n ≤ 5×10⁴`
    caps `2 * tally` near 10⁵ against a 64-bit `Int`.

    Same shape as `low + (high - low) / 2` over `(low + high) / 2` in
    [704. Binary Search](../0704-binary-search/README.md): **the form that cannot go
    wrong beats the form that merely happens not to.**
  - **Naming: `count` was already taken.** `nums.count` means `n`, so reusing `count`
    for a single value's occurrences puts two different quantities behind one word at
    the exact moment the distinction matters. `tally` keeps them apart.
