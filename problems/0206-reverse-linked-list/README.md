# 206. Reverse Linked List

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/reverse-linked-list/

Given the `head` of a singly linked list, reverse the list, and return the
reversed list.

**Example 1:**
```
Input:  head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**Example 2:**
```
Input:  head = [1,2]
Output: [2,1]
```

**Example 3:**
```
Input:  head = []
Output: []
```

Constraints:
- The number of nodes in the list is in the range `[0, 5000]`.
- `-5000 <= Node.val <= 5000`

**Follow up:** A linked list can be reversed either iteratively or
recursively. Could you implement both?

## Approach

**Reversing is structural, not value-based.** "Reverse" means flip the
*direction of traversal* — whatever node was first becomes last, and vice
versa. It has nothing to do with sorting or comparing values; the algorithm
never looks at `.val`, only at `.next`. `[1,2,3,4,5] → [5,4,3,2,1]` only
*looks* like a descending sort because that particular input happened to be
sorted ascending — an unsorted input like `[3,1,4,1,5]` reverses to
`[5,1,4,1,3]`, not `[5,4,3,1,1]`.

**The mechanism — three pointers in flight:**

- `prev` — the head of the already-reversed portion. Starts `nil`.
- `curr` — the node currently being rewired. Starts at `head`.
- `next` — scratch space that rescues the rest of the list *before* `curr`'s
  pointer gets overwritten.

The gotcha the whole algorithm hinges on: the moment you run
`curr.next = prev`, you've destroyed the only reference to the rest of the
original list. If you haven't already saved `curr.next` into `next` first,
everything after `curr` becomes unreachable. Save before you overwrite.

Each iteration, in order:
1. `next = curr.next` — rescue the rest of the list.
2. `curr.next = prev` — rewire this node to point backward.
3. `prev = curr; curr = next` — advance both pointers for the next lap.

Loop while `curr != nil`; when it terminates, `prev` holds the head of the
fully reversed list (`curr` has walked off the end to `nil`).

Trace on `[1,2,3]`:

| step | prev | curr | next | curr.next after step 2 |
|---|---|---|---|---|
| start | nil | 1 | – | – |
| 1 | nil | 1 | 2 | `1.next = nil` |
| 2 | 1 | 2 | 3 | `2.next = 1` |
| 3 | 2→1 | 3 | nil | `3.next = 2` |
| end | 3→2→1 | nil | – | loop exits |

Edge cases fall out for free: an empty list (`head = nil`) never enters the
loop and returns `prev = nil` immediately; a single node runs the loop once,
sets its `.next` to `nil` (a no-op, since it was already `nil`), and returns
that same node as `prev`.

**Iterative vs. recursive:** the problem's follow-up asks for both, but only
the iterative version is implemented here, deliberately. Recursion doesn't
buy anything on this problem — time complexity is O(n) either way, but a
recursive version trades the O(1) space of the explicit pointers for O(n)
call-stack space (one frame per node). At this problem's `n ≤ 5000`, stack
depth isn't a real risk either way, so the choice came down to: iterative is
the leaner solution *and* the more comfortable one to write correctly.

Complexity: **O(n) time, O(1) space.**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** — function parameters are immutable by default (`head` can't be
  reassigned), which is exactly why the iterative approach needs a separate
  `curr` variable as the walking cursor instead of mutating the parameter
  directly.
