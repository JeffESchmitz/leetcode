# 724. Find Pivot Index

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/find-pivot-index/

Given an array of integers `nums`, calculate the **pivot index** of this
array.

The pivot index is the index where the sum of all the numbers **strictly to
the left** of the index is equal to the sum of all the numbers **strictly to
the right** of the index.

If the index is on the left edge of the array, the left sum is `0`, because
there are no elements to the left. This also applies to the right edge of the
array.

Return the **leftmost** pivot index. If no such index exists, return `-1`.

**Example 1:**
```
Input:  nums = [1,7,3,6,5,6]
Output: 3
```
The sum of the numbers to the left of index 3 (`1 + 7 + 3 = 11`) equals the
sum of the numbers to its right (`5 + 6 = 11`).

**Example 2:**
```
Input:  nums = [1,2,3]
Output: -1
```
No index satisfies the conditions.

**Example 3:**
```
Input:  nums = [2,1,-1]
Output: 0
```
The sum of the numbers to the left of index 0 is `0` (no elements). The sum
to the right is `1 + -1 = 0`.

Constraints:
- `1 <= nums.length <= 10^4`
- `-1000 <= nums[i] <= 1000`

## Approach

**This is a prefix-sum problem solved with a single accumulator pass in `O(n)`
time and `O(1)` space.**

### The geometry: three pieces, not two

Picture a wall standing on index `i`. The array splits into **three** parts —
the wall element belongs to neither side:

```
index:    0    1    2    3    4    5
nums:  [  1 ,  7 ,  3 ,  6 ,  5 ,  6  ]
                          ↑
                     wall at i = 3

   left of i  →  [ 1, 7, 3 ]        sum = 11
   nums[i]    →       6              ← in NEITHER sum
   right of i →           [ 5, 6 ]  sum = 11     ✅
```

Mechanically, for candidate `i`:

```
left side  =  indices  0   ..< i      (i excluded)
wall       =  index    i              (in neither sum)
right side =  indices  i+1 ..< n      (i excluded)
```

An empty side sums to `0`, so the edges are **ordinary cases, not exceptions**.
At `i = 0` the left side is empty and `leftSum == 0` — which is why
`[2, 1, -1]` returns `0` rather than `-1`.

### Brute force → one pass

Brute force re-sums both sides at every wall: `O(n²)`, with each wall
re-walking ground its neighbour just covered. The fix is the `COACH.md` rule —
**precompute once, then look answers up** — turning a `×` into a `+`.

Two equations, and keeping them straight *is* the problem:

| | Equation | True when? | Used for |
|---|---|---|---|
| **Identity** | `total = leftSum + nums[i] + rightSum` | **always**, at every index | rearranged to *compute* `rightSum` |
| **Test** | `leftSum == rightSum` | only at a pivot | the actual *question* asked |

Rearranging the identity:

```
rightSum = total - leftSum - nums[i]
```

Precompute `total` once, carry `leftSum` as a running accumulator, and the
right side is **never summed — not once**.

```swift
let total = nums.reduce(0, +)
var leftSum = 0
for (i, value) in nums.enumerated() {
    let rightSum = total - leftSum - value   // identity, rearranged
    if leftSum == rightSum { return i }      // the test
    leftSum += value                         // only NOW joins the left
}
return -1
```

The `leftSum += value` placement is load-bearing: `value` is left of the
*next* wall, not of this one. Hoisting it above the check shifts every answer
by one.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `1 <= nums.length <= 10^4` | **hint** | `(10^4)² = 10^8` — survivable but wasteful; aim `O(n)` |
| `1 <=` (the lower bound) | **promise** | array is never empty — **no empty guard needed** |
| `-1000 <= nums[i] <= 1000` | **hint** | worst sum `10^4 × 1000 = 10^7`; no overflow, even 32-bit |

### Two rules this problem exercises

