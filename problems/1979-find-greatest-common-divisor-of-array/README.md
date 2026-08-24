# 1979. Find Greatest Common Divisor of Array

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/find-greatest-common-divisor-of-array/

Given an integer array `nums`, return the **greatest common divisor** of the
smallest number and largest number in `nums`.

The **greatest common divisor** of two numbers is the largest positive integer
that evenly divides both numbers.

**Example 1:**
```
Input:  nums = [2,5,6,9,10]
Output: 2
```
The smallest number is `2`, the largest is `10`, and `gcd(2, 10) = 2`.

**Example 2:**
```
Input:  nums = [7,5,6,8,3]
Output: 1
```
The smallest number is `3`, the largest is `8`, and `gcd(3, 8) = 1`.

**Example 3:**
```
Input:  nums = [3,3]
Output: 3
```

Constraints:
- `2 <= nums.length <= 1000`
- `1 <= nums[i] <= 1000`

## Approach

**This is a reduce-to-a-known-subroutine problem solved with Euclid's algorithm
in `O(n + log(max))` time and `O(1)` space.**

### The array is a decoy

The statement hands you an array of up to 1000 numbers, but reread what it
actually asks for: the GCD of **exactly two of them** — the smallest and the
largest. Every other element is noise. Nothing about their order, their
positions, or their relationships matters.

```
nums = [ 2, 5, 6, 9, 10 ]
         ↑           ↑
        min         max        →  gcd(2, 10) = 2
         ‾‾‾‾‾‾‾‾‾‾‾‾‾
         5, 6, 9 never participate
```

So step one is not an algorithm, it is a **reduction**: two linear scans turn
an array problem into a two-number problem. Recognising that a problem is
secretly a smaller problem in disguise is worth more than any clever traversal
— once reduced, the rest is a subroutine you either know or look up.

### Euclid's algorithm

```
gcd(a, b) = gcd(b, a % b),    with gcd(a, 0) = a
```

The structural reason it works, without arithmetic: **any number that divides
both `a` and `b` also divides what's left over when you take `b` out of `a` as
many times as it fits.** The remainder inherits every common divisor of the
pair, so replacing `(a, b)` with `(b, a % b)` throws away magnitude while
keeping the answer intact. Repeat and the numbers shrink fast; when one hits
`0`, the other is the GCD — because *everything* divides `0`, so it imposes no
constraint and the other number is free to be the answer.

Traced on Example 1:

```
gcd(2, 10)  →  a=2,  b=10,  2 % 10 = 2   →  gcd(10, 2)
gcd(10, 2)  →  a=10, b=2,  10 %  2 = 0   →  gcd(2, 0)
gcd(2, 0)   →  b == 0                    →  return 2   ✅
```

Note the first step harmlessly swaps the arguments when `a < b` — no need to
order them yourself, the modulo does it in one wasted-looking step.

### Why min/max and not "the GCD of everything"

A tempting generalisation is to fold the GCD across the whole array. It gives
the same answer surprisingly often, but it is a *different* computation and
does strictly more work — and it answers a question the problem did not ask.
Solve what was asked.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `nums.length <= 1000` | **hint** | tiny; almost anything passes. Not a reason to be sloppy, just not a constraint that shapes the design |
| `2 <=` (the lower bound) | **promise** | array is never empty ⇒ `nums.min()!` / `nums.max()!` **cannot trap**, so the force-unwraps are safe and unguarded |
| `1 <= nums[i]` | **promise** | no zeroes and no negatives, so `gcd` is never handed a degenerate pair and the result is always a positive integer |

The `1 <= nums[i]` bound is quietly load-bearing. Allow `0` into the array and
`min` becomes `0`, making the answer `max` — still defined, but a case worth
reasoning about. Allow negatives and "greatest" needs a sign convention. The
constraint removes both questions, which is exactly what a promise is for: it
buys you the right *not* to write that code.

### Complexity

- **Time:** `O(n)` for the two scans, plus `O(log(min))` for Euclid — the
  recursion depth is logarithmic, not linear, because the remainder shrinks
  geometrically. The scans dominate.
- **Space:** `O(1)` working state. Euclid's recursion is `O(log(min))` frames
  deep — about 15 at most for values capped at 1000, and it is in tail
  position, so it is not a stack risk at this scale.

### Idiomatic note

`nums.min()!` and `nums.max()!` are two separate passes. A single pass could
compute both, and `nums.minAndMax()` does not exist in the stdlib. At `n <=
1000` the difference is unmeasurable, and the two-call version says exactly
what it means — [prefer the readable form absent a mechanism showing the other
one wins](../../README.md#lessons-that-keep-recurring).

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
