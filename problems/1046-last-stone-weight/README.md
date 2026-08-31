# 1046. Last Stone Weight

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/last-stone-weight/

You are given an array of integers `stones` where `stones[i]` is the weight
of the `i`th stone.

We are playing a game with the stones. On each turn, we choose the
**heaviest two stones** and smash them together. Suppose the heaviest two
stones have weights `x` and `y` with `x <= y`. The result of this smash is:

- If `x == y`, both stones are destroyed, and
- If `x != y`, the stone of weight `x` is destroyed, and the stone of
  weight `y` has new weight `y - x`.

At the end of the game, there is at most one stone left.

Return the weight of the last remaining stone. If there are no stones
left, return `0`.

**Example 1:**
```
Input:  stones = [2,7,4,1,8,1]
Output: 1
Explanation:
We combine 7 and 8 to get 1, so the array converts to [2,4,1,1,1] then,
we combine 2 and 4 to get 2, so the array converts to [2,1,1,1] then,
we combine 2 and 1 to get 1, so the array converts to [1,1,1] then,
we combine 1 and 1 to get 0, so the array converts to [1], then that's the
value of the last stone.
```

**Example 2:**
```
Input:  stones = [1]
Output: 1
```

Constraints:
- `1 <= stones.length <= 30`
- `1 <= stones[i] <= 1000`

## Approach

**Heap-based simulation ("top-k" pattern) — `O(n log n)` time, `O(n)` space.**

### The goal, precisely

No `inout` in the signature (`func lastStoneWeight(_ stones: [Int]) -> Int`),
unlike [26](../0026-remove-duplicates-from-sorted-array/README.md) and
[283](../0283-move-zeroes/README.md). Swift function parameters are `let` by
default, so the input can't be mutated in place at all — any working copy has
to be made explicitly (`var stones = stones`, or, as shipped, handed straight
into a fresh `Heap`).

### The pattern: repeatedly ask "what are the two biggest?"

Every round needs the current two heaviest stones, then possibly feeds one
new stone back in. Re-sorting the whole array each round would work too
(`stones.length <= 30` makes that entirely affordable — a hint, not a
promise), but the structural fit is a **max-heap**: `O(log n)` to pop the
largest and `O(log n)` to insert a result back in, instead of re-deriving
"what's biggest" from scratch every round.

### Idiom note: Swift has no built-in heap

Unlike Python's `heapq` or Java's `PriorityQueue`, the Swift standard library
ships no priority queue. This solution pulls in Apple's
[`swift-collections`](https://github.com/apple/swift-collections) package for
its `Heap<Element>` type (`popMax()`, `insert(_:)`, `.max`, `.count`) rather
than hand-rolling one. First problem in this repo with an external
dependency.

### The loop

```swift
var heap = Heap(stones)

while heap.count > 1 {
    let y = heap.popMax()!  // heaviest
    let x = heap.popMax()!  // 2nd heaviest — heap guarantees x <= y
    if y != x {
        heap.insert(y - x)
    }
    // y == x: both destroyed, nothing to re-insert
}

return heap.popMax() ?? 0
```

The heap's own pop order does work a naive reading might miss: because `y` is
popped *before* `x`, `y >= x` is guaranteed by construction — there's no need
for a separate "what if the second-heaviest turns out bigger" branch. The
only remaining question is equality: `y == x` destroys both for free (nothing
re-inserted); otherwise `y - x` (always `>= 0`) goes back in as a new stone.
`heap.popMax() ?? 0` on the way out handles both "one stone left" and "zero
stones left" in a single expression.

### Complexity

- **Time:** `O(n log n)` — n pops/inserts, `O(log n)` each.
- **Space:** `O(n)` — the heap holds the stones.

## Reflection

Time-boxed session (~20 minutes). GOAL and the smash mechanics came fast —
the description of the smash rule was correct on the first pass. Identify
(the data-structure choice) was the genuine struggle: several structures were
considered and discarded before landing on "heap," with real self-doubt
("Heap? no... can't be...") before confirming it. That
hesitation-then-confirmation is itself useful signal — the right instinct
arrived before the confidence to trust it did.

One thing worth flagging for next time: after committing to a heap, the
question "what if the second-popped stone is bigger than the first?" came up
as a hypothetical extra branch. It isn't needed — the heap's pop order
already guarantees the first pop is `>=` the second — but it's a reasonable
question to ask *out loud before* trusting a data structure's invariant
rather than after. A hand-drawn flowchart settled it correctly without the
extra branch, which is a good sign for the holistic "see the whole shape"
habit this repo leans on.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
