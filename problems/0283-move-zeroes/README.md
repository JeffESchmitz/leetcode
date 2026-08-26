# 283. Move Zeroes

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/move-zeroes/

Given an integer array `nums`, move all `0`'s to the end of it while
maintaining the relative order of the non-zero elements.

**Note** that you must do this in-place without making a copy of the array.

**Example 1:**
```
Input:  nums = [0,1,0,3,12]
Output: [1,3,12,0,0]
```

**Example 2:**
```
Input:  nums = [0]
Output: [0]
```

Constraints:
- `1 <= nums.length <= 10^4`
- `-2^31 <= nums[i] <= 2^31 - 1`

**Follow up:** Could you minimize the total number of operations done?

## Approach

**This is a two-pointer (read/write) problem solved by in-place compaction in
`O(n)` time and `O(1)` space.**

### The goal, precisely

Nothing is returned. The signature is `(_ nums: inout [Int]) -> Void`, and the
output is the **side effect**: the caller's array, rearranged. `inout` is Swift's
way of letting a function write back into the caller's variable — the `&` at the
call site (`moveZeroes(&nums)`) is the caller consenting. Every prior problem in
this repo was "compute and return"; this one is "mutate and go quiet." No
`filter`, no second array.

### The insight

**Zeros are interchangeable; non-zeros are ordered.** The statement never says
*which* zero goes where — it only says the non-zeros keep their relative order.
So track the non-zeros, not the zeros. Zeros are what you skip; non-zeros are
what you *place*.

### The trap first: swapping toward the end reverses

The first instinct was to find each zero and swap it with a pointer walking in
from the right:

```
[0, 1, 0, 3, 12]      zeros at 0 and 2, j starts at 4
swapAt(0, 4)   →   [12, 1, 0, 3, 0]     j = 3
swapAt(2, 3)   →   [12, 1, 3, 0, 0]     j = 2
                     ↑
       non-zeros came out 12, 1, 3 — expected 1, 3, 12
```

The zeros land correctly and the non-zeros come out **back to front**. The first
keeper flung to the right is the *last* one you'll ever see, and the next lands
just left of it. This is not an off-by-one you can patch — it is the direction of
the algorithm. Any in-place problem that says *maintain relative order* has this
trap in it.

### The fix: fill from the left, hunt non-zeros

Two indices moving the same direction:

- `readIndex` — the clock. Visits every slot, `0` to `n - 1`, in lockstep with
  the loop.
- `writeIndex` — the next slot a non-zero belongs in. Starts at `0`, advances
  **only** when a keeper is placed.

```
writeIndex = 0
for readIndex in nums.indices
    if nums[readIndex] != 0
        swap slots readIndex and writeIndex
        writeIndex += 1
```

Traced on Example 1:

| `readIndex` | `nums[readIndex]` | action | array after | `writeIndex` |
|---|---|---|---|---|
| 0 | `0` | skip | `[0, 1, 0, 3, 12]` | 0 |
| 1 | `1` | `swapAt(1, 0)` | `[1, 0, 0, 3, 12]` | 1 |
| 2 | `0` | skip | `[1, 0, 0, 3, 12]` | 1 |
| 3 | `3` | `swapAt(3, 1)` | `[1, 3, 0, 0, 12]` | 2 |
| 4 | `12` | `swapAt(4, 2)` | `[1, 3, 12, 0, 0]` | 3 |

Swap leaves nothing to clean up: every keeper moved forward pushes a zero
backward in the same motion, so when `readIndex` runs off the end the zeros are
already in place.

### The invariant that makes mutating-while-iterating safe

Snapshot of `[4, 0, 3, 0, 2, 0, 1]` at `readIndex = 4`:

```
            writeIndex=2       readIndex=4
                 ↓                 ↓
     [ 4,  3, |  0,  0,  |  2,  0,  1 ]
       ──────   ────────    ─────────
       settled    zeros       unread
```

Three regions, always in this order:

- **Left of `writeIndex`** — non-zeros in original order, final. Never touched
  again.
- **Between the two** — only zeros, each one shoved here by a swap.
- **From `readIndex` on** — exactly as the caller handed it in. No swap has ever
  reached here, because both swap targets are `<= readIndex`.

**The swap only reaches backward.** That is why the loop can mutate the array
while walking it — the unread part is pristine — and why `writeIndex` always
sits on a zero once the two indices separate: the middle region *is* the zeros.

`readIndex - writeIndex` equals the number of zeros seen so far, and that count
never goes down. The two start together, separate at the first zero, and never
rejoin — `writeIndex` cannot get ahead because `readIndex` gains one every step
and `writeIndex` gains at most one.

### Why not "bubble it left"

A correct alternative: each non-zero shuffles left one slot at a time until it
butts up against another non-zero. Worst case `[0, 0, 0, 0, 1]` walks that `1`
across four zeros; with `n` keepers each walking `~n` zeros that is `O(n²)`.
`writeIndex` is *exactly the slot the bubble would have stopped at* — it is the
memory of where the walk would end, so you jump instead of walking.

`n <= 10^4` means `n² = 10^8` would actually pass the judge. `O(n)` is the
target because it is right, not because the constraint forces it.

### The follow-up: minimize operations

Until the first zero is passed, `readIndex == writeIndex` and every swap is
`swapAt(i, i)` — three memory operations that change nothing. On `[1, 2, 3, 4]`
that is `n` wasted swaps. One guard skips them:

