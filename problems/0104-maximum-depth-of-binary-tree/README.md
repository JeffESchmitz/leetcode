# 104. Maximum Depth of Binary Tree

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/maximum-depth-of-binary-tree/](https://leetcode.com/problems/maximum-depth-of-binary-tree/)

## Problem

Given the `root` of a binary tree, return *its maximum depth*.

A binary tree's **maximum depth** is the number of nodes along the longest path from the root node down to the farthest leaf node.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
```

**Example 2:**
```
Input: root = [1,null,2]
Output: 2
```

**Constraints:**
- The number of nodes in the tree is in the range `[0, 10^4]`.
- `-100 <= Node.val <= 100`

## Approach

_Worked through the 8-step framework from `COACH.md`. Filled in as we go._

1. **GOAL** — an `Int`: the number of **nodes** on the longest root-to-leaf path.
   Not edges, not a path, not a node. The signature is
   `(TreeNode?) -> Int` — no optional, no `throws` — which is a claim that
   *every* legal input has an answer, including the empty tree.

   Two questions came up here, and they have opposite answers.

   **Can the result be negative?** No — and the reason matters more than the
   answer. `Node.val` can be negative (`-100...100`), but depth is never *read*
   out of the tree; it is **manufactured** by counting nodes. A count built by
   adding 1 to a floor of 0 has no arithmetic path to −1. Guarding the return
   value would not be protecting against the input, it would be distrusting your
   own arithmetic — the same lesson as
   [217](../0217-contains-duplicate/README.md) and
   [704](../0704-binary-search/README.md), read forward: *the best guard is the
   one you never write, because the bad state cannot be expressed.*

   **What about `root == nil`?** Answer 0 — but calling it a "guard" is the
   mistake. A guard is defensive; delete it and the function still works for
   well-behaved callers. Delete this one and nothing works, because **trees are
   made of trees**: `root.left` has the same type as `root`, so `nil` is not
   only the empty-tree input, it is the state you land in every time you step off
   the bottom of *any* branch. `nil → 0` is the **base case**, the thing that
   makes the solution terminate. Recognizing that is most of this problem.
2. **SHAPE** — a binary tree of reference-type nodes: `TreeNode?` for `left` and
   `right`, so absence is `nil` at every level. Compared to the `ListNode` of
   [141](../0141-linked-list-cycle/README.md), one difference changes everything:
   **two children instead of one**, so the structure forks.

   That kills the cursor. In a linked list, `current = current.next` loses
   nothing, because there was only one way forward. In a tree, stepping
   `current = current.left` **overwrites the only reference you were holding** —
   the right subtree isn't "stepped past," it is unreachable. Its parent knew
   about it, but the parent was overwritten too.

   ```
   current → 3          current → 9          20 still exists in memory,
           ↙   ↘                ↙   ↘        but nothing you hold
          9     20            nil   nil      can reach it anymore
   ```

   So traversal needs **branch memory**: somewhere to park the fork you aren't
   currently exploring. A stack is the right structure — and recursion supplies
   one for free. `maxDepth(root.left)` pushes a frame that holds `root` alive,
   still pointing at the right subtree, waiting for the call to return. **The
   call stack *is* the branch memory.** Note where it must *not* live: a property
   on `Solution` would be shared mutable state, wrong the moment two trees are
   measured at once. Per-call locals, which is exactly what a frame is.

   Why `class` and not `struct`, precisely: a value type's layout must be finite,
   and `struct TreeNode { var left: TreeNode? }` contains itself forever — a
   compile-time layout error, not a runtime memory worry. `Optional` doesn't
   rescue it, since for a value type it is an enum with an inline payload rather
   than a pointer. A class reference is a fixed-size 8 bytes, so the recursion in
   the *type* is fine. Bonus: no subtree copying on assignment.
3. **CONSTRAINTS** — three of them, and the one that matters isn't written down.

   - **`0 ≤ nodes ≤ 10⁴` — a hint, and a non-binding one.** The usual move is
     "what Big-O can I afford?", but the better question is *does this constrain
     me at all?* To report the **max** depth you can never skip a node — any node
     you don't visit might be the deepest — so **O(n) is a floor, not a target**.
     The constraint rules nothing out. (O(log n) is the *height* of a balanced
     tree, a different quantity from the work; see below.)
   - **`-100 ≤ val ≤ 100` — a decoy.** Operational test: replace every `val` in
     the tree with `0`. Does the answer change? No. Depth is purely **structural**
     and never reads `val`, so this bound is load-bearing on nothing. Constraints
     are supplied per *problem*, not per *solution* — some are simply noise for
     the approach you chose.
   - **The unstated one: nothing promises the tree is balanced.** This is the
     only constraint that bites. Worst case the tree is fully skewed — a linked
     list wearing tree clothes — so height `h` can equal `n = 10,000`.

   That last point is what makes space interesting. Recursion depth *is* tree
   height, so space is **O(h)**, not O(n) and not O(1):

   | Shape (n = 10⁴) | Height | Frames live at once |
   |---|---:|---:|
   | balanced | ~14 | ~14 |
   | fully skewed | 10,000 | 10,000 |

   Same algorithm, same input size, three orders of magnitude apart — and `h` is
   the one quantity the problem makes no promise about. It is also why the tall
   fixture in the test suite stops at 2,000: a test thread's stack is far smaller
   than the main thread's 8 MB, so a full-height chain could abort a *correct*
   recursive solution locally while passing on the judge.
4. **SIGNATURE** — `func maxDepth(_ root: TreeNode?) -> Int`. **No helper
   needed**, and that is worth a beat: `root.left` is itself a `TreeNode?`, so the
   public signature *is* the recursive signature.

   `TreeNode?` pulls double duty — "the tree might be empty" at the top, "this
   child is absent" at the bottom — which is step 1's insight cashing out. The
   input edge case and the base case are the same case, so the function that
   answers for the whole tree is the function that answers for every subtree.

   Contrast the problems that *do* need `helper(_ node:, depth:)`: those are ones
   where a child's answer depends on where it sits in the tree. Here it doesn't —
   a subtree's depth is a property of that subtree alone, which is exactly the
   property that makes plain recursion sufficient.
5. **EXAMPLE TRACE** — `[3, 9, 20, nil, nil, 15, 7]`, filling in *the height of the
   subtree rooted at each node*:

   ```
           3
         ↙   ↘
        9     20
             ↙  ↘
           15    7
   ```

   | Node | height (nodes) | from |
   |---|---:|---|
   | `9` | 1 | leaf — both children `nil` |
   | `15` | 1 | leaf |
   | `7` | 1 | leaf |
   | `20` | 2 | children answer 1 and 1 |
   | `3` | 3 | children answer 1 and 2 |

   **Two wrong readings had to be cleared first, and both are worth recording
   because each one is a different mistake.**

   - **Wrong direction — distance *from the root* instead of height *below the
     node*.** That table reads `3`→0, `9`/`20`→1, `15`/`7`→2, and it is a
     perfectly real quantity (a node's *level*); it just isn't this one. The tell
     is instant: it assigns the root `0` when the answer must be `3`. Level is
     computed top-down and needs context passed *in*; height is computed bottom-up
     and is returned *out*. Only the second one composes without a helper (step 4).
   - **Wrong unit — edges instead of nodes.** Bottom-up but counting the steps
     between nodes: leaf→0, `20`→1, `3`→2. Off by exactly one everywhere. The
     node convention isn't arbitrary bookkeeping — under the edge convention a
     leaf is 0 and `nil` would have to be **−1**, contradicting the base case from
     step 1. `nil → 0` and "a leaf is 1" are the same decision stated twice.

   Read the correct table as arithmetic and the recurrence falls out:

   ```
   height(node) = 1 + max(height(node.left), height(node.right))
   height(nil)  = 0
   ```

   Check it on the leaf: `9`'s children are both `nil`, so `1 + max(0, 0) = 1`. ✅
   The base case isn't a special case bolted on — it is what makes leaves work.

   Say the recurrence in English: **"my depth is one node — me — plus the deeper
   of my two children."** Notice what is *absent* from that sentence: no
   traversal, no stack, no visiting order. The answer is defined in terms of
   smaller answers, and the recursion supplies the rest.
6. **PATTERN → ALGORITHM** — **post-order DFS**. The recurrence needs `L` and `R`
   *before* it can produce the parent's answer, so the node handles itself last:
   left, right, then me. (Pre-order is me-first, for when children need context
   passed *down*; in-order is left-me-right, which is what yields sorted order on
   a BST. Neither can work here — the parent has nothing to compute until both
   children have reported.)

   "Work happens on the way back up" is easy to nod at and hard to picture, so
   pinned concretely at node `20`:

   ```
   call maxDepth(20)          ← frame pushed; computes nothing yet
     call maxDepth(15) → 1    ← returns UP into 20's frame
     call maxDepth(7)  → 1    ← returns UP into 20's frame
     20 now has L=1, R=1 → returns 1 + max(1, 1) = 2      ← the work
   ```

   `20`'s frame sits **idle** while its children run — it cannot act, because it
   doesn't have `L` or `R` yet. Only when both calls *return* does the arithmetic
   happen: one `max`, one `+1`. That is the entire body of the function, and the
   traversal is a side effect of the recursion rather than something written down.

   **The alternative algorithm: BFS.** Walk the tree level by level with a queue
   and count how many levels you get through. Same answer, no recursion, no
   `1 + max` — a genuinely different machine. The tradeoff is not a wash:

   | | DFS (post-order) | BFS (level count) |
   |---|---|---|
   | memory holds | one root-to-leaf path | one full level |
   | space | **O(h)** — height | **O(w)** — max width |
   | dies on | deep skewed tree (10⁴ frames) | wide balanced tree (~n/2 nodes) |

   Exactly opposite failure modes, which is the useful thing to carry forward: the
   input shape that ruins one is the shape the other handles best. DFS wins here
   on brevity, and the constraints (step 3) are what make its O(h) worst case
   worth a second thought rather than a shrug.
7. **EDGE CASES** — covered by the fixture table below. The two that shaped the
   solution: the **empty tree** (which turned out to be the base case, not an edge
   case) and the **fully skewed tree** (which is what makes O(h) space a real
   number rather than a formality).
8. **DATA STRUCTURES** — none written by hand. The call stack is the branch
   memory (step 2), and the only state is one `Int` per frame. Choosing BFS
   instead would have meant explicitly maintaining a queue.

**This is a tree-recursion problem solved with post-order DFS in O(n) time and
O(h) space — O(log n) on a balanced tree, O(n) on a skewed one.**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

```swift
public func maxDepth(_ root: TreeNode?) -> Int {
    // nil is the base case, not a defensive check: it is where every branch ends
    guard let root else {
        return 0
    }

    let leftDepth = maxDepth(root.left)
    let rightDepth = maxDepth(root.right)

    return 1 + max(leftDepth, rightDepth)
}
```

Accepted on LeetCode, 40/40 test cases, 0 ms (beats 100%). The ~64% memory
percentile is process overhead rather than signal, per
[704](../0704-binary-search/README.md).

## Test fixtures

The fixtures use LeetCode's own level-order notation (`[3, 9, 20, nil, nil, 15, 7]`)
via a `makeTree` helper in the test file, so each case reads like the problem page.

| Case | Why it's there |
|---|---|
| `[3,9,20,nil,nil,15,7]`, `[1,nil,2]` | the two given examples |
| `nil` | empty tree — the only input whose answer is 0 |
| `[1]` | single node; depth counts *nodes*, not edges |
| left-skewed chain / right-skewed chain | degenerate trees — a linked list wearing tree clothes |
| perfect tree of 7 nodes | balanced shape, depth 3 |
| deeper on the left / deeper on the right | mirrored, so neither side can win by accident |
| deepest branch buried in the middle | the answer hangs off an interior node, not an outer edge |
| negative values | depth is structural; `val` never participates |
| 2,000-node chain | stack-depth pressure without exceeding the test thread's stack |
| builder sanity check | every other fixture trusts `makeTree`; this one verifies it |

## Reflection

First tree problem in the repo, and the time split is the lesson.

- **A) Understanding** — the bulk of it. Two *wrong quantities* had to die before
  the right one could be measured: **level vs. height** (distance from the root
  vs. height below the node) and **edges vs. nodes**. Both are real quantities,
  both are commonly called "depth," and neither is what LeetCode is asking for.
- **B) Identifying** — quick, *once the trace table was right*. The recurrence
  wasn't invented; it was read off the table. `20` answers 2 from children
  answering 1 and 1; `3` answers 3 from children answering 1 and 2 — one
  operation explains both rows, and it isn't addition.
- **C) Writing** — about two minutes. Four lines, no debugging, green first run.

The transferable habit: **when a term names more than one quantity, sanity-check
your table against the one number you already know.** The first table assigned
the root `0` while the required answer was `3` — the contradiction was visible
immediately, without knowing anything about trees. A single known-answer anchor
catches a wrong-quantity error before it becomes a wrong algorithm.

The second habit: **define the answer in terms of smaller answers instead of
describing a traversal.** "My depth is one node — me — plus the deeper of my two
children" contains no stack, no visiting order, no bookkeeping. Trees feel hard
while you are trying to *walk* them and become easy when you start *defining*
them.

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **`Optional` turns the base case into a type, not a null check.**
    `guard let root else { return 0 }` reads as unwrapping, but structurally it
    *is* the recurrence's terminating clause. Because `left`/`right` are
    `TreeNode?` — the same type as the parameter — the compiler makes it
    impossible to recurse without confronting the base case. In a language where
    the node type is nullable-by-default, forgetting the check compiles fine and
    crashes at runtime.
  - **The `guard let root` shorthand shadows the parameter.** No `guard let root
    = root`; since Swift 5.7 the bare form binds a non-optional `root` for the
    rest of the body, so the unwrapped value keeps the name the problem gave it.
  - **`max` is a free function, not a method** — `max(a, b)`, not `a.max(b)`.
    (`.max()` exists, but on *sequences*.) So the code transcribes
    `1 + max(L, R)` character for character.
  - **Naming the two results earns its keep.** The body collapses to a one-liner:

    ```swift
    1 + max(maxDepth(root.left), maxDepth(root.right))
    ```

    Correct, and worse. `let leftDepth` / `let rightDepth` mirror the `L` and `R`
    of the recurrence, and — more importantly — they make visible that **two
    calls must return before anything is computed**, which is the entire meaning
    of *post-order*. The nested form hides the pause inside an argument list.
  - **A comment that restates the code is worse than none.** The first draft had
    `// perform the equation (1 + max(leftDepth, rightDepth)) and return the
    result` sitting above `return 1 + max(leftDepth, rightDepth)`. A comment is
    an annotation that cues what you are about to read; when the code already
    says it, the annotation is noise competing with the line it introduces. The
    one comment that survived says *why* `return 0` is there — base case, not a
    guard — which is the fact the code genuinely cannot state.
