# 643. Maximum Average Subarray I

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/maximum-average-subarray-i/

You are given an integer array `nums` consisting of `n` elements, and an
integer `k`.

Find a contiguous subarray whose **length is equal to** `k` that has the
maximum average value and return _this value_. Any answer with a calculation
error less than `10^-5` will be accepted.

**Example 1:**
```
Input:  nums = [1,12,-5,-6,50,3], k = 4
Output: 12.75
```
Maximum average is `(12 - 5 - 6 + 50) / 4 = 51 / 4 = 12.75`.

**Example 2:**
```
Input:  nums = [5], k = 1
Output: 5.00000
```

Constraints:
- `n == nums.length`
- `1 <= k <= n <= 10^5`
- `-10^4 <= nums[i] <= 10^4`

## Approach

**This is a fixed-size sliding-window problem solved with a running sum in
`O(n)` time and `O(1)` space.**

### The shape

`k` never changes. The window does not grow or shrink — it **slides**, always
exactly `k` wide, across `n - k + 1` positions:

```
nums = [ 1, 12, -5, -6, 50,  3 ]        k = 4
index    0   1   2   3   4   5

  ┌──────────────────┐
  │ 1  12  -5  -6 │ 50   3        sum = 2      avg = 0.5
  └──────────────────┘
      ┌──────────────────┐
   1  │12  -5  -6  50 │  3        sum = 51     avg = 12.75   ← max
      └──────────────────┘
          ┌──────────────────┐
   1  12  │-5  -6  50   3 │       sum = 42     avg = 10.5
          └──────────────────┘
```

The window count falls out of the left edge: it starts at `0` and its last
legal position is `n - k`, so there are **`n - k + 1`** windows. That formula
is for *reasoning about cost* — it never appears in the code, because the loop
walks the right edge and lets the count take care of itself.

### Why brute force dies — and where

Re-summing each window from scratch is `O(n × k)`. The real cost is
`(n - k + 1) × k`, and the shape of that is the interesting part:

| `k` | windows | work each | total |
|---|---|---|---|
| `1` | 100,000 | 1 | **10⁵** ⚡ |
| `1,000` | 99,001 | 1,000 | **~10⁸** ⚠️ |
| `50,000` | 50,001 | 50,000 | **~2.5 × 10⁹** 💀 |
| `100,000` | **1** | 100,000 | **10⁵** ⚡ |

**Brute force is fast at both extremes and catastrophic in the middle**,
peaking near `k = n/2` at roughly `n²/4`. At `k = n` there is only one window
— nothing to slide — so the worst case is *not* at the largest `k`. Checking
only the endpoints of a constraint range would have declared this approach
safe. Push to the middle too.

### The slide

Consecutive windows share `k - 1` elements. Brute force re-adds every one of
them — paying `k` to learn something that changed by **two numbers**:

```
window at i=1:      12  -5  -6  50
window at i=2:          -5  -6  50   3
                        └── shared ──┘

newSum = oldSum - nums[i - k] + nums[i]
                      ↑             ↑
                   leaving       entering
```

`O(1)` per slide. Same instinct as
[724](../0724-find-pivot-index/README.md) — *do not recompute what you already
know* — but where 724 **grew** a prefix by accumulation, this one **slides** a
fixed span: subtract the departure, add the arrival.

Traced on Example 1:

| `i` | leaves | enters | `windowSum` | `maxSum` |
|---|---|---|---|---|
| *seed* | — | — | `2` | `2` |
| `4` | `nums[0] = 1` | `nums[4] = 50` | `2 - 1 + 50 = 51` | **`51`** |
| `5` | `nums[1] = 12` | `nums[5] = 3` | `51 - 12 + 3 = 42` | `51` |

`Double(51) / Double(4) = 12.75`. ✅

### Three traps, all in the tests

**Seed before you slide.** `windowSum` must hold the *first window's* sum, not
`0` — you cannot slide off nothing. A `0` seed makes the first slide
`0 - nums[0] + nums[k]`, silently omitting the middle of the window and
poisoning every later step.

**Seed `maxSum` too.** Starting it at `0` fails when every window sum is
negative, because `0` beats them all. `k <= n` promises a window exists, so
there is always a real value to start from — this is why the signature is
`-> Double` and not `-> Double?`, with no sentinel and no empty case.

**Stay in `Int`; convert once, at the boundary.** `windowSum / k` is integer
division and truncates `12.75` to `12` with no warning. Beyond that: you
*could* carry a running average as a `Double` and adjust it per slide, and it
would work — but every floating-point add nudges in error, and across `10^5`
slides those nudges accumulate. **Integer addition is exact.** Accumulate in
`Int`, divide exactly once.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `n == nums.length` | **neither** | notation — it only names `n` |
| `k <= n <= 10^5` | **hint** | `~2.5 × 10⁹` worst case kills `O(n × k)`; target `O(n)` |
| `1 <= k` | **promise** | `k` is never `0` — the final division is always safe |
| `k <= n` | **promise** | at least one window always exists ⇒ no empty case, no sentinel, non-optional return |
| `-10^4 <= nums[i] <= 10^4` | **hint** | worst window sum `10^5 × 10^4 = 10^9`, which fits a **32-bit** `int` (ceiling `≈ 2.1 × 10^9`) with ~2× headroom, and Swift's 64-bit `Int` with room to spare |

**One line of constraints can carry both kinds.** `1 <= k <= n <= 10^5` is
three separate statements stapled together: `<= 10^5` is a sizing hint, while
`1 <= k` and `k <= n` are load-bearing promises that delete guards. Read
compound constraints apart, not as a unit.

### Complexity

- **Time:** `O(n)` — `k` for the seed, then `n - k` slides at `O(1)` each.
- **Space:** `O(1)` — two `Int`s. `nums[0..<k]` is an `ArraySlice`, a view over
  existing storage, not a copy.

### On `nums[0..<k].reduce(0, +)`

`0..<k` is a half-open range (`0` through `k-1`), so the slice is exactly one
window. `reduce(0, +)` folds it to a single value, starting from `0` — the
**identity** for addition, so the starting value cannot contaminate the
result. Same shape as [136](../0136-single-number/README.md)'s
`nums.reduce(0, ^)`, where `0` is likewise XOR's identity. Note the two zeroes
in play are different things: `reduce`'s `0` is where the summing *starts*,
whereas seeding `windowSum = 0` would be a false *claim about the data*.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