```swift
if readIndex != writeIndex {
    nums.swapAt(readIndex, writeIndex)
}
writeIndex += 1          // outside the guard — the keeper is home either way
```

The guard is exactly the test for "have we passed a zero yet." The slip to avoid
is putting `writeIndex += 1` *inside* the guard: then `[1, 2, 3]` never advances
it, and the first zero swaps with slot `0` and clobbers a keeper. `noZeros` and
`zerosAlreadyAtEnd` exist to catch that.

Overwrite (`nums[writeIndex] = nums[readIndex]`) is the other valid shape: one
write per keeper, then a second short loop to zero-fill `nums[writeIndex..<n]`.
Same complexity; swap does it in one pass.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `1 <= nums.length` | **promise that does no work** | the loop handles `n = 0` on its own — no guard to delete |
| `nums.length <= 10^4` | **hint** | `O(n²)` would survive; `O(n)` because it is right |
| `-2^31 <= nums[i] <= 2^31 - 1` | **hint** | values fit `Int32`, trivially Swift's `Int`; no line of the algorithm compares or adds values, so nothing leans on it. The lower bound's real job is to warn that **negatives are coming** — the test is `!= 0`, never `> 0` |

**The tell for a promise:** removing it would let a real input produce a
confident wrong answer. Hand this loop `2^40` and it still works. Contrast
[643](../0643-maximum-average-subarray-i/README.md), where the value bound
decided whether the running sum could overflow.

### Complexity

- **Time:** `O(n)` — one pass, `O(1)` per element.
- **Space:** `O(1)` — two `Int` indices; the array is the storage.

### Idiomatic vs. arithmetic, with numbers

Two ways to write the same loop:

```swift
for readIndex in 0..<nums.count {          // arithmetic
    if nums[readIndex] != 0 { … }
}

for readIndex in nums.indices {            // idiomatic
    guard nums[readIndex] != 0 else { continue }
    …
}
```

Measured (release build, 1,000,000 elements, `ContinuousClock` +
`mach_task_basic_info`): **0.5552 ms vs 0.5557 ms, zero heap delta** — the
optimizer folds `nums.indices` to `0..<count` and `guard … continue` to the
same branch as `if`. Noise. So the choice is purely readability, and
`indices` + `guard` wins: `indices` says "every valid index" without arithmetic
to trust, and the early `continue` flattens the keeper path so it reads straight
down — *not a zero → maybe swap → advance*.

## Reflection

**Where the time went.** A (understanding) was fast — `inout` was the only speed
bump, and it was vocabulary, not concept. C (writing) was minutes; the
pseudocode came out nearly as final code. **B (identifying) ate the session**,
and split across two sittings that behaved very differently.

**Session one, tired, late, one beer:** an idea explosion. Several early "aha"
moments were really *partial* solutions seen through a veil — enough of the
shape to feel like progress, not enough to aim by. The reverse-swap came out of
that sitting, and so did the bubble. Both were things already known to be wrong
("this is arrays 101," with the sick feeling to match) — knowing better did not
stop trying them. **Session two, morning, coffee:** the write pointer in one
pass. That is data about *when* B is expensive, not about whether it can be
done.

**The lesson that transfers: swapping toward the far end reverses order.**
Already known, tried anyway, recognized instantly on the trace. The value of
this pass was not learning it but **watching it get tried under fatigue** —
the failure mode is not ignorance, it is running the known-bad idea because it
is the first one that moves.

**The read/write invariant was the genuinely new thing, and it stayed fuzzy
after solving.** The unblocking picture was the three-region snapshot above —
*settled | zeros | unread* — and the one sentence that anchors it: **the swap
only reaches backward.** Everything right of `readIndex` is untouched, so
mutating while iterating is safe. Worth re-reading before 26 and 27, which use
the identical skeleton.

**The follow-up guard was not seen unaided.** Honest note: "before the first
zero the two indices are equal, so those swaps are no-ops" is a sentence that
made sense *after* explanation and would not have surfaced in an interview.
The interview move is not to have it memorized — it is to hear "minimize
operations" and *go looking for waste*: "which iterations do work that changes
nothing?"

**A `print` inside the loop was an `O(n)` operation inside an `O(n)` loop.**
`"\(nums)"` formats all 10,000 elements every call; 20,000 calls on the
upper-bound test is ~100 MB of string building and locked the terminal. The
instinct — "is there a nested loop in there?" — was exactly right. There was;
it just was not written as one. *Nested loops multiply* applies to the loops
you did not know you wrote. Trace on the 5-element example, delete the prints
before running the suite, or filter: `swift test --filter example1`.

**Two AI assists, graded.** A Gemini-produced hand trace of the swap loop
(mechanical, after the insight was already in hand — fine) and a Copilot
benchmark of `indices`/`guard` vs `0..<count`/`if` (the right kind of evidence,
correct conclusion). The benchmark also left two solution functions and a Mach
timing harness in the leaf, which had to be stripped before commit. The
finding goes in the README; the harness does not.

**Synthesis — three two-pointer flavors now in the repo:**

| problem | pointers | motion |
|---|---|---|
| [125. Valid Palindrome](../0125-valid-palindrome/README.md) | `left`, `right` | both ends, inward |
| [141. Linked List Cycle](../0141-linked-list-cycle/README.md) | `slow`, `fast` | same direction, different speeds |
| **283. Move Zeroes** | `read`, `write` | same direction, **write lags read** |

The read/write pair is the **compaction** shape: read visits everything, write
advances only on keepers, and the gap between them is the count of things
discarded so far.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
10