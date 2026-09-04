# 160. Intersection of Two Linked Lists

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/intersection-of-two-linked-lists/

Given the heads of two singly linked lists `headA` and `headB`, return the
node at which the two lists intersect. If the two linked lists have no
intersection at all, return `null`.

The test cases are generated such that there are no cycles anywhere in the
entire linked structure. The linked lists must retain their original
structure after the function returns — no mutation.

**Custom Judge:** the judge builds the lists from these inputs (your program
never sees them directly):

- `intersectVal` — the value at the intersection node (`0` if none)
- `listA`, `listB` — the two lists
- `skipA`, `skipB` — nodes to walk from each head before reaching the
  intersection

**Example 1:**
```
Input:  listA = [4,1,8,4,5], listB = [5,6,1,8,4,5], skipA = 2, skipB = 3
Output: Intersected at '8'
```
Reading from the head, `A` is `[4,1,8,4,5]` and `B` is `[5,6,1,8,4,5]`; both
tails share the node with value `8` onward.

**Example 2:**
```
Input:  listA = [1,9,1,2,4], listB = [3,2,4], skipA = 3, skipB = 1
Output: Intersected at '2'
```

**Example 3:**
```
Input:  listA = [2,6,4], listB = [1,5], skipA = 3, skipB = 2
Output: No intersection (null)
```

Constraints:
- The number of nodes in `listA` is `m`; in `listB` is `n`.
- `1 <= m, n <= 3 * 10^4`
- `1 <= Node.val <= 10^5`
- `0 <= skipA <= m`
- `0 <= skipB <= n`
- `intersectVal` is `0` if `listA` and `listB` do not intersect.
- `intersectVal == listA[skipA] == listB[skipB]` if they do intersect.

**Follow up:** Could you write a solution that runs in `O(m + n)` time and
uses only `O(1)` memory?

## Approach

**Length-align two cursors, then walk in lockstep — `O(m + n)` time, `O(1)`
space.** Satisfies the follow-up.

### The goal, precisely

Return the first node both lists **share** — the same object, not two nodes
holding equal values — or `nil`. The test
`equalValuesDifferentNodes` builds `[1,2,3]` twice as separate objects and
expects `nil`: every value matches, every position matches, and it is still
not an intersection. The comparison is `===` (identity), never `==`.

Vocabulary that mattered: say **"the first shared node"**, not "the node with
value 8." The value is a label printed on the node, not what makes it the
answer.

### The shape: a shared suffix

A node has exactly one `next`, so following it is deterministic. Two lists
that meet can never split apart again. The overlap is therefore always a
**suffix** — private prefixes of different lengths, then one common tail run
together to the end.

```
A:      4 → 1 → 8 → 4 → 5 → nil
B:  5 → 6 → 1 → 8 → 4 → 5 → nil
```

Right-align by the tail and the shared nodes stack vertically. Measured on
example 1, node `8` is at distance 2 from A's head and 3 from B's — but
distance 2 from **both** tails. Shared nodes are perfectly aligned from the
end and misaligned from the front by exactly `|m - n|`.

### The obstacle, and the record-player picture

The alignment you want is from the tail; the only motion available is
forward from the heads. `ListNode` has `next` and no `prev`.

Two turntables playing records of different lengths that share the same
outro. Give the longer record a head start equal to the difference, then
drop the needle on the shorter one: from that moment both needles are the
same distance from the end and finish together. Then listen for the moment
they fall in — not in unison, *singularly*: one groove, one physical disc,
both needles riding it.

### The algorithm

1. Walk both lists once to get their lengths.
2. Advance the longer list's cursor by the difference. "Skip" is not a jump
   — there is no random access in a linked list — it is ordinary steps taken
   without looking.
3. Step both cursors forward together until they are the same node.

The termination loop needs no special case for "no intersection": after
alignment both cursors reach `nil` on the same step, and the loop simply
ends.

### Constraints, read as hint or promise

| Constraint | Hint or promise | What it buys |
|---|---|---|
| No cycles anywhere | Promise | Load-bearing — the length walk terminates only because of this |
| `1 <= m, n` | Promise | Neither head is `nil` |
| `m, n <= 3 * 10^4` | Hint | Rules out the nested loop (`9 × 10^8`) |
| `1 <= Node.val <= 10^5` | Neither, for us | Dead — the solution never reads a value |

That last row is the punchline. The value bound exists to make the judge's
`intersectVal = 0` sentinel unambiguous (the same sentinel rule as
[496](../0496-next-greater-element-i/README.md) and
[724](../0724-find-pivot-index/README.md)). It does nothing for the
algorithm, because the answer was never about values.

### The ladder

- **Stack, `O(m + n)` space.** Push every node of each list, then pop both
  stacks together; the last matching pair is the answer. This is the
  literal "walk backward from the tails" instinct, bought with memory. Fully
  correct; fails only the follow-up.
- **Length-align, `O(1)` space.** As shipped.

## Reflection

Session 2026-09-04, roughly 8:00–9:11, kids home and loud in the next room.
Accepted on the judge first submit, 41/41.

**Where the time went: almost all of it in A (Understanding).** Two ideas
had to be built from nothing before any solution talk was possible — that a
node's *identity* is not its *value* (the first answer defined "intersect"
by `.val`), and that a singly linked list only moves one direction (the
first proposed approach was to walk backward from both tails). A third —
that the overlap is a suffix — was the bridge between them and took several
drawings to land. "Shared suffix" was explicitly called fuzzy, and it
genuinely was until the right-aligned picture.

**B (Identifying) fell out in one step once the shape was clear.** The
proposal to "pad the shorter list with `nil` to right-align it" was the
alignment insight, just funded the wrong way: padding the short list and
skipping on the long list produce the same alignment, and only one of them
is free and non-mutating. The record-player analogy arrived unprompted and
was a better explanation than the index arithmetic being pushed.

**C (Writing) was fast** given the pseudocode, and the first Swift draft was
correct on the logic; the only blocker was a typo in the method name. The
loop was written differently from the pseudocode (nil-guard plus early
return instead of `while pA !== pB`) and kept, because it is more readable
than relying on `nil === nil`.

Named as a weak spot: **nodes**. Not the algorithms — the mental model of
what a node *is*, a reference to a box distinct from the number inside it,
reachable only one way. Array problems never force that distinction. Also
noted: terminology ("what is `pA`?", "why do we need this?") was part of the
difficulty and worth slowing down for, not pedantry.

Meta: this session also discovered that a mnemonic for the 8-step framework
had been invented in an earlier session and never written down. Candidates
now live in the root README so it stops evaporating.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
