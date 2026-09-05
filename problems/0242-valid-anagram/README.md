# 242. Valid Anagram

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/valid-anagram/

Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and
`false` otherwise.

An **anagram** is a word or phrase formed by rearranging the letters of a
different word or phrase, typically using all the original letters exactly once.

**Example 1:**
```
Input:  s = "anagram", t = "nagaram"
Output: true
```

**Example 2:**
```
Input:  s = "rat", t = "car"
Output: false
```

Constraints:
- `1 <= s.length, t.length <= 5 * 10^4`
- `s` and `t` consist of lowercase English letters.

**Follow up:** What if the inputs contain Unicode characters? How would you
adapt your solution to such a case?

## Approach

**Frequency count, compared.** An anagram is not "the same set of letters" — it
is the same *multiset*: every character must appear the same number of times in
both strings. `"aacc"` and `"ccac"` draw from the same set `{a, c}` and are still
not anagrams, because the counts differ (`a:2 c:2` vs `a:1 c:3`).

So: build a `[Character: Int]` tally for each string independently, then compare
the two dictionaries. Order of insertion never matters — Swift's `Dictionary`
equality compares contents, so the two tallies built by walking `"anagram"` and
`"nagaram"` in different orders land equal. O(n) time, O(k) space for k distinct
characters.

A length guard runs first: strings of different lengths can never be anagrams,
so the counting is skipped entirely.

### Still to close out (Coach Mode steps 6–8)

Worked through step 5 (example trace); these are parked for the next session.

1. **Sort vs. count.** The rival approach is `s.sorted() == t.sorted()` — one
   line, no hash map, O(n log n). The frequency map wins the complexity table.
   Name a situation where the sort is still the better reach. (Hint: the
   frequency map needs elements to be `Hashable`; sorting only needs
   `Comparable`.)
2. **Is the length guard free?** `String.count` is *not* stored in Swift — it
   walks the string, because characters are variable-width, so the guard costs
   two full passes before any counting begins. Argue it both ways and commit to
   an answer.
3. **The Unicode follow-up.** `"café"` can be spelled with `é` as one code point
   (`U+00E9`) or as `e` + a combining accent (`U+0065 U+0301`) — same word,
   different bytes. A solution counting UTF-8 bytes calls those different
   lengths. Does counting `Character` pass or fail this case, and why? What does
   Swift's `Character` actually represent?
4. **Why not 26 counters?** The constraints promise lowercase English only,
   which licenses `[Int](repeating: 0, count: 26)` — no hashing, no allocation
   growth, constant space. That is strictly faster here. Why keep the dictionary
   anyway? (Same punchline as question 3.)

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
