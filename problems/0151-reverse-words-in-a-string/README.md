# 151. Reverse Words in a String

**Difficulty:** Medium  
**Link:** https://leetcode.com/problems/reverse-words-in-a-string/  
**List:** Top Interview 150  
**Status:** Swift solution written by Jeff under Coach Mode; all 9 local tests pass.

## Goal

Return the input's words in reverse order. Keep the letters within each word
in their original order. Separate output words with exactly one space, with
no spaces at either end. Input words may have multiple spaces between them.

| Input | Output |
|---|---|
| `"the sky is blue"` | `"blue is sky the"` |
| `"  hello world  "` | `"world hello"` |
| `"a good   example"` | `"example good a"` |

## Constraints

- Input length: 1 to 10,000 characters.
- Characters are English letters, digits, and ordinary spaces.
- At least one word exists.

The follow-up asks about O(1) extra space for languages with mutable string
storage. The required Swift signature takes a String and returns a String.

## Approach

**This is a word-sequence reversal problem solved with split → reverse → join
in O(n) time and O(n) space**, where n is the input length.

1. Split on ordinary spaces, omitting empty parts.
2. Reverse the order of the whole words.
3. Join with exactly one space between words.

```text
"  hello   Swift  "
["hello", "Swift"]
["Swift", "hello"]
"Swift hello"
```

Each word is kept intact, including spelling, case, digits, and repeated words.
An array represents word order directly; a dictionary with numbered keys adds
bookkeeping without helping the required operations.

Splitting scans the input; joining writes the result. These sequential operations
add to O(n). Library calls still count toward complexity. The word array and
output require O(n) storage in the worst case; this is not the O(1)-space follow-up.

## Swift solution and tests

```swift
s.split(separator: " ")
    .reversed()
    .joined(separator: " ")
```

Run `swift test` from `swift/`. All 9 tests pass on the final chained version.
Coverage includes the three examples, padded single words, repeated words,
letter case, digits, mixed spacing, and a 10,000-character input.

## Reflection — 2026-10-14

- **A — Understanding:** Jeff identified absorbing the problem statement as the
  hardest part again. The first restatement preserved spaces; tracing examples
  clarified that word spelling stays intact while spacing is normalized.
- **B — Identifying:** recognizing whole words as the units to reverse was the
  central step. Jeff considered a dictionary with numbered keys before settling
  on an ordered word array and the split → reverse → join approach with coaching.
- **C — Writing:** Swift syntax recall caused some stumbling despite more than
  ten years of Swift experience. Jeff wrote the working implementation, then
  proposed chaining the calls. The original version and final chain each passed
  all nine tests. The unnecessary empty-word filter was removed because `split`
  already omits empty subsequences by default.
- **D — Idioms:** `split` produces `[Substring]`; `reversed()` supplies a view
  consumed by `joined`. Here the returned view contributes to the result, unlike
  the unused reversed view in 189. No translation into another language yet.
- **Experience:** Jeff described this Medium as requiring effort but manageable.
  He reported feeling more ready after coffee; this is personal session context,
  not evidence that syntax slips reflect a lack of Swift knowledge.
- **Credit:** the coach guided the interpretation and approach and supplied
  pseudocode on request; Jeff wrote and condensed the Swift. This was a coached
  solve, not an unaided cold solve.

**Next practice:** before coding, state what changes (word order and spacing) and
what stays intact (each word), then trace one padded example. On a later cold
re-solve, write the three steps in plain English before recalling the Swift calls.
Track understanding and syntax recall separately rather than treating both as
one difficulty.

## Idiom notes

- **Swift:** `split(separator: " ")` omits empty subsequences by default, so
  `.filter { !$0.isEmpty }` is redundant here.
- **Returned view:** array `reversed()` does not mutate the source; `joined`
  consumes the reversed order to construct the result.
- **Single expression:** the function can omit `return` when its body consists
  of this single expression. Keeping `return` would also be valid.
- **Readable chaining:** each line corresponds to one step of the algorithm.
