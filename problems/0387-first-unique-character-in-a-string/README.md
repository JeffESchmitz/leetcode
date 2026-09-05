# 387. First Unique Character in a String

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/first-unique-character-in-a-string/

Given a string `s`, find the **first non-repeating character** in it and return
its **index**. If it does not exist, return `-1`.

**Example 1:**
```
Input:  s = "leetcode"
Output: 0
```

**Example 2:**
```
Input:  s = "loveleetcode"
Output: 2
```

**Example 3:**
```
Input:  s = "aabb"
Output: -1
```

Constraints:
- `1 <= s.length <= 10^5`
- `s` consists of only lowercase English letters.

## Approach

**This is a tally-then-scan problem solved with a frequency count in `O(n)`
time and `O(1)` space (bounded by the 26-letter alphabet).**

### Restated without the trap word

> For each distinct letter, count how many times it occurs across the entire
> string. Then walk left to right and stop at the first position whose letter
> has a count of 1. Return that position, or `-1` if you never stop.

That rewording *is* the algorithm. Two sequential passes: one to build the
tally, one to read it.

### Where the time went (58 minutes, target was 30)

Almost all of it was **understanding**, not code. "First non-repeating
character" was read as "the first time a repeat shows up, then back up one,"
which gives `"aabb" → 1`. That is a different problem. The examples settle it:
`"aabb" → -1` only makes sense if "repeating" is a property of the *letter
across the whole string*, not of a *position while walking*. Both copies of
`a` are disqualified, not just the second.

The fix is process, not skill: **trace an example right after GOAL**, before
SHAPE or CONSTRAINTS. See `TRAP-WORDS.md` and the note in `COACH.md`.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `1 <= n <= 10^5` | **hint** | rules out `O(n²)`; two linear passes are fine |
| `1 <=` (lower bound) | **promise** | never empty; no guard needed, and the code would handle it anyway |
| lowercase English only | **promise** | bounds the tally at 26 keys, so a fixed-size array would also work and space is effectively `O(1)` |

The lowercase promise only became visible *after* the reading was right. Under
the "first repeat" reading, a seen-set is all you need and counts never enter
the picture, so a 26-slot array has no reason to exist. Constraints reveal what
they buy you only once the goal is correct.

### Complexity

- **Time:** `O(n)`. Two passes that add, not multiply.
- **Space:** `O(1)`. At most 26 keys regardless of `n`.

## Solutions

| Language | Harness | Run from the leaf | Status |
|----------|---------|-------------------|--------|
| Swift | SwiftPM + Swift Testing | `swift test` | ✅ solved |

## Idiom notes

_What each language made me see:_

- **Swift** — `counts[letter, default: 0] += 1` is the counting idiom; the
  `default:` subscript removes the nil-check dance entirely.
- **Swift** — `s.reduce(into: [Character: Int]())` builds the tally as a single
  expression and makes it a `let`. The `into:` form mutates one accumulator
  instead of copying a dictionary per step.
- **Swift** — `s.enumerated().first { ... }?.offset ?? -1` is the whole second
  pass. `enumerated()` supplies the index without touching `String.Index`, which
  matters because Swift strings are not `O(1)` indexable. The optional chain
  plus `?? -1` folds the sentinel into the return expression.
- **Swift** — first draft used two `for` loops with an early `return`; Grok's
  pass folded both into `reduce(into:)` and `first(where:)`. Same algorithm,
  same complexity, reads as two named steps rather than control flow.
