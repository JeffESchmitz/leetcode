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

## Reflection

**Where the time went.** Step 1 (goal) was quick and mostly self-driven — the
`Double` return type, the "max over windows" framing, and the no-tie-breaking
call all landed without prompting. The bulk of the session went to **step 3,
constraints**, and that was time well spent rather than time lost: it is where
the algorithm was actually decided.

**The standout moment was running the escalation unprompted.** Given `k = 4`
and `n = 10^5`, the first instinct was "400,000 operations, that's fine" — true,
and a trap, because `k = 4` was one example's value, not a constraint. The move
that mattered was refusing to stop there: push `k` to 1,000, then to `n`, and
watch `O(n × k)` become `10^10`. **Reading a constraint as a range of scenarios
rather than as the one number in front of you** is the habit; the specific
arithmetic is disposable.

**Then the correction that sharpened it.** `k = n` is actually the *fast* case —
at `k = n` there is exactly one window, so nothing slides and the cost is `O(n)`.
The true cost is `(n - k + 1) × k`, which peaks in the *middle* of the range at
`≈ n²/4`. Testing only the endpoints of a constraint would have cleared brute
force. Promoted to `COACH.md` as its own lesson.

**Vocabulary that mattered.** Calling the windows "permutations" was one wrong
word doing real damage: a permutation is a *reordering*, and reordering is
exactly what "contiguous" forbids. It also inflates the search space from
`n - k + 1` to something factorial. Saying **window** keeps the problem small.
Same family as the *sorting is off the table* rule.

**The line that tripped things up was not the one expected.** `reduce` was
already familiar from [136](../0136-single-number/README.md)'s
`nums.reduce(0, ^)`. The unfamiliar half of `nums[0..<k].reduce(0, +)` was the
**slice** — that subscripting an array with a range yields an `ArraySlice`, a
view over existing storage rather than a copy. Worth naming precisely, because
"I don't understand this line" was really "I don't understand this *half* of
this line."

**Analysis facts vs. implementation facts.** The window-count formula
`n - k + 1` took several passes to land, and then never appeared in the code —
the loop walks the right edge and lets the count take care of itself. Some
facts exist to decide *whether an approach survives*; others exist to *be
typed*. Missing one of the first kind costs nothing at the keyboard.

**Compound constraints carry both kinds.** `1 <= k <= n <= 10^5` was initially
graded as a single "hint." It is three statements stapled together: `<= 10^5`
is a sizing hint, while `1 <= k` and `k <= n` are load-bearing promises that
delete guards (no divide-by-zero, no empty case, non-optional return). Read
them apart.

**The histogram made the metrics lesson visible.** The accepted submission
scored *runtime 0 ms, beats 100%* and *memory 22.62 MB, beats 6.90%* — and the
two charts sitting side by side answered which number to care about:

```
Runtime axis:    0ms ──────────────────────► 1334ms      spread ≈ 1300×
Memory  axis:  21.3mb ─────────────────────►  22.4mb     spread ≈ 1.05×
```

The runtime spread is three orders of magnitude because it separates `O(n)`
from `O(n × k)` — real, and earned. The entire memory distribution fits in
1.1 MB, a floor set by the Swift runtime and the judge-allocated input array,
against which two `Int`s are invisible. A follow-up hypothesis — *is it because
we use a `struct` and others use a `class`?* — was ruled out twice over: the
submitted code *was* a `class`, and a class instance costs ~32 bytes against
22.6 MB either way.

**The test that generalizes:** not "is this metric speed or memory," but
**"is the spread wide enough that my choices could move it?"** Promoted to the
root README.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
