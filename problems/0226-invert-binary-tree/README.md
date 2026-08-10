# 226. Invert Binary Tree

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/invert-binary-tree/](https://leetcode.com/problems/invert-binary-tree/)

## Problem

Given the `root` of a binary tree, invert the tree, and return *its root*.

**Example 1:**
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
```

**Example 2:**
```
Input: root = [2,1,3]
Output: [2,3,1]
```

**Example 3:**
```
Input: root = []
Output: []
```

**Constraints:**
- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`

## Approach

_Worked through the 8-step framework from `COACH.md`. Filled in as we go._

1. **GOAL** —
2. **SHAPE** —
3. **CONSTRAINTS** —
4. **SIGNATURE** —
5. **EXAMPLE TRACE** —
6. **PATTERN → ALGORITHM** —
7. **EDGE CASES** —
8. **DATA STRUCTURES** —

**This is a [PATTERN] problem solved with [ALGORITHM] in [BIG-O].**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Test fixtures

The answer here is a **tree**, not a number, so the suite needs a way to state an
expected tree. Two helpers in the test file handle it:

- `makeTree(_:)` — builds from LeetCode's level-order notation, as in
  [104](../0104-maximum-depth-of-binary-tree/README.md) and
  [111](../0111-minimum-depth-of-binary-tree/README.md).
- `levelOrder(_:)` — the inverse, serializing back to that same notation with
  trailing `nil`s trimmed, so an expectation reads exactly like the problem page:
  `#expect(levelOrder(result) == [4, 7, 2, 9, 6, 3, 1])`.

Every expected value below was validated against a known-good implementation before
the fixtures were committed, so a red test means the solution is wrong rather than
the harness.

| Case | Why it's there |
|---|---|
| `[4,2,7,1,3,6,9]`, `[2,1,3]` | the two given examples |
| `nil` | empty tree — example 3 |
| `[1]` | single node; nothing to swap |
| `[1,2]` / `[1,nil,2]` | one child, which must change sides — the smallest visible inversion, mirrored |
| left chain → right chain, and back | a degenerate tree flips direction entirely |
| lopsided tree | asymmetry must survive the swap rather than be flattened by it |
| negative values | inversion is structural; `val` never participates |
| a tree that is its own mirror | inverting is a no-op — catches swapping one level too many or too few |
| invert twice | inversion is its own inverse; a property that holds for *every* tree |
| returns the given root | callers holding the original reference should see the inverted tree |
| 2,000-node chain | stack-depth pressure, far past the constraints' 100-node cap |
| helper sanity check | every other fixture trusts `makeTree` and `levelOrder` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
