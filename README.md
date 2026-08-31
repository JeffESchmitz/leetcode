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
🔴 marks a leaf scaffolded with failing tests and left unsolved on purpose — a translation waiting to be attempted from memory.

| # | Problem | Leaves |
|---|---------|--------|
| 1 | [Two Sum](problems/0001-two-sum/README.md) | go, java, kotlin, python, rust, swift |
| 3 | [Longest Substring Without Repeating Characters](problems/0003-longest-substring-without-repeating-characters/README.md) | go, swift 🔴 |
| 9 | [Palindrome Number](problems/0009-palindrome-number/README.md) | swift |
| 13 | [Roman to Integer](problems/0013-roman-to-integer/README.md) | swift |
| 20 | [Valid Parentheses](problems/0020-valid-parentheses/README.md) | swift |
| 21 | [Merge Two Sorted Lists](problems/0021-merge-two-sorted-lists/README.md) | swift |
| 26 | [Remove Duplicates from Sorted Array](problems/0026-remove-duplicates-from-sorted-array/README.md) | swift |
| 70 | [Climbing Stairs](problems/0070-climbing-stairs/README.md) | swift |
| 100 | [Same Tree](problems/0100-same-tree/README.md) | swift |
| 104 | [Maximum Depth of Binary Tree](problems/0104-maximum-depth-of-binary-tree/README.md) | swift |
| 111 | [Minimum Depth of Binary Tree](problems/0111-minimum-depth-of-binary-tree/README.md) | swift |
| 121 | [Best Time to Buy and Sell Stock](problems/0121-best-time-to-buy-and-sell-stock/README.md) | swift |
| 125 | [Valid Palindrome](problems/0125-valid-palindrome/README.md) | swift |
| 136 | [Single Number](problems/0136-single-number/README.md) | swift |
| 141 | [Linked List Cycle](problems/0141-linked-list-cycle/README.md) | swift |
| 169 | [Majority Element](problems/0169-majority-element/README.md) | swift |
| 202 | [Happy Number](problems/0202-happy-number/README.md) | swift |
| 206 | [Reverse Linked List](problems/0206-reverse-linked-list/README.md) | swift |
| 217 | [Contains Duplicate](problems/0217-contains-duplicate/README.md) | swift |
| 226 | [Invert Binary Tree](problems/0226-invert-binary-tree/README.md) | swift |
| 242 | [Valid Anagram](problems/0242-valid-anagram/README.md) | swift |
| 283 | [Move Zeroes](problems/0283-move-zeroes/README.md) | swift |
| 496 | [Next Greater Element I](problems/0496-next-greater-element-i/README.md) | swift |
| 643 | [Maximum Average Subarray I](problems/0643-maximum-average-subarray-i/README.md) | swift |
| 704 | [Binary Search](problems/0704-binary-search/README.md) | swift |
| 724 | [Find Pivot Index](problems/0724-find-pivot-index/README.md) | swift |
| 771 | [Jewels and Stones](problems/0771-jewels-and-stones/README.md) | go, swift 🔴 |
| 1046 | [Last Stone Weight](problems/1046-last-stone-weight/README.md) | swift |
| 1979 | [Find Greatest Common Divisor of Array](problems/1979-find-greatest-common-divisor-of-array/README.md) | swift |

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
  [704](problems/0704-binary-search/README.md) (sortedness),
  [217](problems/0217-contains-duplicate/README.md) (value bounds revoking a
  counting array), and
  [496](problems/0496-next-greater-element-i/README.md) (uniqueness and the
  subset guarantee carrying the dictionary design, while the `≤ 1000` size
  bound is only a hint), and
  [724](problems/0724-find-pivot-index/README.md) (`1 <= nums.length` is the
  promise that deletes the empty guard; both other constraints are only hints).
- **An identity is not a test.** `total = leftSum + nums[i] + rightSum` is true at
  *every* index — it is what "total" means, so testing it always passes and tells
  you nothing. Its value is that you can **rearrange** it to compute a quantity you
  would otherwise have to loop for: `rightSum = total - leftSum - nums[i]`. The
  *test* is a separate, sometimes-false statement: `leftSum == rightSum`. Whenever
  a one-pass trick replaces an inner loop, look for exactly this pair — an identity
  supplying the machinery, and a predicate asking the question. Collapsing them into
  one line is the classic way to write something that compiles, runs, and is
  meaningless. Sighted in
  [724. Find Pivot Index](problems/0724-find-pivot-index/README.md).
