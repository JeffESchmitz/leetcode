# 226. Invert Binary Tree

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/invert-binary-tree/](https://leetcode.com/problems/invert-binary-tree/)

## Problem

Given the `root` of a binary tree, invert the tree, and return its root.

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

1. **GOAL** — Jeff's statement, unprompted:

   > Swap the left and right children of every node, all the way down, and
   > return the root.

   Correct and complete. Two things worth sharpening.

   **"Every node" has to include the nodes where swapping looks pointless.** On
   a leaf the swap is a genuine no-op (`nil` ↔ `nil`). On a node with exactly
   one child it is *not* — it moves that child to the opposite side, and `nil`
   is a legitimate operand of the swap rather than a case to skip. This is the
   cousin of [111](../0111-minimum-depth-of-binary-tree/README.md)'s lesson, and
   it points the opposite way: there, a `nil` child was a phantom that had to be
   excluded from a `min`; here, a `nil` child is real data that has to be moved.

   **The examples cannot confirm this definition.** A competing reading —
   *"reverse the values at each level"* — produces the identical output on all
   three given examples, because Examples 1 and 2 are **perfect trees** and
   Example 3 is empty. The two readings only diverge on a node with one child:
   inverting `[1,2]` gives `[1,nil,2]`, while reversing a one-element level
   leaves it at `[1,2]`. So the structural definition above is doing work the
   problem page never demanded — and the one-child and skewed-chain fixtures are
   what hold it to account.

   On the return: inversion never changes *which* node is the root, since the
   root has no parent to be swapped under. Only the subtrees move.

   Left open deliberately for step 6: the sentence says nothing about **order** —
   whether the swap happens before or after descending. That is a real question,
   and its answer is not obvious from the goal alone.
2. **SHAPE** — a binary tree of `TreeNode`s with `TreeNode?` children, forking,
   so the call stack supplies the branch memory. Structurally identical to
   [104](../0104-maximum-depth-of-binary-tree/README.md) and
   [111](../0111-minimum-depth-of-binary-tree/README.md) — but one detail that
   was inert on both of those becomes load-bearing here.

   **`TreeNode` is a `class`.** On 104 and 111 the tree was only ever *read*, so
   reference semantics never came up. This is the first problem here that
   *changes* the structure, and Jeff went straight at it:

   > A class being a reference type is just a pointer, a lightweight thing, but
   > a struct has to be fully defined and that's gonna cause a problem, right?

   Right on both counts — and the two counts turn out to be **one fact seen
   twice**: a reference is a *fixed-size handle to a shared object*.

   - **Fixed-size ⇒ the type can be recursive at all.** A pointer is 8 bytes
     regardless of how large the subtree beneath it is, so the size question is
     settled without knowing anything about the children. This is what "has to
     be fully defined" was circling, and the precise constraint is *size*: Swift
     lays structs out inline and must know that layout at compile time. Written
     as a value type, `size(TreeNode) = size(Int) + 2 × size(TreeNode?)`, and
     since `size(TreeNode?) ≥ size(TreeNode)` there is no finite solution. The
     compiler says so directly:

     ```
     error: value type 'TreeNode' cannot have a stored property that
            recursively contains it
     ```

     Worth knowing where the escape hatch is: `indirect` fixes exactly this by
     boxing the payload behind a reference — but it applies only to **enums**
     (`indirect enum T { case node(Int, T?, T?) }` compiles;
     `indirect struct` is `error: 'indirect' modifier cannot be applied to this
     declaration`). A recursive *value* type in Swift is an `indirect enum`, not
     a struct.
   - **Shared ⇒ a mutation sticks.** `node.left = node.right` rewrites a pointer
     in the one and only node object, so every holder of that node observes the
     change — including the caller who passed `root` in. That is what makes
     "swap in place and hand back the same root" coherent. Under value
     semantics `let child = node.left` would be a *copy*, mutating it would
     change nothing, and the only way to record a swap would be to rebuild every
     parent back up to the root.

   Note what this does **not** decide: mutating in place and building a new tree
   are both legitimate. The class makes the first one *possible*, not mandatory
   — which is why every fixture asserts on the returned root.

   **Size:** at most **100 nodes**, values in `-100...100`. Tiny. Worst-case
   recursion depth is a 100-node skewed chain, so the stack-depth anxiety that
   dominated 111 (10⁵ nodes) is simply absent here.
3. **CONSTRAINTS** — two of them, and running each through the repo's question —
   *"a hint about size, or a promise my algorithm leans on?"* — turns up a third
   category the dichotomy doesn't quite name.

   - **`-100 ≤ Node.val ≤ 100`** — a **pure decoy**, and more thoroughly so than
     in 104 or 111. There, `val` was unread because depth is structural. Here it
     is unread because inversion never *looks* at a value at all: no comparison,
     no arithmetic, no equality. Replace every `val` with the same constant and
     the work is unchanged. This is exactly why the suite carries a
     duplicate-values fixture — if values carry no information, an implementation
     must not be able to pass by preserving the multiset of them.
   - **`0 ≤ nodes ≤ 100`** — the **upper** bound is an ordinary size hint:
     100 nodes affords anything, including deliberately wasteful approaches.
     The **lower** bound is the interesting half, and it is load-bearing —
     but in the opposite direction from a promise.

     A promise is a **permission**: 704's sortedness lets the algorithm *skip*
     work, and is deliberately not checked because verifying it would cost more
     than the search it enables. The `0` here is an **obligation**: it widens
     the input domain to include the empty tree, so `nil` is a case that must be
     *answered*, not one that may be assumed away. Example 3 (`[] → []`) exists
     on the problem page to say precisely this.

     The honest footnote: the obligation is free. Recursion reaches `nil` at
     every leaf's children regardless of what the lower bound said, so the base
     case has to exist anyway — and the same line that handles an absent child
     handles an absent root. `nil` is the base case, not a defensive check, for
     the third problem running.

   **What the 100-node ceiling buys.** Jeff's instinct — *"buffer overflow or
   the dreaded O(n²)?"* — points at the right anxiety with the wrong names.

   | | |
   |---|---|
   | *buffer overflow* | wrong mechanism — writing past an allocation, a memory-safety bug Swift's bounds checking rules out, and there are no buffers here |
   | **stack overflow** | the real thing 111 threatened: one frame per level of depth, and 10⁵ nodes in a skewed chain meant 10⁵ frames |
   | *O(n²)* | not inherent to this problem — every node is visited once and swapped in O(1), so the work is O(n) |

   At 100 nodes the worst case is a 100-node skewed chain, so recursion depth
   tops out around 100 frames. The stack-depth question that shaped 111's
   fixtures does not arise here at all. The suite carries a 2,000-node chain
   anyway, deliberately past the ceiling — see the fixture table for why that is
   a claim about the implementation rather than about the problem.

   The one place a quadratic *could* still be introduced is not in the
   algorithm but in the plumbing: `Array.removeFirst()` is O(n) in Swift, so an
   iterative version built on a naive queue re-creates the trap documented in
   [111](../0111-minimum-depth-of-binary-tree/README.md). Self-inflicted, not
   given by the problem.
4. **SIGNATURE** — `func invertTree(_ root: TreeNode?) -> TreeNode?`, and **no
   helper** — the public signature is already the recursive one, for the third
   problem running (see [104](../0104-maximum-depth-of-binary-tree/README.md)
   and [111](../0111-minimum-depth-of-binary-tree/README.md)). What is new is
   that the reason got stated properly rather than observed.

   **A helper exists to carry state the public signature has nowhere to put.**
   A running total, a max seen so far, a depth counter, a parent pointer,
   upper/lower bounds — every one of those is a case where a subtree *cannot*
   be processed in isolation, because something has to be handed down from
   above. The public function then becomes a thin wrapper that seeds it.

   So the deciding question is not "is this recursive?" but **"does inverting a
   subtree require knowing anything about the tree above it?"** Its depth, its
   parent, which side it hung off, what has already been swapped elsewhere —
   none of it. The inversion of a subtree is fully determined by that subtree.
   No carried state ⇒ nothing for extra parameters to carry ⇒ no helper.

   Jeff's own step 6 sentence had already answered this before the question was
   asked: *"each subtree node must be inverted, and each of its children
   inverted, and each of theirs"* contains no "given X from the parent" clause.

   **Optional-in / optional-out is what makes the call sites clean.** The
   function takes a `TreeNode?` and `root.left` *is* a `TreeNode?`, so a child
   is already exactly the argument `invertTree` wants — it goes straight in,
   `nil` and all, with no unwrapping at the call site. The `guard let root else`
   instinct is correct but belongs in exactly one place:

   | | where | how many times |
   |---|---|---|
   | ❌ unwrap each child before recursing | at every call site | twice per node |
   | ✅ base case at the top of the function | once, at entry | once per function |

   The recursion absorbs `nil` children because the parameter type already
   admits them. Special-casing a missing child before the call would be
   re-implementing the base case at the wrong altitude.

   And the return type being `TreeNode?` rather than `Int` changes none of
   this. What matters is that the parameter type equals the child type and that
   no state is threaded — the type mapping is self-similar either way.
5. **EXAMPLE TRACE** — **`[2,1,3]` → `[2,3,1]`.** Traced correctly by hand:

   ```
   Call 1  node 2   not nil → swap children (1 ↔ 3), recurse into each
     Call 2  node 1   leaf: both children nil, "swap nil and nil"
                      recursing passes nil → returns nil → returns node 1
     Call 3  node 3   same → returns node 3
   back in Call 1     each returned node lands in the opposite child slot
   result  root 2, left 3, right 1
   ```

   Two things this surfaced.

   **The order of *swap* versus *recurse* is genuinely open.** The trace above
   swaps first and then descends into the already-swapped slots; descending
   first and swapping the two returned subtrees afterwards produces the same
   tree. Both are correct, because each subtree is inverted exactly once either
   way and the swap at a node commutes with the work below it. This is a real
   choice to settle at step 6, not an error to fix — though the in-place
   ordering does raise a question the other does not: if a slot is overwritten
   before its original occupant has been read, what is left to recurse into?

   **`nil` is data here, not a hazard.** Noted as a live habit worth
   unlearning: iOS work trains reflexive nil-aversion, and this problem rewards
   the opposite. A `nil` child is a legitimate value that flows *through* the
   base case and lands in a slot like any other. It is guarded once, at the top
   of the function, rather than defended against at each call site — the
   distinction drawn in step 4.

   **`[1,2]` → `[1,nil,2]`**, the case the whole step was pointed at. Recursing
   on `root.right` passes `nil` straight in; the base case returns `nil`; that
   `nil` lands in the left slot. **No special handling anywhere** — the missing
   child takes exactly the same path through the function as a real one. This is
   the concrete payoff of optional-in/optional-out from step 4, and it is what
   makes the algorithm below have exactly one guard in it.

6. **PATTERN → ALGORITHM** — _arrived at early, during step 1. Recorded here
   where it belongs; the rest of this step still to be worked._

   Jeff, reasoning from "this is an operation we have never done before":

   > Each subtree node must be inverted (its two children swapped), and each of
   > its children inverted, and each of theirs, recursively all the way down,
   > including nils.

   That is the self-similar structure, stated before the framework asked for it:
   *inverting a tree is swapping the root's two children and then inverting each
   of them* — the problem defined in terms of itself on smaller inputs, which is
   the definition of a recursive one.

   One precision to fix, and it is the base case hiding in the sentence. "Including
   nils" is doing two jobs at once:

   | `nil` as… | real? |
   |---|---|
   | an **operand** of a swap — a slot that gets moved | ✅ yes, and step 1 is why |
   | a **subject** of an inversion — something you recurse into | ❌ nothing to invert |

   A `nil` is not a node, so it is not a thing that *gets* inverted; it is where
   the descent stops. Same shape as the `guard let root else { return 0 }` that
   opens both [104](../0104-maximum-depth-of-binary-tree/README.md) and
   [111](../0111-minimum-depth-of-binary-tree/README.md) — `nil` is the base
   case, not a defensive check.

   **The algorithm, as Jeff stated it after the traces:**

   1. base case: `nil` → return `nil` (the only guard needed)
   2. swap the left and right child pointers of the current node
   3. recurse into `left`
   4. recurse into `right`
   5. return the current node, so the parent can relink

   Correct and complete: **recursive pre-order DFS**, O(n) time — every node
   visited once, O(1) work at each — and O(h) space for the call stack, capped
   at ~100 frames by the constraints.

   **The chosen ordering is swap-first**, and it is worth recording that the
   alternative is equally correct rather than merely tolerated:

   | | shape | how the swap happens |
   |---|---|---|
   | **swap-first** (chosen) | swap, then recurse into the two slots | mutating a node's pointers, needing a temp |
   | recurse-first | invert both children, then assign the results crosswise | the returns land in locals, so no temp arises |

   Both invert each subtree exactly once. Under swap-first the slots are already
   relabeled by the time the recursion runs, so each original subtree is still
   reached exactly once and **the order of the two recursive calls is
   irrelevant**. Under recurse-first the two results sit in locals before either
   is assigned, which sidesteps the clobbering question entirely.

   **The clobbering question, since swap-first is what raises it.** Written as
   the obvious two lines, the swap destroys its own input:

   ```swift
   node.left = node.right
   node.right = node.left
   ```

   After line 1 the original left child is unreferenced by `node`; line 2 then
   reads the *new* `node.left`, which is the right child it just wrote, and both
   slots end up holding the same subtree. The original left is simply gone. Three
   idiomatic repairs, all verified to compile:

   ```swift
   let temp = node.left
   node.left = node.right
   node.right = temp

   swap(&node.left, &node.right)

   (node.left, node.right) = (node.right, node.left)
   ```

   The tuple form is the most idiomatic Swift of the three: the right-hand side
   is fully evaluated before any assignment happens, so the temporary still
   exists — the language just holds it instead of the programmer naming it. It
   also reads as one indivisible action rather than three steps that happen to
   compose, which is the repo's recurring preference for **stating the operation
   the way the problem states it**.

7. **EDGE CASES** — the fixture table below lists them; the question worth
   asking is which ones are actually *dangerous*, and the answer separates two
   things that look alike.

   **The empty tree is an obligation, not a trap.** Jeff's reasoning was right
   on the mechanics — `invertTree(nil)` short-circuits at the guard and never
   reaches the right child at all — but it is worth being precise about what
   that fixture is doing there. It exists because step 3's `0` lower bound puts
   the empty tree in the domain, so the function must *answer* for it. It is not
   catching anything: no plausible wrong solution passes the other thirteen
   fixtures and then fails on `nil`. Coverage, not a trap.

   **Two fixtures are genuinely load-bearing**, and each one exists because a
   specific plausible mistake survives everything else.

   | Fixture | The mistake it kills |
   |---|---|
   | **one-child node** (`[1,2]`, `[1,nil,2]`, and the interior pair) | the *"reverse the values at each level"* misreading from step 1 |
   | **duplicate values / same values, different shape** | comparing trees by their multiset of values rather than by structure |

   The first is the sharper of the two, because the problem page actively hides
   it: reversing each level produces **byte-identical output** on Examples 1 and
   2 (both perfect trees) and on Example 3 (empty). The two readings diverge
   only where a node has exactly one child — `[1,2]` inverts to `[1,nil,2]`,
   while reversing a one-element level leaves the child untouched. Every example
   LeetCode supplies is blind to the difference.

   The second matters because of step 3's decoy: inversion never reads a value,
   so values carry no information about whether the answer is right. A checker
   that compares multisets of values would accept a tree that was never
   inverted at all.

   **The takeaway, stated generally:** a dangerous fixture is one that
   **diverges from a specific plausible mistake** — not one with the biggest or
   most complex tree. The 100-node ceiling makes "large" fixtures cheap to write
   and worthless to have; the two-node one-child case is the whole test suite's
   center of gravity.
8. **DATA STRUCTURES** — for the recursive version, **none written by hand**.

   The first guess was `TreeNode?`, which is the *data* the algorithm moves
   through rather than the structure holding its state. The structure is the
   **call stack**: recursion borrows the runtime's own frame stack to remember
   which nodes are half-finished and where to return, and each frame here holds
   nothing but a reference and a return address. That borrowed stack *is* the
   O(h) space from step 3 — the cost was already counted before the container
   was identified.

   **For an iterative version, a queue** — correct, and the reason it is correct
   is more interesting than the answer. **Inversion is order-agnostic.** No
   node's swap depends on any other node's swap having happened first, so every
   traversal that visits each node exactly once produces the same tree:

   | Container | Traversal | Works? |
   |---|---|---|
   | stack (`append` / `removeLast`) | DFS | ✅ |
   | queue | BFS | ✅ |
   | recursion (implicit stack) | DFS | ✅ |

   This is precisely the freedom [111](../0111-minimum-depth-of-binary-tree/README.md)
   did not have. There, BFS was *better* — visiting in order of distance let the
   search stop at the first leaf. Here there is nothing to stop early for: every
   node must be touched, so the COACH.md question — *"is the first valid answer
   I hit the final answer?"* — does not even apply. Traversal choice is a pure
   engineering trade-off rather than a correctness or complexity one, which is
   why it is the third tree problem in a row and the first where the container
   genuinely does not matter.

   The trade-off, should the iterative version get written: it swaps the
   implicit call stack for an explicit one, buying freedom from any
   recursion-depth ceiling (irrelevant at 100 nodes) and paying in code volume.
   And it re-opens step 3's trap — a naive array-as-queue with
   `removeFirst()` is O(n) per pop; `append`/`removeLast` as a stack avoids it
   for free.

**This is a tree-transformation problem solved with recursive pre-order DFS in
O(n) time and O(h) space.** Pre-order because the swap happens *before* the
descent; the recurse-first variant from step 6 is the same algorithm written
post-order.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

**`invertTree` — recursive pre-order DFS.** O(n) time, O(h) space. Green on the
first run against all 19 fixtures.

```swift
public func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root else {
        return nil
    }

    (root.left, root.right) = (root.right, root.left)
    root.left = invertTree(root.left)
    root.right = invertTree(root.right)
    return root
}
```

Left uncommented deliberately. Every line of it is explained at length above,
and there is nothing here a comment would cue that the framework write-up does
not already say better: `nil` is the base case (step 4), the tuple swap is
indivisible (step 6), the recursive calls commute (step 6).

Five lines of body for eight steps of reasoning, which is roughly the point:
nothing in the code records that a one-child node is the dangerous case, or that
`nil` had to be data rather than a hazard. The tests hold that.

## Test fixtures

This is the first tree problem here that returns a **tree** rather than an `Int`,
so the suite needs a way to compare shapes. Two helpers do it: `makeTree` builds
from LeetCode's level-order notation (carried over from
[111](../0111-minimum-depth-of-binary-tree/README.md)), and `levelOrder` renders
a tree back into it. Both sides of every assertion therefore read like the
problem page.

