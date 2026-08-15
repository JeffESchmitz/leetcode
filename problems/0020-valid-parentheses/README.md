# 20. Valid Parentheses

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/valid-parentheses/

Given a string `s` containing just the characters `'('`, `')'`, `'{'`, `'}'`,
`'['` and `']'`, determine if the input string is valid.

An input string is valid if:

1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

**Example 1:**
```
Input:  s = "()"
Output: true
```

**Example 2:**
```
Input:  s = "()[]{}"
Output: true
```

**Example 3:**
```
Input:  s = "(]"
Output: false
```

Constraints (typical LeetCode):
- `1 <= s.length <= 10^4`
- `s` consists of parentheses only: `()[]{}`

## Approach

Scan left to right. Keep a **stack of openers** still waiting to be closed
(most recent on top). For each character:

- **Opener** (`(`, `[`, `{`) → push.
- **Closer** (`)`, `]`, `}`) → the top of the stack must be the matching opener.
  Pop and compare. Wrong type, or empty stack → invalid immediately.

After the scan, the stack must be **empty** — every opener found a closer.

That is exactly COACH's stack trigger: *"next greater/smaller, parentheses,
spans → monotonic / matching stack."* Here the stack is LIFO matching, not a
monotonic value stack — same structure, different comparison.

Mapping is closer → opener so a closer looks up what it *expects*, rather than
opener → closer and comparing the other way around:

```
) → (
] → [
} → {
```

- **Time:** O(n) — one pass.
- **Space:** O(n) worst case — all openers, e.g. `((((`.

One-liner: *This is a parentheses-matching problem solved with a stack (LIFO) in
O(n) time and O(n) space.*

## Reflection

Three rules in the statement collapse into one machine: **the closer you just
saw must cancel the most recent unmatched opener of the same type.** That is
the definition of a stack. Counting openers and closers is not enough —
`([)]` has balanced counts and is still invalid because order is wrong.

- **A) Understanding** — the three validity bullets look like three checks;
  they are one nested-matching invariant. Edge cases name the failure modes
  of that invariant (stray closer, wrong type, leftover openers).
- **B) Identifying** — stack is the pattern card, not "scan and count" and not
  recursion-first. Recursion can model nesting, but an explicit stack is the
  direct transcription of "most recently opened must close first."
- **C) Writing** — short once the map + stack are chosen. The easy bugs are
  off-by-structure, not off-by-one: forgetting the final `isEmpty` check,
  or treating a closer with an empty stack as push instead of fail.

**What actually unlocked it:**

1. **LIFO, not counts.** Validity is about *order of nesting*, so the structure
   that remembers unfinished work in reverse open order is a stack.
2. **Fail fast on mismatch.** Wrong type or closer-with-nothing-open never
   needs the rest of the string.
3. **Empty stack at the end.** Surviving the loop only proves every *closer*
   matched something; leftover openers mean unfinished work → false.

**Traces that stuck:**

```
()        push (, pop ( on )           → empty → true
()[]{}    three independent pairs      → true
(]        push (, ) expects ( got mismatch on ] → false
([])      push (, [, pop [ on ], pop ( on ) → true
([)]      push (, [, ) expects ( but top is [ → false
(((       three openers, never closed  → non-empty → false
())       ) with empty stack after ()  → false
```

**Edge cases covered in tests:**

| Case | Why |
|------|-----|
| `()`, `()[]{}` | examples |
| `(]` | wrong type |
| `([])`, `{[()]}` | nested valid |
| `(`, `]` | single character either way |
| `([)]` | crossed nesting (counts lie) |
| `(((`, `(()` | unmatched open |
| `))}`, `())` | unmatched close |

**Transfer:** any "must close in reverse open order" problem is stack-shaped —
HTML tags, path segments, calculator parentheses, nested iterators. Same
trigger words as COACH's stack row.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **Array as stack:** `append` / `popLast()` is the idiomatic LIFO. No separate
    `Stack` type required. `popLast()` returns `Optional` — empty stack is
    `nil`, which is exactly "closer with nothing open."
  - **Closer → opener dictionary.** Looking up the current character: if it is a
    key, it's a closer and the value is what must be on top; if not, treat as
    opener and push. One table drives the branch instead of a six-way `switch`.
  - **`guard let expectedOpener = map[character] else { push; continue }`**
    keeps the opener path short and the closer path the main line — same
    "happy path forward" shape as other stack/match code in the repo.
  - **Free function vs `Solution` method.** This leaf exposes `isValid(_:)` at
    module scope (tests call `isValid` directly). Other leaves wrap LeetCode
    methods in `public struct Solution`. Both paste into the judge once the
    signature matches; the dojo convention prefers `Solution` for new leaves so
    tests share one shape — noted for a later tidy if desired.
- **Python** —
- **Java** —
- **Kotlin** —
- **Rust** —
- **Go** —
