# 136. Single Number

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/single-number/

Given a **non-empty** array of integers `nums`, every element appears *twice*
except for one. Find that single one.

You must implement a solution with a **linear runtime complexity** and use
only **constant extra space**.

**Example 1:**
```
Input:  nums = [2,2,1]
Output: 1
```

**Example 2:**
```
Input:  nums = [4,1,2,1,2]
Output: 4
```

**Example 3:**
```
Input:  nums = [1]
Output: 1
```

Constraints:
- `1 <= nums.length <= 3 * 10^4`
- `-3 * 10^4 <= nums[i] <= 3 * 10^4`
- Each element in `nums` appears twice except for one element which appears
  exactly once.

## Approach

**Two promises the problem hands you for free.** "Non-empty" means there's no
`isEmpty` branch to write. "Every element appears twice except one" is a
*promise*, not a hint: a real, single answer always exists, so the return type
stays a plain `Int` — no `Optional`, no sentinel, no "not found" case anywhere.

**The complexity budget rules out "remember what I've seen."** Hitting O(n)
time *and* O(1) space simultaneously eliminates any approach built around
holding a growing collection of not-yet-matched candidates:

- A `Set`/`Dictionary` of seen values is O(n) space — it can hold up to `n`
  entries at its peak, right before the last pair resolves.
- A `Stack` of unmatched candidates has the same O(n) space problem, and gets
  *worse* on time: checking "have I seen this value" means scanning down the
  stack, an `O(n)` check per element, so `O(n²)` overall — worse than the
  `Set`, not better.
- Splitting into two stacks doesn't change either number; their combined size
  still scales with `n`.

The common thread: all three try to *remember* candidates until a partner
shows up. Any structure built around that job costs O(n) space by
construction, regardless of which container implements it.

**The escape is to remember nothing — fold the whole array through one
running value with XOR.** Three properties of bitwise XOR make this work:

1. `a ^ a = 0` for any `a` — a value XOR'd against itself always cancels to
   zero.
2. `a ^ 0 = a` — zero is XOR's identity element; combining with it changes
   nothing.
3. XOR is commutative and associative — order and grouping don't matter.

Property 3 is what makes the trick sound rather than coincidental: since
grouping is free, `nums.reduce(0, ^)` on `[4,1,2,1,2]` can be mentally
regrouped as

```
4 ^ (1 ^ 1) ^ (2 ^ 2)  =  4 ^ 0 ^ 0  =  4
```

Every matched pair cancels wherever it happens to sit in the array — nothing
is searched for, nothing is stored. Starting the accumulator at `0` (property
2) guarantees it can't corrupt the result; starting anywhere else folds in an
extra, uncancelled value that never had a partner and throws off the answer.

Complexity: **O(n) time, O(1) space** — one pass, one `Int` accumulator, no
container that grows with the input.

**Brute force, for the record:** compare every pair directly (nested loop) —
`O(n²)` time, but genuinely `O(1)` space, since it needs no auxiliary
structure at all. It's the one approach from this session that *does* satisfy
the space constraint; it just fails the time one, and would very likely time
out at `n = 30,000` (~4.5 × 10⁸ comparisons).

### Coaching progress (8-step Understand framework)

| # | Step | Status | Notes |
|---|------|--------|-------|
| 1 | GOAL | ✅ | Return the single un-paired `Int` itself — no sentinel, no `nil`. Guaranteed by the "twice except one" promise: a real answer always exists. |
| 2 | SHAPE | ✅ (implicit) | Flat `[Int]`, up to `3 * 10^4` elements. No nested structure to reason about. |
| 3 | CONSTRAINTS | ✅ | Promises: non-empty (no `isEmpty` branch needed), exactly one singleton (no "not found" case). Budget to hit: **O(n) time, O(1) space** — this ruled out Set (O(n) space), Stack (O(n) space), and two Stacks (O(n) space *and* O(n²) time from the linear inner scan). |
| 4 | SIGNATURE | ✅ | `func singleNumber(_ nums: [Int]) -> Int` — set at scaffold time, handed over up front as part of the problem picture. |
| 5 | EXAMPLE TRACE | ✅ | Traced `[4,1,2,1,2]` via XOR regrouping: `4^(1^1)^(2^2) = 4^0^0 = 4`. |
| 6 | PATTERN → ALGORITHM | ✅ | **Bit manipulation** — one running XOR fold over the array. `a^a=0`, `a^0=a`, and XOR is commutative/associative, so every matched pair cancels regardless of where it sits or what order it's visited in. |
| 7 | EDGE CASES | ✅ | Encoded in the test suite (single element, negatives, zero, non-terminal position, 14,999-pair upper bound) — all pass. The fold needs no special-casing for any of them: a single-element array is just `0 ^ x = x`. |
| 8 | DATA STRUCTURES | ✅ | None. One `Int` accumulator, no container — that absence *is* the O(1) space answer. Every container-based idea tried first (Set, Stack, two Stacks) failed on space, and the Stack ideas failed on time too. |

**One-liner:** This is a **bit-manipulation** problem solved with a **single XOR
fold** in **O(n) time, O(1) space**.

### Pseudocode

```
function singleNumber(nums):
    result = 0                     # XOR identity — the only starting value that can't corrupt the answer
    for each num in nums:
        result = result XOR num    # a value's second appearance cancels its first, regardless of order
    return result                  # only the value with no partner survives
```

**Status: solved.** `swift test` passes all 8 cases; accepted on LeetCode at
61/61 test cases, 0 ms runtime (beats 100%), 20.30 MB memory (typical for this
problem — see Idiom notes).

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** — `reduce`, not `map`, is the right higher-order function here,
  and the distinction is worth internalizing: `map` is *shape-preserving* (`n`
  elements in, `n` transformed elements out), while `reduce` *folds* `n`
  elements down to one accumulated value. This problem's shape is a fold —
  "combine everything into a single running result" — so `map` was never a
  fit, even though it's often the first higher-order function that comes to
  mind. Swift also lets an operator be passed directly as `reduce`'s combining
  function (`nums.reduce(0, ^)`), since operators are just functions with
  symbolic names — the same idiom as `nums.reduce(0, +)` for a sum.
- On the LeetCode judge itself, `reduce(0, ^)` and an equivalent explicit
  `for`-loop measured identically on runtime (0 ms) and within noise on memory
  — the memory distribution for this problem spans only ~19.3–20.5 MB across
  *all* accepted Swift submissions, so algorithm/style choice barely moves the
  needle at this `n`; Swift/harness overhead dominates the number.