Serializing rather than walking two trees with a `Bool` helper is deliberate: a
failing `#expect` prints both arrays, so the output shows the shape that came
back instead of only "expected true".

Nearly every fixture asserts on the **returned** root, which keeps the harness
neutral between swapping in place and building a new tree. The one deliberate
exception is `returns the root it was given`, which also reads back through the
*original* reference — that one does pin the implementation to in-place
mutation, on the grounds that a caller still holding the root should see the
inverted tree.

**19 fixtures.** Fifteen came from the scaffold; four more were added while
working the framework, marked ✚ below.

| Case | Why it's there |
|---|---|
| `[4,2,7,1,3,6,9]`, `[2,1,3]`, `[]` | the three given examples |
| `[1]` | single node — nothing to swap |
| `[1,2]` / `[1,nil,2]` | root with exactly one child, mirrored |
| ✚ perfect tree of 7 nodes | every level reverses cleanly |
| left-skewed / right-skewed chain | every node moves to the far side, mirrored |
| lopsided tree | asymmetry has to survive the swap, not be flattened by it |
| ✚ interior single-child node, left / right | a one-child node *inside* the tree, mirrored |
| ✚ duplicate values | inversion is positional; preserving the value multiset is not enough |
| negative values | inversion is structural and never reads `val` |
| a tree that is its own mirror | inverting is a no-op — catches one level too many or too few |
| invert twice restores the original | a property that holds for every input, not one example |
| returns the root it was given | root identity survives, and the caller's reference sees the change |
| tall degenerate chain (2,000 nodes) | what the implementation *survives* — see below |
| helper sanity check | round-trips the notation between `makeTree` and `levelOrder` |

