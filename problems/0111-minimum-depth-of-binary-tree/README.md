# 111. Minimum Depth of Binary Tree

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/minimum-depth-of-binary-tree/](https://leetcode.com/problems/minimum-depth-of-binary-tree/)

## Problem

Given a binary tree, find its minimum depth.

The minimum depth is the number of nodes along the shortest path from the root node down to the nearest **leaf** node.

**Note:** A leaf is a node with no children.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 2
```

**Example 2:**
```
Input: root = [2,null,3,null,4,null,5,null,6]
Output: 5
```

**Constraints:**
- The number of nodes in the tree is in the range `[0, 10^5]`.
- `-1000 <= Node.val <= 1000`

## Approach

_Worked through the 8-step framework from `COACH.md`. Filled in as we go._

Worked the day after [104. Maximum Depth](../0104-maximum-depth-of-binary-tree/README.md),
and the similarity is the story: the statements differ by one word, the solutions
differ by more than one line, and the *right traversal* is not the same one.

1. **GOAL** — an `Int`: the number of **nodes** on the shortest path from the root
   to the nearest **leaf**. Same type and same totality as 104 — `(TreeNode?) -> Int`,
   `nil → 0` as the base case, no optional.

   The load-bearing word is **leaf**, and LeetCode adds a note defining it that 104
   never needed:

   > A leaf is a node with no children.

   104 got that concept for free. The *longest* path always terminates at a node
   with no children, because you can never stop early on a maximum — so "where am
   I allowed to stop?" never came up. A *minimum* must stop early, which makes the
   stopping condition a real question for the first time.
2. **SHAPE** — identical to 104: a binary tree of reference-type `TreeNode`s with
   `TreeNode?` children, forking, so the call stack (or an explicit queue) supplies
   the branch memory. Nothing new; see
   [104 step 2](../0104-maximum-depth-of-binary-tree/README.md).
3. **CONSTRAINTS** — same three categories as 104, and one of them changed by 10x.

   - **`0 ≤ nodes ≤ 10⁵`** — ten times 104's ceiling. Still a non-binding hint for
     *time* (you cannot skip nodes you haven't ruled out), but it is a real signal
     about *space*: recursion depth equals tree height, and nothing promises
     balance, so a skewed tree is **100,000 stack frames**. On 104 the same argument
     capped at 10⁴. This is the constraint that was on the page the whole time and
     got walked past.
   - **`-1000 ≤ val ≤ 1000`** — a decoy again. Depth is structural; replace every
     `val` with `0` and the answer is unchanged.
   - **Nothing promises balance** — the unstated one, load-bearing for space in
     both directions (see step 6).
4. **SIGNATURE** — `func minDepth(_ root: TreeNode?) -> Int`. No helper, for the
   same reason as 104: `root.left` is itself a `TreeNode?`, so the public signature
   is already the recursive signature.
5. **EXAMPLE TRACE** — the trap, on the smallest input that exposes it. Take
   `[1, 2]`: root `1`, one left child `2`, no right child.

   ```
     1        node 1: has a left child → NOT a leaf
    ↙         node 2: no children      → leaf
   2
   ```

   One valid path, `1 → 2`, so the answer is **2**. Now run 104's recurrence with
   `min` swapped in:

   ```
   minDepth(2)   = 1 + min(0, 0)  = 1        ✅ a leaf is depth 1
   minDepth(nil) = 0
   minDepth(1)   = 1 + min(minDepth(2), minDepth(nil))
                 = 1 + min(1, 0)
                 = 1                          ❌ should be 2
   ```

   **The `0` from the missing right child won.** It asserts "there is a complete
   path of length 0 ending here" — but `nil` is not a leaf, it is the *absence of
   a subtree*, so there is no leaf in it and no path to measure. The two numbers
   `min` is comparing are not comparable: one is a measurement, the other is the
   absence of a thing to measure.

   **Why 104 got away with the identical base case:** `max(depth, 0)` — a phantom
   `0` can never win a maximum, because any real subtree has depth ≥ 1. Under
   `min` it wins every time. *Same base case, opposite consequence.* That is the
   sentence this problem exists to teach.

   Enumerating by child count shows the damage is narrow:

   | Node has | `1 + min(L, R)` gives | correct? |
   |---|---|---|
   | two `nil` children (a leaf) | `1 + min(0,0) = 1` | ✅ |
   | two real children | `1 + min(L, R)` — both real paths | ✅ |
   | **exactly one `nil` child** | `1 + min(real, 0) = 1` | ❌ |

   Two of three already work, including the leaf — which needs no special handling
   at all. Only the one-child node is broken, because it is the only case where
   `min` chooses between a real path and a phantom one. The local suite partitioned
   itself along exactly that line on the first run: **all 8 failures contained a
   one-child node; all 10 passes contained none.**
6. **PATTERN → ALGORITHM** — solved as **post-order DFS**, one branch added; then
   discovered that **BFS is the better algorithm for this problem**, which is the
   real lesson.

   The DFS fix reuses the observation from step 5 as a *tool* rather than a warning:

   ```
   if either child is missing:  1 + max(L, R)   // a phantom 0 can never win a max
   otherwise:                   1 + min(L, R)   // both numbers are real paths
   ```

   One branch covers all three of leaf, left-only, and right-only, because
   `max(real, 0) = real` and `max(0, 0) = 0`. Written as a `guard`, the *valid*
   condition goes in front and the language derives the complement — De Morgan,
   `¬(A ∧ B) = ¬A ∨ ¬B`, so "both children are real" on the happy path yields
   "either child is missing" in the `else` for free.

   **Why BFS wins.** DFS on 111 does provably unnecessary work in a way it never
   did on 104. Consider the worst case — a leaf hanging directly off the root, with
   the entire rest of the tree on the other side:

   ```
   0 ─ right → -1                        (a leaf at depth 2 — this is the answer)
   │
   └─ left  → 1 → 2 → 3 → … → 99,998
   ```

   | | nodes touched | why |
   |---|---|---|
   | DFS | ~100,000 | computes `leftDepth` in full before ever looking right |
   | BFS | 3 | root, then level 2 — hits the leaf, returns |

   Not a constant factor: O(n) against O(1) on the same input. BFS visits in order
   of distance, so **the first leaf it meets is necessarily the shallowest**, and
   nothing unexplored can beat it. It stops. On 104 no algorithm could stop, which
   is why the question never arose.

   The tradeoff does not vanish, it moves: BFS holds a level (**O(w)**, up to
   ~n/2 on a wide balanced tree) where DFS holds a path (**O(h)**, up to n on a
   skewed one). Opposite failure modes, same as 104 — but 111 is the problem where
   the early exit is *reachable*, and the 10⁵ ceiling makes DFS's recursion depth a
   liability besides. BFS wins on both axes here.

   **The clue was in `COACH.md` before a line was written.** The pattern table
   already says *"shortest path" / "min steps", unweighted → BFS*, and "minimum
   depth" is "min steps to a leaf". DFS got picked because 104 was twelve hours
   old and the shapes rhymed — pattern-matching on *yesterday's problem* rather
   than on the statement. The full decision procedure now lives in
   [COACH.md → BFS vs DFS](../../COACH.md), distilled to one question:

   > If I explore outward from the root in order of increasing distance, is the
   > first valid answer I hit the final answer? **Yes → BFS. No → DFS.**
7. **EDGE CASES** — the fixture table below. The ones that earn their keep are the
   **one-child nodes** (root-level and interior, both mirrored), which are the only
   cases the naive recurrence gets wrong, and the **shallow leaf under a deep
   chain**, which is where DFS and BFS separate on cost rather than correctness.
8. **DATA STRUCTURES** — for the DFS, none: the call stack is the branch memory and
   the only state is one `Int` per frame. For the BFS, an explicit queue — and
   `Array.removeFirst()` is **O(n)** in Swift, so a forward-moving read cursor is
   the right idiom (the same trick the `makeTree` test helper uses).

**This is a shortest-path-to-a-leaf problem. Solved here with post-order DFS in
O(n) time and O(h) space; BFS with early exit is the better fit, at O(w) space and
sublinear time whenever a shallow leaf exists.**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

Two implementations, both checked against every fixture.

**`minDepth` — recursive post-order DFS.** O(n) time, O(h) space. Submitted.

```swift
public func minDepth(_ root: TreeNode?) -> Int {
    // nil is the base case, not a defensive check: it is where every branch ends
    guard let root else {
        return 0
    }

    let leftDepth = minDepth(root.left)
    let rightDepth = minDepth(root.right)

    // min is only meaningful when both numbers describe real paths; a missing
    // child contributes a phantom 0 that would win every min it entered
    guard root.left != nil, root.right != nil else {
        return 1 + max(leftDepth, rightDepth)
    }

    return 1 + min(leftDepth, rightDepth)
}
```

**`minDepthBFS` — iterative, level by level, early exit.** O(w) space, and
sublinear time whenever a shallow leaf exists.

```swift
extension TreeNode {
    /// A node with no children — the only place a root-to-leaf path may end.
    var isLeaf: Bool {
        left == nil && right == nil
    }

    /// The children that actually exist: 0, 1, or 2 of them.
    var children: [TreeNode] {
        [left, right].compactMap { $0 }
    }
}

public func minDepthBFS(_ root: TreeNode?) -> Int {
    guard let root else {
        return 0
    }

    var level = [root]
    var depth = 0

    while !level.isEmpty {
        depth += 1

        // Level order guarantees the first level holding a leaf is the
        // shallowest one, so nothing below can beat it
        if level.contains(where: \.isLeaf) {
            return depth
        }

        level = level.flatMap(\.children)
    }

    // Unreachable: every non-empty finite tree contains a leaf, so the loop
    // above always returns. The compiler cannot know that.
    return depth
}
```

Both accepted on LeetCode, 53/53 test cases — and submitting both turned the
theoretical tradeoff into a measurement:

| | runtime | memory |
|---|---|---|
| `minDepth` (DFS) | 24 ms — beats 31% | 29.89 MB — beats 84% |
| `minDepthBFS` (BFS) | **3 ms — beats 75%** | 31.30 MB — beats 16% |

**8× faster, and measurably hungrier.** Exactly the predicted direction: BFS holds
a whole level where DFS holds a single root-to-leaf path, and `flatMap` allocates a
small array per node on top of that. Time bought with space.

Two caveats on reading those numbers. The 1.4 MB absolute difference is small and
memory percentile is process noise per [704](../0704-binary-search/README.md) — the
84 → 16 swing mostly says the field is tightly clustered, not that the solution is
memory-hostile. **Runtime, though, is signal**, and the 9–27 ms spread in the
histogram is roughly the gap between walking the whole tree and stopping at the
first leaf.

Also worth noting: 104 reported 0 ms for a structurally similar DFS. The inputs are
not comparable — 111 permits 10⁵ nodes to 104's 10⁴, and nobody on this problem's
histogram is at 0 ms.

## Test fixtures

Fixtures use LeetCode's level-order notation via a `makeTree` helper in the test
file, so each case reads like the problem page.

| Case | Why it's there |
|---|---|
| `[3,9,20,nil,nil,15,7]`, `[2,nil,3,nil,4,nil,5,nil,6]` | the two given examples |
| `nil` | empty tree |
| `[1]` | single node — the root is itself a leaf |
| `[1,2]` / `[1,nil,2]` | root with exactly one child, mirrored |
| `[1,2,3]` | both children present and both leaves |
| perfect tree of 7 nodes | balanced shape |
| shallower leaf on the right / on the left | mirrored, so neither side wins by accident |
| interior single-child node, left / right | a one-child node *inside* the tree, mirrored |
| left-skewed / right-skewed chain | exactly one leaf, so min and max agree |
| negative values | depth is structural; `val` never participates |
| 2,000-node chain | stack-depth pressure without exceeding the test thread's stack |
| shallow leaf under a 1,000-node chain | the answer is 2 no matter how deep the other side runs |
| builder sanity check | every other fixture trusts `makeTree`; this one verifies it |

## Reflection

Second tree problem, worked the morning after 104, and much faster — the pattern
was recognized on sight and the first code went down within minutes. The time went
somewhere different this time.

- **A) Understanding** — short. The shape was recognized instantly *as 104*, which
  was both the speedup and the mistake.
- **B) Identifying** — the actual work, and it happened **after** a wrong solution
  was already running. The naive `min` swap failed 8 of 18 fixtures, and the
  failures partitioned perfectly along "contains a one-child node."
- **C) Writing** — the algorithm was two lines; the stumbles were all Swift
  mechanics (see idiom notes), not reasoning.

**The thing that actually worked:** 104's footnote — *"a phantom 0 can never win a
max"* — was filed away yesterday as an explanation and got used today as a
**mechanism**. That is the repertoire working as intended: a fact from one problem
becoming an instrument in the next.

**The thing that didn't:** the same recency anchored the traversal. `COACH.md`'s
pattern table already said *"min steps" → BFS*, and it went unread because 104 was
twelve hours old and the tree shape rhymed. **Recency is a tool and a trap in equal
measure.** The general form now lives in
[COACH.md → BFS vs DFS](../../COACH.md) as a decision procedure to run *before*
the shape starts feeling familiar.

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **`guard` bindings do not exist inside `else` — that is the whole point.**
    Writing `guard let left = root.left else { return 1 + max(left, right) }`
    fails with `cannot find 'left' in scope`, and the error is correct: the `else`
    branch is the path where the unwrap *failed*, so there is nothing to bind. It
    is the exact inverse of `if let`, where the binding lives inside the success
    block. `guard` binds *forward*, into the rest of the scope.
  - **Don't bind what you only want to test.** `guard let _ = root.left` unwraps
    into nothing and reads as "a value I intend to ignore"; `guard root.left != nil`
    says what is meant. The earlier version with real names —
    `guard let left = root.left, let right = root.right` — drew
    `immutable value 'left' was never used`, which was the compiler pointing at the
    same thing: the *nodes* were never wanted, only the *depths*, already computed
    two lines above.
  - **The comma in `guard` is AND, and that is what makes it produce the OR.**
    `guard` states the condition for *continuing*, so writing the happy path yields
    its complement for free:

    ```
    continue when:    left != nil  AND  right != nil     (both real → min is valid)
    else fires when:  NOT(both real) = left == nil  OR  right == nil
    ```

    De Morgan, `¬(A ∧ B) = ¬A ∨ ¬B`. This is the repo's recurring lesson again —
    **state the condition the way the problem states it.** "Both children are real"
    is precisely the situation `min` is valid for; spelling out
    `if root.left == nil || root.right == nil` is equivalent and easier to write
    backwards.
  - **Two arrays beat one queue with `removeFirst()`.** The obvious BFS keeps a
    single `queue` and calls `queue.removeFirst()`, but on a Swift `Array` that is
    **O(n)** — it shifts every remaining element down, making a wide level
    quadratic. Two common fixes:

    | Approach | Time per node | Space |
    |---|---|---|
    | `queue.removeFirst()` | O(n) — shifts | O(w) |
    | one array + a forward read cursor | O(1) | **O(n)** — nothing is ever released |
    | `level` / `nextLevel` arrays | O(1) | O(w) |

    The third wins on both axes, and it also removes the `var count = queue.count`
    bookkeeping that a single queue needs to know where one level ends: **the array
    boundary *is* the level boundary**, so one iteration is exactly one level and
    `depth += 1` per outer iteration is self-evidently correct.
  - **Once a level is an array, the loop body is two higher-order calls.** The
    imperative version — a `for` loop with a leaf check and two conditional
    `append`s — states the algorithm in terms of bookkeeping. Naming the two
    concepts as computed properties lets the loop state it directly:

    ```swift
    if level.contains(where: \.isLeaf) {
        return depth
    }

    level = level.flatMap(\.children)
    ```

    *"If this level contains a leaf we're done; otherwise the next level is
    everyone's children."* `flatMap` is precisely right — each node maps to a
    *list* of children and the lists concatenate — and `compactMap` inside
    `children` is what turns `[TreeNode?]` into `[TreeNode]`, so `nil` children
    disappear without an `if let` in sight. The `\.isLeaf` / `\.children` key paths
    are usable as functions directly (Swift 5.2+), removing even the closure.

    The honest cost, since it isn't free:

    | | passes per level | allocations |
    |---|---|---|
    | imperative | 1 — checks and collects together, exits mid-level | one `nextLevel` array |
    | functional | up to 2 — `contains`, then `flatMap` | a 2-element array **per node**, plus the result |

    Neither difference is asymptotic — both are O(w) per level — but the functional
    version scans the level twice and allocates per node, and it finishes scanning
    a level before returning rather than stopping at the leaf. Worth taking anyway
    in a repo whose purpose is learning how a language wants to say things; worth
    reconsidering in a hot loop.
  - **`@Test(arguments:)` runs one fixture against many implementations.** Rather
    than duplicating eighteen tests for the BFS version, the suite is parameterized
    over an enum of the two:

    ```swift
    @Test("example 1", arguments: Implementation.allCases)
    func example1(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([3, 9, 20, nil, nil, 15, 7])) == 2)
    }
    ```

    18 fixtures × 2 implementations = 36 test cases, and the output names each run
    (`.recursiveDFS` / `.iterativeBFS`) so a failure says which one broke. Two
    constraints shaped it: `arguments:` requires `Sendable` values, which a bare
    enum gets for free and a closure over a non-`Sendable` `TreeNode` does not; and
    a `private` type at file scope forces `method must be declared fileprivate` on
    every test taking it, so the enum is left internal to the test target.
