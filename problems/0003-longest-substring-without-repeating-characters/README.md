# 3. Longest Substring Without Repeating Characters

**Difficulty:** Medium
**Link:** https://leetcode.com/problems/longest-substring-without-repeating-characters/

Given a string `s`, find the length of the **longest substring** without
duplicate characters.

**Example 1:**
```
Input:  s = "abcabcbb"
Output: 3
```
The answer is `"abc"`, with length 3.

**Example 2:**
```
Input:  s = "bbbbb"
Output: 1
```
The answer is `"b"`, with length 1.

**Example 3:**
```
Input:  s = "pwwkew"
Output: 3
```
The answer is `"wke"`, with length 3. Note that `"pwke"` is a *subsequence*,
not a **substring** — substrings must be contiguous.

Constraints:
- `0 <= s.length <= 5 * 10^4`
- `s` consists of English letters, digits, symbols and spaces.

## Approach

> **Spoiler — collapsed on purpose.** This problem is already solved in `go/`.
> The Swift leaf is a deliberate **memory test**: attempt it from scratch
> first, then open this to compare. Retrieving an answer from memory is what
> consolidates it; re-reading one feels productive and consolidates far less.

<details>
<summary>Show the approach</summary>

**This is a variable-size sliding-window problem solved with a
last-seen-index hash map in `O(n)` time and `O(min(n, alphabet))` space.**

### The sibling of 643

[643](../0643-maximum-average-subarray-i/README.md) is a **fixed**-width
window: `k` never changes, so each step slides both edges together — one out,
one in. This is the **variable**-width case, and it is the harder sibling
named in `COACH.md`'s sliding-window beat:

```
fixed    (643):  both edges move together, width pinned at k
variable (3):    the RIGHT edge always advances;
                 the LEFT edge jumps only when it must
```

The right edge marches once through the string, unconditionally. The left edge
only moves when the arriving character would create a duplicate — and when it
moves, it *jumps* past the offending earlier occurrence rather than creeping
one step at a time.

### Why a map of indices, not a set of characters

A set answers *"have I seen this?"* A set alone forces the left edge to creep
forward one character at a time, shrinking until the duplicate falls out. That
still works, but storing the **last index at which each character was seen**
lets the left edge jump straight to the right position in one move.

```
newLeft = max(left, lastSeen[c] + 1)
```

### The `max` is the whole problem

That `max` is not defensive padding — it is the correctness of the algorithm,
and it is what the two trap tests exist to catch:

```
s = "d v d f"
     0 1 2 3

right=2, char 'd', lastSeen['d'] = 0
   without max:  left = 0 + 1 = 1   ← fine here
```
```
s = "a b b a"
     0 1 2 3

right=2, char 'b', lastSeen['b'] = 1  →  left = 2
right=3, char 'a', lastSeen['a'] = 0  →  left = 0 + 1 = 1   ← WRONG
                                          left just moved BACKWARD, from 2 to 1
                                          and the window re-admits a 'b'
   with max:      left = max(2, 1) = 2   ✅
```

**A stale index must never drag the window backward.** `lastSeen['a'] = 0` is
true but irrelevant — that `a` is already behind the left edge, outside the
window, and no longer a duplicate of anything. The `max` says *"the left edge
is a ratchet: it advances or it stays, never retreats."*

### Complexity

- **Time:** `O(n)` — the right edge visits each character once; the left edge
  only ever moves forward, so its total travel is also bounded by `n`. Two
  pointers each making one forward pass, not a nested loop.
- **Space:** `O(min(n, alphabet))` — the map holds at most one entry per
  distinct character.

### Note on Swift strings

The Go solution indexes bytes (`s[right]`) and keys the map by `byte`. Swift's
`String` is **not** randomly indexable by `Int` — `String.Index` is opaque and
advancing it is `O(k)`. Naively writing `s[s.index(s.startIndex, offsetBy: i)]`
inside a loop turns an `O(n)` algorithm into `O(n²)`. Converting to `Array(s)`
once up front buys `O(1)` indexing for the price of one `O(n)` pass — a real
idiom difference between the two languages, and the thing this translation is
worth doing for.

</details>

## Solutions

Go was the source of truth here — this problem predates the polyglot
restructure and was solved before Swift became the default first language.

| Language | Harness | Run from the leaf | Status |
|----------|---------|-------------------|--------|
| Go | `go test` | `go test ./...` | ✅ solved |
| Swift | SwiftPM + Swift Testing | `swift test` | 🔴 stub — memory test, unsolved on purpose |

## Idiom notes

_What each language made me see when translating:_

- **Go** — `for right := range len(s)` (Go 1.22+ integer range) with `s[right]`
  yields **bytes**, so the map is keyed by `byte`. Fine for this problem's
  ASCII-ish constraint, but it would mis-handle multi-byte characters — the
  same byte-vs-rune distinction that
  [771](../0771-jewels-and-stones/README.md) resolves the other way by ranging
  over runes.
- **Swift** — _fill in after solving._
