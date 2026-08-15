# leetcode — polyglot translation dojo

Solve each problem once in a language you think in (usually Swift), then translate
it into others to learn their idioms. The algorithm is the warm-up; the real
practice is seeing how a Rust, Python, or Kotlin developer expresses the same idea.

## Layout

Problem-first, language-second. Each problem is a folder; each solution language is
a self-contained leaf beneath it.

```
problems/
  0001-two-sum/
    README.md          # display title, approach, per-language idiom notes
    swift/             # source of truth (solved first)
    python/  java/  kotlin/  rust/  go/
```

Folder names are toolchain-safe (`0001-two-sum`, lowercase language dirs); the
pretty `1. Two Sum` title lives in the problem README.

## Workflow

1. Scaffold Swift leaf: `public struct Solution` + `@Suite` test struct, stubbing functions with `fatalError("... is not yet implemented")`.
2. Solve in Swift first — full 8-step process (see `COACH.md`).
3. Translate into each target language in its native IDE, leaning on the editor's
   inspections to learn the idiom.
4. Re-express the example + edge-case tests in that language's native test style.
5. Capture what surprised you in the problem README's idiom notes.

## Problems

Catalog of scaffolded problems (folder has a `README.md`). Link goes to the problem
README — approach, edge notes, and per-language idioms live there. Legacy
`pNNNN-…` leaves and folders without a README are omitted until cleaned up.

| # | Problem | Leaves |
|---|---------|--------|
| 1 | [Two Sum](problems/0001-two-sum/README.md) | go, java, kotlin, python, rust, swift |
| 9 | [Palindrome Number](problems/0009-palindrome-number/README.md) | swift |
| 13 | [Roman to Integer](problems/0013-roman-to-integer/README.md) | swift |
| 20 | [Valid Parentheses](problems/0020-valid-parentheses/README.md) | swift |
| 21 | [Merge Two Sorted Lists](problems/0021-merge-two-sorted-lists/README.md) | swift |
| 70 | [Climbing Stairs](problems/0070-climbing-stairs/README.md) | swift |
| 100 | [Same Tree](problems/0100-same-tree/README.md) | swift |
| 104 | [Maximum Depth of Binary Tree](problems/0104-maximum-depth-of-binary-tree/README.md) | swift |
| 111 | [Minimum Depth of Binary Tree](problems/0111-minimum-depth-of-binary-tree/README.md) | swift |
| 121 | [Best Time to Buy and Sell Stock](problems/0121-best-time-to-buy-and-sell-stock/README.md) | swift |
| 125 | [Valid Palindrome](problems/0125-valid-palindrome/README.md) | swift |
| 141 | [Linked List Cycle](problems/0141-linked-list-cycle/README.md) | swift |
| 169 | [Majority Element](problems/0169-majority-element/README.md) | swift |
| 202 | [Happy Number](problems/0202-happy-number/README.md) | swift |
| 217 | [Contains Duplicate](problems/0217-contains-duplicate/README.md) | swift |
| 226 | [Invert Binary Tree](problems/0226-invert-binary-tree/README.md) | swift |
| 242 | [Valid Anagram](problems/0242-valid-anagram/README.md) | swift |
| 704 | [Binary Search](problems/0704-binary-search/README.md) | swift |

## Lessons that keep recurring

Cross-problem habits earned the hard way. Each links to the problem README where it
first showed up — the point of writing them here is to spot them *before* the next
problem rather than after.

- **Pick an iteration shape where the edge case cannot be expressed.** The best
  guard is the one you never write because the loop can't reach the bad state.
  `for num in nums` never enters on empty; `while low <= high` starts already
  crossed when `high = -1`. Sighted in
  [13. Roman to Integer](problems/0013-roman-to-integer/README.md),
  [217. Contains Duplicate](problems/0217-contains-duplicate/README.md), and
  [704. Binary Search](problems/0704-binary-search/README.md).
- **Ask of every constraint: hint about size, or promise the algorithm leans on?**
  A hint shapes what you can afford and is harmless to violate. A promise is
  load-bearing — violate it and you get a confident *wrong answer*, not a crash. And
  load-bearing promises are usually the ones you deliberately *don't* guard, because
  checking them costs more than the algorithm they enable. See
  [704](problems/0704-binary-search/README.md) (sortedness) and
  [217](problems/0217-contains-duplicate/README.md) (value bounds revoking a
  counting array).
- **When two forms are equivalent, prefer the one that mirrors how the problem states
  it.** Algebraically-equal expressions are not equally *trustworthy*. The form that
  transcribes the problem introduces no derived quantity to compute, truncate, or
  misremember, so there is nowhere for a translation error to hide — while the
  rearranged form is usually surrounded by plausible-looking near-misses.
  `2 * tally > nums.count` states "twice this exceeds the whole" directly, where
  `tally > nums.count / 2` invents a halfway number and then leans on integer
  truncation landing in your favor — and sits one keystroke from the wrong
  `>=`. Same reason `low + (high - low) / 2` beats `(low + high) / 2`: the form that
  *cannot* go wrong wins over the form that merely happens not to. See
  [169. Majority Element](problems/0169-majority-element/README.md) and
  [704. Binary Search](problems/0704-binary-search/README.md).
- **When a word names more than one quantity, anchor on the answer you already
  know.** "Depth" means at least three things — distance from the root, height
  below a node, and either of those counted in edges rather than nodes. The
  mistake isn't exotic: you compute a perfectly real quantity that isn't the one
  asked for, and every subsequent step is confidently wrong. One known-answer
  anchor exposes it instantly and without domain knowledge — a table putting the
  root at `0` when the required output is `3` is refuted on sight. See
  [104. Maximum Depth of Binary Tree](problems/0104-maximum-depth-of-binary-tree/README.md).
