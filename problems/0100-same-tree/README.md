# 100. Same Tree

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/same-tree/](https://leetcode.com/problems/same-tree/)

## Problem

Given the roots of two binary trees `p` and `q`, write a function to check if they are the same or not.

Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.

**Example 1:**
```
Input: p = [1,2,3], q = [1,2,3]
Output: true
```

**Example 2:**
```
Input: p = [1,2], q = [1,null,2]
Output: false
```

**Example 3:**
```
Input: p = [1,2,1], q = [1,1,2]
Output: false
```

**Constraints:**
- The number of nodes in both trees is in the range `[0, 100]`.
- `-10^4 <= Node.val <= 10^4`

## Approach

_Worked through the 8-step framework from `COACH.md`. Filled in as we go._

1. **GOAL** — decide whether two binary trees are the same: a `Bool`. Jeff's
   first pass was "if two trees, in an array, are the same" — two sharpenings
   fell out of that.

   **There is no array.** `[1,2,3]` is LeetCode's level-order *notation*, not
   the input; the function receives two `TreeNode?` roots and walks structure,
   not indices. And the notation bites: Jeff read Example 2 —
   `p = [1,2]`, `q = [1,null,2]` — as q having "one more child node on its
   left." Both trees have exactly two nodes; the `null` isn't padding, it's q
   *saying* "my left slot is occupied by nothing." p's 2 is in the **left**
   slot, q's 2 is in the **right** slot, and the slots disagree → `false`.

   That produced the definition, in Jeff's words:

   > Same means: values are the same, positions are the same, including
   > nil/null.

   Or, one level crisper: every node carries **two named, distinguishable
   slots — left and right — and `nil` is a real occupant of a slot**, not the
   absence of one. Two trees are the same when, walking both in lockstep,
   every position agrees: both slots hold nodes with equal values, or both
   hold `nil`. ("Balanced" is a red herring here — balance is about subtree
   *heights* and plays no role in sameness.)

   And the definition is **recursive on its face**: "two trees are the same
   when their roots match *and their left subtrees are the same and their
   right subtrees are the same*" — sameness defined in terms of smaller
   sameness. Same move as [104](../0104-maximum-depth-of-binary-tree/README.md):
   *define the answer in terms of smaller answers instead of describing a
   traversal.*

2. **SHAPE** — two binary trees of `TreeNode?`, forking, so the call stack
   supplies branch memory — same family as
   [104](../0104-maximum-depth-of-binary-tree/README.md),
   [111](../0111-minimum-depth-of-binary-tree/README.md), and
   [226](../0226-invert-binary-tree/README.md), but with a first for this repo:
   the recursion carries **two cursors in lockstep** instead of one. The pair
   `(p, q)` is the unit of comparison. (An iterative version would store
   *pairs* in one stack/queue — never two independent ones, which would let
   the walks drift out of sync.)

3. **CONSTRAINTS** — the drill: *hint about size, or promise the algorithm
   leans on?*

   | Constraint | Verdict | Consequence |
   |---|---|---|
   | nodes in `[0, 100]` | **hint** | any correct algorithm passes; recursion depth ≤ 100 can't overflow; the `0` demands the empty-tree base case |
   | values in `[-10⁴, 10⁴]` | **hint, nearly inert** | comparison is `==` only — no arithmetic, no overflow, no sentinels (contrast [217](../0217-contains-duplicate/README.md), where value bounds revoked a whole data structure) |

   Unusually, this problem has **zero load-bearing promises** — nothing like
   [704](../0704-binary-search/README.md)'s "sorted ascending." Nothing needs
   guarding; the types and the truth table cover everything.

   Jeff's formulation of the size reading: **"O(n) is the floor, not a
   target."** You can't certify sameness without looking at every node — the
   mismatch could be the last leaf visited (the `deepDifference` test exists
   to prove it) — and when the floor is affordable, the floor *is* the target.

   On height: `h` is `O(log n)` **only if balanced**, and nothing promises
   balance — a 100-node chain has height 100. So worst case `h = O(n)`, and
   height matters because it *is* the space complexity: recursion parks one
   stack frame per level, O(h) = O(n) worst. Trivially affordable at n ≤ 100;
   the same question at n = 10⁵ ([111](../0111-minimum-depth-of-binary-tree/README.md)'s
   constraint) gets a different answer.

   **Time O(n) · Space O(h)**.

4. **SIGNATURE** — `func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool`,
   matching the judge so it pastes back unchanged.

5. **EXAMPLE TRACE** — Example 2 (`[1,2]` vs `[1,null,2]`) is the instructive
   one and did double duty above: the mismatch is found at the *root*, whose
   left slot (2 vs `nil`) disagrees — no descent needed. A trace of
   `p = q = [1]` shows the other thing worth seeing: the answer is
   `1 == 1 AND isSameTree(nil, nil) AND isSameTree(nil, nil)` — the whole
   verdict rests on the both-`nil` base case.

6. **PATTERN → ALGORITHM** — **DFS, post-order, recursive.** COACH.md's word
   table says it outright ("same tree? → DFS — the answer is a function of
   *subtrees*, not of distance"), and the decision procedure backs it:

   - *"Is the first valid answer hit in distance order the final answer?"* —
     **No.** A `false` (witnessed mismatch) is irrevocable, but both DFS and
     BFS find those fast; the *positive* verdict is only ever provisional
     until every node-pair has reported. `p = [1,2,3]`,
     `q = [1,2,3,null,null,null,null,99]` matches at distance 0 and 1 and is
     refuted at distance 2. Sameness is an "all/every" property — maximums
     cannot stop. No early-exit prize for distance order, so no queue.
   - *"Does each node's answer depend on its children's answers?"* — **Yes**:
     `isSame(p, q) = vals match AND isSame(lefts) AND isSame(rights)`. That
     shape *is* post-order DFS mechanically — children report, parent
     combines. You don't choose DFS here; you chose it when you wrote the
     definition. The call stack is the stack.

   The base cases are a truth table over the pair's *states* (Jeff: "I feel
   like I'm building a BitWise AND table" — close; it's the **equality**
   table):

   | `p` | `q` | verdict |
   |---|---|---|
   | nil | nil | `true` |
   | node | nil | `false` |
   | nil | node | `false` |
   | node | node | values equal AND lefts same AND rights same |

   One rule covers all three `nil` rows: **agreement on existence** — same
   state (both present or both absent), else `false` without ever looking at
   values. The both-`nil` → `true` verdict is **load-bearing, not a courtesy**:
   `[1]` vs `[1]` reduces to it twice, so if it were `false` no tree would
   ever match anything. The input edge case and the recursive base case are
   the same case — again [104](../0104-maximum-depth-of-binary-tree/README.md)'s
   lesson.

7. **EDGE CASES** — covered by the 13-test suite: both empty (`true`), one
   empty (`false`, both argument orders), single node same/different,
   identical and opposite-skewed chains, a difference deep in the tree, one
   tree a subtree of the other, negative values.

8. **DATA STRUCTURES** — none. The recursion's conjunction short-circuits on
   the first witnessed difference, and the stack is the only state. In Swift
   the truth table wants `switch (p, q)` — pattern matching on a pair of
   optionals *is* the table, written in the language's native notation.

**This is a TREE-EQUALITY problem solved with RECURSIVE POST-ORDER DFS in O(n) time, O(h) space.**

## Code

13 of 13 tests green; judge accepted 67/67, 0 ms (beats 100%). The whole
algorithm, and it is the truth table from step 6 written once:

```swift
public func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    guard let p, let q else {
        return p == nil && q == nil
    }
    return p.val == q.val
        && isSameTree(p.left, q.left)
        && isSameTree(p.right, q.right)
}
```

The `guard let p, let q` *fails* in three of the four truth-table rows —
`(nil, nil)`, `(node, nil)`, `(nil, node)` — and all three land in the `else`,
which asks the only question still undecided there: do the states agree?
(`p == nil && q == nil`). Both-present falls through with `p`/`q` rebound as
non-optional. One existence question, asked once, in the only place the answer
isn't already known.

Two alternate forms were compared against this — one written during the
session, one lifted from a top LeetCode submission — and both make the same
mistake in different costumes:

- **The literal table** (`if both nil → true; if either nil → false; then
  p!.val == q!.val && …`) asks "both absent?" and "exactly one absent?" as two
  separate questions, and the force unwraps tell the compiler something it
  should already know — the nil checks two lines up can't be carried forward
  through `||`, so you reach past the type system with `!`.
- **The top submission's funnel** (`if p != nil && q == nil → false` ×2, then
  `guard … else → true`) asks existence **five times** to answer the same one
  question, and the mirrored `!=`/`==` pair is a copy-paste hazard. Its doc
  comment *is* the four-row truth table — the code just expands it back into
  a checklist.