- **Sentinel safety comes from the *return* domain, not the input constraints.**
  A magic `-1` is unambiguous when it lies outside the set of legal answers — and
  what defines that set is *what you return*, not what you were given.
  [496](problems/0496-next-greater-element-i/README.md) returns *values*, so its
  `-1` is safe only because `0 <= nums[i]` forbids negative ones;
  [724](problems/0724-find-pivot-index/README.md) returns an *index*, so `-1` is
  safe no matter how negative the values get. Ask "could a real answer ever equal
  my sentinel?" against the output domain, and the input bounds stop being a
  distraction.
- **A performance claim needs a mechanism, not a number.** "This version uses less
  memory" is a hypothesis until you can name the byte it removed — a dropped
  allocation, a smaller array, an avoided copy. Absent a *because*, suspect the
  measurement. Judge memory percentiles on an `O(1)` solution measure process RSS
  (language runtime + the input the judge allocated for you), so they wobble across
  identical submissions. The cheap decisive check is an instruction diff:
  `swiftc -O -emit-assembly` both versions and compare. Two forms of
  [724](problems/0724-find-pivot-index/README.md) — one naming `rightSum` in a
  `let`, one inlining it into the `if` — produced **36 instructions each with zero
  diff**, because a `let` names a register, not a byte. Falsifier for any such
  claim: resubmit the *identical* code and see whether the number moves.
- **Before trusting a benchmark percentile, look at the spread of the whole
  distribution.** The question is not "is this metric speed or memory?" but
  **"is the spread wide enough that my choices could move it?"** A distribution
  only a few percent wide is measuring a floor you do not control; one spanning
  orders of magnitude is measuring your decisions. The two histograms on an
  accepted [643](problems/0643-maximum-average-subarray-i/README.md) submission
  make the contrast in one glance — runtime ran `0ms → 1334ms` (**~1300×**,
  separating `O(n)` from `O(n × k)`, so *beats 100%* was earned), while memory
  ran `21.3mb → 22.4mb` (**1.05×**, the Swift runtime plus the judge-allocated
  input, against which two `Int`s are invisible, so *beats 6.90%* meant
  nothing). Read the axis before reading the percentile.
- **"In-place, keep relative order" ⇒ fill from the left, and the swap only
  reaches backward.** Swapping each unwanted element toward the *far end* puts
  the unwanted ones where they belong and emits the keepers **back to front** —
  the first keeper flung right is the last one you will ever see. Not an
  off-by-one; the direction of the algorithm. The working shape is a read/write
  pair moving the same way: `read` is the clock and visits every slot, `write`
  is the next slot a keeper belongs in and advances only when one is placed.
  Both swap targets are `<= read`, so the unread tail is never touched and
  mutating while iterating is safe. Picture: `[ settled | discarded | unread ]`.
  See [283](problems/0283-move-zeroes/README.md).
- **A debug `print` can be the nested loop you did not write.** `"\(nums)"`
  formats every element — `O(n)` — and doing that once per iteration is `O(n²)`
  from a line that "just prints." On [283](problems/0283-move-zeroes/README.md)
  it was 20,000 formats of a 10,000-element array (~100 MB of string building)
  that locked the terminal. Trace on the small example, then delete the prints
  before the suite runs, or filter: `swift test --filter example1`.
- **Read compound constraints apart, not as a unit.** One line can carry both
  kinds at once. `1 <= k <= n <= 10^5` is three separate statements: `<= 10^5`
  is a sizing *hint* that decides your Big-O, while `1 <= k` and `k <= n` are
  load-bearing *promises* that delete guards — no divide-by-zero, at least one
  window always exists, so no empty case, no sentinel, and a non-optional
  return type. See [643](problems/0643-maximum-average-subarray-i/README.md).
- **Read a constraint as a range of scenarios, not as the one number in the
  example — and check the middle, not just the ends.** Sizing an approach
  against the sample input is how `O(n × k)` looks affordable: `k = 4` is one
  example's value, not a constraint. Push the variable across its whole legal
  range, then push *past* the endpoints. Brute force on
  [643](problems/0643-maximum-average-subarray-i/README.md) costs
  `(n - k + 1) × k`, which is `O(n)` at both `k = 1` **and** `k = n` — at
  `k = n` there is only one window, so nothing slides — but `≈ n²/4` at
  `k = n/2`. Endpoint-only testing would have declared it safe. When a cost
  formula multiplies two quantities that trade off against each other, the
  worst case lives *between* the extremes.
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
