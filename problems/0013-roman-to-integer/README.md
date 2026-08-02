# 13. Roman to Integer

**Link:** https://leetcode.com/problems/roman-to-integer/
**Difficulty:** Easy

## Problem

Roman numerals are represented by seven symbols:

| Symbol | Value |
|--------|-------|
| I      | 1     |
| V      | 5     |
| X      | 10    |
| L      | 50    |
| C      | 100   |
| D      | 500   |
| M      | 1000  |

Roman numerals are usually written largest to smallest from left to right.
However, in six cases a smaller symbol precedes a larger one and is subtracted:

- `I` before `V` (4) and `X` (9)
- `X` before `L` (40) and `C` (90)
- `C` before `D` (400) and `M` (900)

Given a roman numeral string `s`, convert it to an integer.

**Constraints:**
- `1 <= s.length <= 15`
- `s` contains only the characters `('I', 'V', 'X', 'L', 'C', 'D', 'M')`
- It is guaranteed that `s` is a valid roman numeral in the range `[1, 3999]`

## Approach

A roman numeral is a **signed sum**: every symbol contributes its value with a
+ or a −, and a value gets subtracted instead of added when it's less than its
right neighbor. No pairing, no backtracking — one decision per character.

1. Build a dictionary mapping each character to the integer from the
   Symbol–Value table.
2. `map` the input string through the dictionary to get an array of plain
   values. A character missing from the dictionary is garbage input, so trap
   loudly there instead of hiding it behind a default.
3. `zip` the values with themselves shifted by one to walk (current, next)
   neighbor pairs, and accumulate: subtract `current` when it's less than
   `next`, otherwise add it. The last value has no pair — it's always added,
   so it seeds the accumulation.

`"MCMXCIV"` → `+1000 −100 +1000 −10 +100 −1 +5` = 1994.

The trace, one comparison per character ("me < my **right** neighbor?" —
the *right* part is the piece that keeps slipping):

| i | char | value | next value | me < next? | +/− |
|---|------|-------|------------|------------|-----|
| 0 | M | 1000 | 100      | false | + |
| 1 | C | 100  | 1000     | true  | − |
| 2 | M | 1000 | 10       | false | + |
| 3 | X | 10   | 100      | true  | − |
| 4 | C | 100  | 1        | false | + |
| 5 | I | 1    | 5        | true  | − |
| 6 | V | 5    | *(none)* | false | + |

Gotcha that bit during practice: filling this table by instinct got every
**sign** right but flipped the booleans on rows 4–5 — the comparison column
and the sign column must agree, and `false → +` / `true → −` is the pairing
to trust. A value with no right neighbor can never be subtracted (there's
nothing to subtract it *from*), so the last row is always `+`.

**This is a signed-sum problem solved with a single-pass lookahead scan and a
fixed hash map, in O(n) time and O(1) extra space** (the map is a fixed 7
entries; the values array is O(n) but could be eliminated by folding the
lookup into the scan).

## Idiom notes

- **swift:**
  - `map` is just compressed spelling for `var x: [Int] = []` + a loop that
    only ever appends — transform the whole input up front, then the real
    logic gets to be pure integer math ("transform first, then compute").
  - `zip(values, values.dropFirst())` walks neighbor pairs with no index
    arithmetic; it stops at the shorter sequence, so the `i + 1 < count`
    boundary check *dissolves into the iteration shape*. The dropped last
    element is a feature here: it's always added, so it seeds the fold.
  - `reduce(seed) { total, pair in ... }` replaces `var total` + loop the same
    way `map` replaces `var x` + append. Kept the named-parameter closure; the
    `$1.0 < $1.1` shorthand spelling is the "clever now, cryptic later" trap.
  - First version passed all tests using `?? 0` twice — one load-bearing
    (phantom last neighbor), one silently masking bad input. Identical
    spellings, different meanings: worked because of a trick you couldn't
    see. Refactored so it works for reasons you can read.