The four added fixtures are the ones step 7 argued are load-bearing: the
**interior one-child** pair is what separates true inversion from the
*"reverse the values at each level"* misreading — a reading that produces
identical output on every example the problem page supplies, since all of them
are perfect or empty — and **duplicate values** forces the comparison to be
structural rather than a multiset of values.

**On the 2,000-node chain.** It is far past the problem's ceiling of 100 nodes,
so nothing the judge sends can reach it. Kept anyway, and worth being explicit
about why the reasoning in step 3 and the fixture disagree: the constraints make
recursion depth a non-question *for this problem*, so the chain is not defending
against LeetCode. It documents what this implementation can survive if the same
code is lifted somewhere the bound does not hold — a different and smaller
claim than "this test is necessary." Compare
[111](../0111-minimum-depth-of-binary-tree/README.md), where a 10⁵ ceiling made
the same fixture genuinely load-bearing and it still had to stop at 2,000
because a test thread's stack is smaller than the main thread's.

## Reflection

Third tree problem, and the first one where the algorithm was never in doubt. The
time went almost entirely into *stating* things that earlier problems had only
been *observed* to be true.

- **A) Understanding** — fast, and correct on the first attempt: the goal was
  stated structurally ("swap the left and right children of every node, all the
  way down") rather than by pointing at the examples. That phrasing turned out to
  be doing real work — see step 1, where all three supplied examples are blind to
  the competing reading.
- **B) Identifying** — arrived during step 1, before the framework asked for it,
  and from the right premise: *this is an operation we have not done before*, so
  it got derived from what inversion **is** instead of pattern-matched onto 104
  or 111. That is the exact failure 111's reflection warned about, avoided.