- **The input edge case and the recursive base case are often the same case.**
  Reaching for a defensive guard against empty input, then discovering it is
  load-bearing, is a signal you've found the recursion's terminating clause
  rather than a courtesy check. `nil → 0` in
  [104](problems/0104-maximum-depth-of-binary-tree/README.md) isn't bolted onto
  the front for LeetCode's benefit — it is what makes leaves work, and deleting
  it breaks every tree, not just the empty one.
- **Define the answer in terms of smaller answers instead of describing a
  traversal.** "My depth is one node — me — plus the deeper of my two children"
  mentions no stack, no visiting order, no bookkeeping; the traversal falls out
  as a side effect of the recursion. Branching structures feel hard while you try
  to *walk* them and turn easy once you start *defining* them.
  ([104](problems/0104-maximum-depth-of-binary-tree/README.md))
- **Minimums can stop; maximums cannot — that decides BFS vs DFS.** Ask: *if I
  explore outward from the root in order of increasing distance, is the first valid
  answer I hit the final answer?* Yes → BFS, because discovery order is quality
  order and the search can exit early. No → DFS, because you must visit everything
  anyway and DFS is leaner in space. [104](problems/0104-maximum-depth-of-binary-tree/README.md)
  and [111](problems/0111-minimum-depth-of-binary-tree/README.md) differ by one word
  and land on opposite sides of it. Full procedure in [COACH.md](COACH.md).
- **Recency is a tool and a trap in equal measure.** The freshness that let
  [111](problems/0111-minimum-depth-of-binary-tree/README.md) reuse 104's "a phantom
  0 can never win a max" as a *mechanism* is the same freshness that anchored it to
  104's traversal — while the pattern table had already said "min steps → BFS".
  Pattern-match on the problem in front of you, not on the last one you solved, and
  run the decision procedure even when the shape feels settled.
- **An identical base case can have opposite consequences under a different
  combining operation.** `nil → 0` is right in both
  [104](problems/0104-maximum-depth-of-binary-tree/README.md) and
  [111](problems/0111-minimum-depth-of-binary-tree/README.md), but the `0` is a
  claim about a path that does not exist. `max` never listens to it; `min` always
  does. When reusing a recurrence, re-audit what every constant *asserts* rather
  than checking that it was correct last time.
- **When a fix is narrow, the failing tests will say so.** 8 of 18 fixtures failed
  the naive `min` swap, and every failure contained a node with exactly one child
  while no passing case did. A failure set that partitions cleanly along one
  structural property is naming the bug — read the partition before reading the
  code. ([111](problems/0111-minimum-depth-of-binary-tree/README.md))
- **Constraints are permissions, not just limits.** Reading one for what it *enables*
  is a different habit than reading it for what it forbids.
- **Pick data structures by operation frequency × cost.** Find the operation that
  runs `n` times, then ask which structure makes *that one* cheap.
- **Recursion for branching structures; loops for linear narrowing.** A recursion
  with a single subproblem — nothing to unwind, no results to merge on the way back
  up — is a loop wearing a costume, paying for stack frames it doesn't use.
  ([704](problems/0704-binary-search/README.md))
- **Move indices, not elements.** Slicing the surviving half into a new array is
  O(n) per level and silently destroys a log-time budget — and an index into a slice
  isn't the index the caller asked for.
- **Keep value space and index space apart.** Most binary-search bugs live in the
  confusion between "the number stored here" and "where it's stored."
- **Trace the *failing* input, not the passing one.** A found-target trace exits
  early and never shows how the algorithm gives up. The absent-target trace is where
  the termination condition reveals itself.
- **A local test may be stricter than the judge.** LeetCode's constraints say what
  you may optimize for, not what you may assume can't happen — the type system still
  lets a caller pass `[]`.
- **Judge percentiles are not all equal.** Runtime is signal. *Memory* percentile
  for an O(1)-space solution is process noise and moves between submissions of
  identical code. ([704](problems/0704-binary-search/README.md))
- **If a process keeps producing values from a finite set forever, a repeat is
  inevitable — and if the next step is deterministic, a repeat is a cycle.** That
  is the stop signal when the statement only names “reaches 1 or loops forever.”
  You do not need a timeout; you need “have I seen this value?” (hash set) or a
  constant-space cousin (Floyd). Same shape whether the chain is a linked list’s
  `.next` or a pure function `next(x)` like sum of squared digits. Sighted hard in
  [202. Happy Number](problems/0202-happy-number/README.md); already practiced as
  list cycle detection in
  [141. Linked List Cycle](problems/0141-linked-list-cycle/README.md).
- **A transform can collapse a huge legal input into a tiny box in one step.**
  When it does, “large n” is not a divide-and-conquer cue — loop cost is bounded
  by the size of that box, not by the magnitude of the original integer. Do not
  confuse the input’s bit-width with the size of the state space you walk.
  ([202](problems/0202-happy-number/README.md))

## Running a leaf

No shared build — each leaf runs on its own terms, from inside its folder:

| Language | Run |
|----------|-----|
| Swift  | `swift test` |
| Python | `python3 -m unittest` |
| Java   | `java -ea Solution.java` |
| Kotlin | `./gradlew test` (in the leaf) |
| Rust   | `cargo test` |
| Go     | `go test ./...` |

## Toolchains

Swift (Xcode), Python 3, Java 21, and Go come preinstalled on the dev Mac. Kotlin
(`brew install kotlin`) and Rust (`brew install rust`) are added as needed.
