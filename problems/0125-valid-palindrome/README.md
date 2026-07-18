# 125. Valid Palindrome

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/valid-palindrome/

A phrase is a **palindrome** if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string `s`, return `true` if it is a palindrome, or `false` otherwise.

Constraints:
- `1 <= s.length <= 2 * 10^5`
- `s` consists only of printable ASCII characters.

## Approach

**Two pointers.** Filter the string down to lowercased alphanumerics, then walk two
integer indices toward each other from both ends, comparing as they go. First
mismatch → `false`; if they meet or cross, every pair matched → `true`.

- `while left < right` handles everything: odd length (pointers meet on the middle
  character, which never needs comparing), even length (pointers cross), and empty
  strings (loop never runs → `true`).
- O(n) time, O(n) space (the filtered copy).
- Key unlearning from the session: no node classes, no incline/decline substring
  copies, no nested loops — two walkers moving in lockstep are one loop with two
  `Int`s.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** — `String` refuses `Int` subscripts by design: characters are
  variable-width, so `index(_:offsetBy:)` *walks* from `startIndex` (O(n)), and
  using it inside a loop silently made the first draft O(n²). `Array(String)` is
  the escape hatch — contiguous `Character` storage with O(1) `Int` subscripting.
  Alternative stdlib expressions of the same check, kept as idiom notes rather
  than the solution: `filtered == String(filtered.reversed())` (reads like the
  definition, costs an extra O(n) copy) and
  `zip(chars, chars.reversed()).allSatisfy(==)` (lazy reversed view, operator
  passed as a function, short-circuits — but walks all n pairs instead of n/2).
  Nesting multiplies, sequencing adds.
