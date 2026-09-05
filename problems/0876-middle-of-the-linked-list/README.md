# 876. Middle of the Linked List

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/middle-of-the-linked-list/

Given the `head` of a singly linked list, return the middle node of the
linked list. If there are two middle nodes, return the **second** middle node.

**Example 1:**
```
Input:  head = [1,2,3,4,5]
Output: [3,4,5]
```
The middle node of the list is node `3`.

**Example 2:**
```
Input:  head = [1,2,3,4,5,6]
Output: [4,5,6]
```
Since the list has two middle nodes with values `3` and `4`, we return the
second one.

Constraints:
- The number of nodes in the list is in the range `[1, 100]`.
- `1 <= Node.val <= 100`

## Approach

**This is a Two Pointers (Fast & Slow / Tortoise & Hare) problem solved with a 1-step and 2-step traversal in $O(n)$ time and $O(1)$ space.**

### Identity, not value

The problem asks to return the **middle node object itself**, not its integer value. In a singly linked list, nodes are reference types (`ListNode` instances) scattered across memory, chained together only by `.next` pointers:

```text
[ Node @ 0x10 ] ----next----> [ Node @ 0x20 ] ----next----> nil
  val: 7                        val: 7
```

Even when all nodes carry identical payloads (e.g. `[7, 7, 7, 7]`), each is a distinct instance. The return value is an object reference, and the test suite verifies correctness by identity (`===`).

### Two approaches

1. **Two-pass (Count, then walk $n / 2$)**:
   - First pass: walk from `head` to `nil` to count total nodes $n$.
   - Second pass: walk $n / 2$ steps from `head`. In integer division, $5 / 2 = 2$ and $6 / 2 = 3$, which exactly targets the middle (or second middle).
   - Cost: $O(n)$ time (two passes, $\sim 1.5n$ traversals), $O(1)$ space.

2. **One-pass (Fast & Slow pointers)**:
   - Singly linked lists have no backward pointers (`prev`) and no random indexing, so we cannot walk inward from both ends.
   - Instead, start both pointers at `head` moving forward in lockstep:
     - `slow` takes **1 step** (`slow = slow?.next`)
     - `fast` takes **2 steps** (`fast = fast?.next?.next`)
   - Because `fast` moves at twice the speed of `slow`, by the time `fast` reaches the end of the list, `slow` is sitting directly on the middle node.

### The geometry: Odd vs. Even

```text
Odd length (n = 5):
Step 0:
  slow: [ Node @ 1 ] -> [ Node @ 2 ] -> [ Node @ 3 ] -> [ Node @ 4 ] -> [ Node @ 5 ] -> nil
  fast: [ Node @ 1 ]

Step 1:
          slow: [ Node @ 2 ]
                                fast: [ Node @ 3 ]

Step 2:
                    slow: [ Node @ 3 ] (Middle!)
                                                          fast: [ Node @ 5 ]
                                                                  fast.next is nil -> STOP

Even length (n = 6):
Step 0:
  slow: [ Node @ 1 ] -> [ Node @ 2 ] -> [ Node @ 3 ] -> [ Node @ 4 ] -> [ Node @ 5 ] -> [ Node @ 6 ] -> nil
  fast: [ Node @ 1 ]

Step 1:
          slow: [ Node @ 2 ]
                                fast: [ Node @ 3 ]

Step 2:
                    slow: [ Node @ 3 ]
                                                          fast: [ Node @ 5 ]

Step 3:
                              slow: [ Node @ 4 ] (Second middle!)
                                                                                              fast is nil -> STOP
```

### The stopping condition

To advance `fast` by two steps, both `fast` and `fast.next` must be non-nil. `while let` unwraps them first and gives them names, so the body only ever touches real nodes:
```swift
while let current = fast, let ahead = current.next {
    slow = slow?.next
    fast = ahead.next
}
```
- In odd lists, `fast` lands on the last node (`fast.next == nil`), stopping with `slow` on the unique midpoint.
- In even lists, `fast` steps past the end (`fast == nil`), stopping with `slow` on the second midpoint.
- No special-case branching is needed.

## Reflection

- **Where the time went**: Remembering the fast-and-slow pointer stride. Without random access or backward pointers, finding a midpoint in one pass requires creating a speed differential between two forward-moving references.
- **Shared machinery with 141 (Linked List Cycle)**: Both 141 and 876 use the identical `slow = slow.next` / `fast = fast.next.next` engine. On a closed track with a cycle (141), `fast` laps `slow` until `slow === fast`. On an open track with no cycle (876), `fast` reaches the end of the track, leaving `slow` at the halfway mark.
- **Identity over value**: Solved and tested by object identity (`===`), avoiding the trap of confusing node values with node locations.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift:** the first cut was `while fast != nil && fast?.next != nil { fast = fast?.next?.next }`, correct but every step reaches through optionals. Unwrapping in the condition, `while let current = fast, let ahead = current.next`, names the two nodes the double step depends on and drops the `?` from the body. Same edit that made 160 readable. The unwrapped node needs its own name: `while let fast` alone would shadow the `var` and the body could no longer advance it.