The keeper lesson: **explicit case enumeration feels safer but multiplies the
surface for error; the fold is shorter *and* stronger.** In the folded form the
optional versions of `p` and `q` cease to exist below the `guard` — the invalid
states aren't guarded against, they're *unnameable*. (One legit taste note in
the top solution's favor: pulling `if p.val != q.val { return false }` out as
its own early return makes each line veto one thing — marginally easier to
breakpoint, marginally less declarative. Either is defensible.)

Judge memory percentile landed low (beats ~18%) and was ignored, per
[704](../0704-binary-search/README.md): *runtime is signal; memory percentile
for an O(1)-structure solution is process noise.* The histogram is a tight
~19 MB band — the Swift runtime's fixed baseline plus machine jitter; the
algorithm's own footprint is a few stack frames.

## Reflect

- **A — Understanding:** the level-order notation was the only real trap —
  reading `[1,null,2]`'s `null` as padding instead of as q *stating* "my left
  slot is empty" cost one wrong reading of Example 2, and produced the
  problem's core definition: **`nil` is a real occupant of a named slot.**
- **B — Identifying:** the recurrence was derived from the definition *before*
  it was named post-order DFS — the traversal was chosen by the shape of the
  answer, then confirmed by the decision procedure (a veto needs no distance
  order; `true` is only earned at the end). Right order: definition first,
  pattern name second.
- **C — Writing:** green on the first run in both forms; the `guard` fold was
  found without prompting.
- **Pattern card for the table:** *"same X?", "is X equal to Y?",
  "symmetric?"* → recursive DFS whose recursive case is a conjunction of child
  verdicts. The structure being compared *is* the recursion's shape. First
  two-cursor recursion in the repo: one call stack carrying a pair.
- **Recency check:** this sat one folder away from [226](../0226-invert-binary-tree/README.md)
  and reused 104/111's base-case lesson — but the BFS-vs-DFS procedure was run
  anyway, because [111](../0111-minimum-depth-of-binary-tree/README.md)'s
  warning cuts both directions: recency is a tool and a trap.

## Idiom Notes

- **Swift:** `guard let p, let q else { … }` collapses the three nil-involving
  rows of the truth table into a single state-agreement question, and rebinds
  `p`/`q` as non-optional below — the type system enforces what the
  force-unwrap version only hoped for.