**Sorting is off the table — and not because it is slow.** "Strictly to the
left/right" defines a relationship over *positions*. Sorting preserves the
multiset of values and destroys position, so it discards half the definition
and yields a confident wrong answer. `[2, 1, -1]` pivots at index `0`; sorted
to `[-1, 1, 2]` it pivots nowhere. Sorting here is **illegal, not merely
expensive**.

**Sentinel safety comes from the *return* domain, not the input constraints.**
`-1` is unambiguous because we return an **index**, and indices are never
negative. Contrast
[496](../0496-next-greater-element-i/README.md), where `-1` was safe only
because the constraint `0 <= nums[i]` ruled out negative *values*. Here
`-1000 <= nums[i]` allows negatives and does no protective work at all — had
the problem asked for the pivot *value*, `-1` would collide with a legitimate
element and the signature would have had to change.

### Not a monotonic stack

496 is recent, and its positional language ("next greater to the right") pulls
hard toward a stack. Run the literal trigger instead: the monotonic-stack
trigger is *"the **first element** to its left/right that is **bigger or
smaller**."* 724 asks for a **sum comparison**, not a first-bigger-neighbour
lookup. Different rule fires — the *sorting-is-illegal* one, which names no
data structure at all. `COACH.md` warns about this by name: pattern-matching
on the last problem you solved rather than the one in front of you.

### Shape signal worth banking

```
496:  n elements  →  n answers    (one per query)   ⇒ result array
724:  n elements  →  1 answer     (a single scalar) ⇒ accumulator
```

When `n` inputs collapse to a **single scalar**, reach for a running
accumulator, not a materialised prefix array. That is what buys the `O(1)`
space here.

## Reflection

**Where the time went.** Almost all of it in **A — understanding**, and on one
thing: the array splits into **three** pieces at the wall, not two. That single
misconception surfaced four separate times in four disguises —

- summing `1 + (-1)` and calling the pivot index `1` (those elements are indices
  0 *and* 1, so the wall is at 2),
- writing a row labelled `wall at -1`,
- computing `leftSum = 2` at wall 2 when the left side was `[2, 1] = 3`,
- solving the identity as `rightSum = total - leftSum`, dropping `nums[i]`.

Every one of them is the wall element trying to join a team. Naming it once —
*"the pivot belongs to neither side"* — would have been cheaper than debugging it
four times. **B (identify)** was fast once the identity was written down.
**C (write)** was one shot, including the `leftSum += value` placement.

**The arithmetic slip worth remembering.** At `i = 0` on `[2, 1, -1]` both sums
came out `0` and the row was still marked "not equal." The numbers were right; the
comparison wasn't. Empty sides really do produce `0`, and `0 == 0` really does
pass — an edge case that *looks* degenerate but is an ordinary row.

**Recency is a trap.** 496 was two days old, so "to the left of" pulled hard toward
a monotonic stack. The literal trigger for that pattern is "the **first element**
to its left/right that is **bigger or smaller**" — 724 asks for a *sum comparison*,
which does not match. The rule that actually fired was *sorting is illegal*, which
names no data structure at all. Run the literal trigger, not the vibe.

**Two rules promoted to `COACH.md`.** *An identity is not a test*, and *sentinel
safety comes from the return domain, not the input constraints*.

**A perf claim needs a mechanism.** A submission scored "great runtime, not great
memory," which suggested rewriting `let rightSum = ...` inline into the `if`. Both
forms were compiled with `swiftc -O` and their instruction streams diffed: **36
instructions each, zero difference**, no heap allocation, no stack frame. `let`
names a value living in a register; removing the name removes nothing at runtime.
The percentile was measuring process RSS — Swift runtime plus the input array —
and is noise around a fixed floor for any `O(1)` solution. Falsifier: resubmit
identical code and watch the number move. The transferable habit is the `-O`
instruction diff itself: cheap, decisive, and applicable to any "this version is
faster" claim that arrives without a *because*.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
