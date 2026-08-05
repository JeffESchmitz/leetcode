# 141. Linked List Cycle

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/linked-list-cycle/

Given `head`, the head of a linked list, determine if the linked list has a
cycle in it.

There is a cycle in a linked list if there is some node in the list that can
be reached again by continuously following the `next` pointer. Internally,
`pos` is used to denote the index of the node that tail's `next` pointer is
connected to. **Note that `pos` is not passed as a parameter.**

Return `true` if there is a cycle in the linked list. Otherwise, return
`false`.

**Example 1:**
```
Input:  head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to
the 1st node (0-indexed).
```

**Example 2:**
```
Input:  head = [1,2], pos = 0
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to
the 0th node.
```

**Example 3:**
```
Input:  head = [1], pos = -1
Output: false
Explanation: There is no cycle in the linked list.
```

Constraints:
- The number of nodes in the list is in the range `[0, 10^4]`.
- `-10^5 <= Node.val <= 10^5`
- `pos` is `-1` or a valid index in the linked list.

**Follow up:** Can you solve it using `O(1)` (i.e. constant) memory?

## Approach

**What a cycle even is:** picture the list as note cards — each card holds a
value and an instruction, either "go to card X next" or "stop here" (`next ==
nil`). A cycle means some card's instruction, instead of eventually reaching
"stop here," points back to a card already visited. Walking the list then
repeats forever instead of terminating.

`pos` in the examples below is **only used to build the test fixture** — see
`buildList(_:cycleAt:)` in the Swift test file, which rewires the last node's
`.next` to point back at an earlier node. `hasCycle` itself never receives
`pos`; it has to detect the loop purely by walking `.next` pointers.

- Example 1 `[3,2,0,-4], pos = 1`: `3 → 2 → 0 → -4 → (back to) 2 → 0 → -4 →
  ...` — `3` is a tail leading into a loop of `2 → 0 → -4`.
- Example 2 `[1,2], pos = 0`: `1 → 2 → 1 → 2 → ...` — the whole list is the
  loop, no separate tail.
- Example 3 `[1], pos = -1`: `1 → nil` — straight line, no cycle.

Two approaches are kept in `Solution` for comparison (see `Sources/`):

1. **`hasCycleUsingHashSet`** — walk the list, remembering every node seen
   (by reference identity) in a `Set<ObjectIdentifier>`. Landing on a node
   already in the set means a cycle. O(n) time, **O(n) space**.
2. **`hasCycle`** (Floyd's tortoise and hare) — two pointers walk the same
   list at different speeds: `slow` moves 1 node/step, `fast` moves 2. On a
   straight list, `fast` hits `nil` first. On a cyclic list, both pointers
   eventually enter the loop, and `fast` gains exactly one node on `slow`
   every step inside it — like a faster runner lapping a slower one on a
   circular track — so they're guaranteed to land on the same node
   eventually. O(n) time, **O(1) space**. This is what the LeetCode-facing
   `hasCycle` signature uses, since the problem's follow-up specifically
   asks for constant space.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