- **C) Writing** — the only real friction, and it was mechanical: how to swap two
  properties in Swift without the first assignment clobbering the second's input.

**What transferred.** Three problems in, `guard let root else { return … }` is
now automatic, and the *reason* finally got said out loud: `nil` is the base
case, not a defensive check. 104 and 111 both had that line; this is the problem
where it became a sentence.

**What was new.** Two things that 104 and 111 could not teach, because both of
them only ever *read* the tree:

1. **Reference semantics as a capability, not trivia.** `TreeNode` being a
   `class` is what makes "mutate in place and hand back the same root" coherent
   at all — and, seen from the other side, is what makes the recursive type
   *representable*. One fact, two consequences (step 2).
2. **`nil` as data.** Named as a live habit worth unlearning: iOS work trains
   reflexive nil-aversion, and here the missing child is a legitimate value that
   flows through the base case and lands in a slot like any other. The
   temptation was to guard it at each call site; it belongs at the top, once.

**The sharpest general lesson** came from step 7, and it is about tests rather
than algorithms: **a dangerous fixture is one that diverges from a specific
plausible mistake, not one with the biggest tree.** The two-node `[1,2]` case is
this suite's center of gravity, and the 100-node ceiling made every "large"
fixture cheap to write and worthless to have.

**A new category for the constraints question.** `COACH.md` asks *"a hint about
size, or a promise my algorithm leans on?"* — and the `0` lower bound on node
count is neither. A promise is a **permission** (704's sortedness lets the
algorithm skip work). This is an **obligation**: it widens the domain and
demands an answer for the empty tree. Worth carrying forward as a third thing to
look for.

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **Tuple assignment is a swap, and it is the idiomatic one.** The obvious two
    lines destroy their own input — `node.left = node.right` leaves the original
    left unreferenced, so the next line reads back the value it just wrote and
    both slots end up holding the same subtree. Three repairs work:

    | Form | |
    |---|---|
    | `let temp = node.left; …` | explicit, three statements |
    | `swap(&node.left, &node.right)` | stdlib, needs `inout` access to both |
    | `(node.left, node.right) = (node.right, node.left)` | **idiomatic** |

    The tuple form wins because the right-hand side is **fully evaluated before
    either assignment happens** — the temporary still exists, Swift just holds it
    instead of the programmer naming it. It also reads as one indivisible action
    rather than three steps that happen to compose, which is this repo's
    recurring preference for stating the operation the way the problem states it.
  - **A bare recursive call warns, and the fix documents the intent.** Because
    reference semantics make the mutation stick, `invertTree(root.left)` as a
    statement is genuinely sufficient — and the compiler still objects:

    ```
    warning: result of call to 'invertTree' is unused [#no-usage]
    ```

    `_ = invertTree(root.left)` silences it and says nothing.
    `root.left = invertTree(root.left)` silences it and says *where the result
    belongs* — which is also what keeps the function honest if it is ever
    rewritten to build a new tree instead of mutating one. Assigning the result
    back costs nothing under reference semantics and buys independence from them.
  - **`guard let root else` shadows the optional with a non-optional of the same
    name**, so everything after it reads as though the parameter were never
    optional — `root.left`, not `root?.left`. Third problem leaning on this, and
    the reason it matters more here than in 104 or 111: this function *writes*
    through that binding, and optional-chained assignment (`root?.left = …`)
    would silently do nothing when `root` is `nil` rather than being rejected.
  - **Optional-in / optional-out removes the call-site checks entirely.** Because
    the parameter type is `TreeNode?` and `root.left` *is* a `TreeNode?`, a child
    is already exactly the argument the function wants. No unwrapping before
    recursing, no branch for a missing child — the `nil` goes in, the base case
    swallows it, and `nil` comes back out to be stored like any other value. One
    guard in the whole function, and it is not there for safety.
