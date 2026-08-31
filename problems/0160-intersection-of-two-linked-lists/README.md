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

_TBD — worked under Coach Mode._

## Reflection

_TBD._

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
