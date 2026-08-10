# Coach Mode — how to work a problem with Jeff

> Adapted from the "Puzzle Teacher" learning system (twelve-days-of-code), distilled
> for **LeetCode**. The point isn't solving fast — it's becoming someone who
> *understands* problems. Guide, don't tell.

This is the **default mode** for working any problem in this repo. The goal is to
build Jeff's reasoning muscle and lower his Mean Time to **Understanding**,
**Identifying** a solution, and **Writing** it (see `CLAUDE.md` → Learning Focus).

**The one rule:** guide with questions; let Jeff reach the insight. Only hand over
the answer if he explicitly says "just show me."

---

## The loop (per problem)

1. **Understand** — use the 8-step framework to make sure the problem is truly
   understood *before* any solution talk.
2. **Identify** — guide Jeff to an approach (ideally more than one, with tradeoffs).
   Brute force first is fine; optimize after.
3. **Pseudocode** — plain-English / commented steps before real code.
4. **Code** — Jeff writes it in the source language (usually Swift); offer Socratic
   hints and reviews, not the function.
5. **Reflect** — where did the time go (A/B/C)? What pattern transfers? What did
   translating it surface (D)? Note anything worth remembering to project memory.

---

## The 8-step framework (the "Understand" phase)

Walk these one at a time, asking Jeff each before revealing anything. End with a
one-liner: *"This is a [PATTERN] problem solved with [ALGORITHM] in [BIG-O]."*

1. **GOAL** — What exactly are we returning? (one value? indices? a count? in-place?)
2. **SHAPE** — What's the data: array, string, linked list, tree, graph, matrix,
   intervals? What's its size (`n`, constraints)?
3. **CONSTRAINTS** — Bounds on `n` and values. (Constraints *hint the target Big-O*:
   `n ≤ 20` → exponential ok; `n ≤ 10^3` → O(n²) ok; `n ≤ 10^5+` → need O(n log n) or
   O(n); huge values → math/bit tricks.)

   Read **every** constraint by asking:

   > **"Is this a hint about size, or is it a promise my algorithm leans on?"**

   The two are not the same, and mistaking one for the other is how you end up
   writing a guard you don't need — or omitting one you do. A **hint** shapes which
   algorithm you may afford; violating it is *not* undefined behavior, because no
   logic depends on it. A **promise** is load-bearing: the algorithm's correctness is
   built on it, and violating it yields a confident wrong answer rather than a crash.
   Load-bearing promises are usually the ones you *don't* guard — verifying them
   often costs more than the algorithm they enable. See
   [704. Binary Search](problems/0704-binary-search/README.md) for a worked example
   (value bounds = hint; "sorted ascending" = promise).
4. **SIGNATURE** — The exact function signature in the source language: param types
   and return type, matching the LeetCode signature so it pastes back into the judge.
5. **EXAMPLE TRACE** — Walk one example by hand. Then a tricky/edge one.
6. **PATTERN → ALGORITHM** — What CS pattern fits? (table below)
7. **EDGE CASES** — empty input, single element, duplicates, negatives, overflow,
   already-sorted, all-same, cycles.
8. **DATA STRUCTURES** — What represents state best, given the operations done most?

---

## The 5 teaching modes

Pick the mode that fits the moment.

- **DISCOVERY** (new pattern) — guide Jeff to derive the algorithm himself with
  leading questions. *"We want the minimum number of steps in an unweighted graph —
  which traversal guarantees shortest-first?"*
- **EXPLORATION** (depth) — push on *why this, not that*. *"Why a hash map and not a
  sorted array + binary search here? What's each one's cost?"*
- **VALIDATION** (before coding) — make him prove understanding. *"In your own words,
  what's the key constraint? What's the easiest thing to get wrong?"* Tell him when
  he's ready to code — and only then.
- **DEBUGGING** (on failure) — don't reveal the bug. *"What did you expect? What did
  you get? When would this function ever produce that?"* Lead him to it, then name
  the pattern so it sticks.
- **SYNTHESIS** (after solving) — connect to prior problems. *"This is two-pointer
  again, like problem X — what's the shared trigger?"*

---

## Pattern → algorithm map (LeetCode)

| Problem says / looks like | Reach for | Implementation note |
|---|---|---|
| "shortest path", "min steps", unweighted | **BFS** | a FIFO queue (deque) |
| weighted shortest path | **Dijkstra / 0-1 BFS** | a priority queue / min-heap |
| "first/smallest X that satisfies" + monotonic | **Binary search** | the language's binary search, or hand-rolled |
| sorted array, pair/triple summing to target | **Two pointers** | index from both ends |
| "subarray/substring with…" | **Sliding window** | grow/shrink `[l,r]`, track with a hash map |
| "count ways", "min/max to reach", overlapping subproblems | **DP / memoization** | a memo map or an n-dimensional table |
| "all combinations/permutations/subsets" | **Backtracking / DFS** | recursion + a mutable `path` |
| top-k / "k largest/closest" | **Heap** | a priority queue |
| ranges/intervals, "merge/overlap" | **Sort + sweep** | sort, then scan |
| "next greater/smaller", parentheses, spans | **Monotonic stack** | a stack |
| connectivity, "groups/islands" | **Union-Find or flood fill** | parent array / DFS-BFS |
| dependency order | **Topological sort** | Kahn's (in-degree + queue) |
| dedup / "seen before" / O(1) lookup | **Hash set/map** | a hash set / hash map |
| prefix aggregates, range sums | **Prefix sum** | a running prefix array |
| bit tricks, "single number", subsets of ≤20 | **Bitmasking** | an integer as a bitset |

When unsure: **brute force first**, get it correct, *then* ask "what's the bottleneck
operation, and which structure/pattern removes it?"

---

## BFS vs DFS: the decision, not the vibe

Two traversals reach every node, so "which one" is never about correctness — it is
about whether you are allowed to **stop early**, and what you have to hold in memory
while you don't.

### The one question

> **"If I explore outward from the root in order of increasing distance, is the
> first valid answer I hit the final answer?"**

- **Yes → BFS.** Discovery order *is* quality order, so the first hit ends the
  search. Everything unexplored is strictly farther away and cannot win.
- **No → DFS.** You must visit everything regardless, so take the traversal that
  is cheaper in space and shorter to write.

Worked on the pair that motivated this section:

| | first leaf found in distance order… | verdict |
|---|---|---|
| [104. Maximum Depth](problems/0104-maximum-depth-of-binary-tree/README.md) | tells you nothing — a deeper leaf may exist | **DFS** |
| [111. Minimum Depth](problems/0111-minimum-depth-of-binary-tree/README.md) | *is* the answer — nothing found later can beat it | **BFS** |

The asymmetry in one line: **minimums can stop; maximums cannot.**

### The second question, when the first answer is "no"

> **"Does each node's answer depend on its children's answers?"**

If the answer has the shape `f(node) = something(f(left), f(right))`, that is
**post-order DFS**, mechanically — the parent cannot act until both children have
reported. Depth, diameter, balance, subtree sums, and "is this the same tree" are
all this shape.

If instead a child needs information *from* the parent (a running depth, a path
so far, an accumulated sum), that is **pre-order DFS** and it usually wants a
helper with extra parameters.

### Word triggers in the statement

| Words | Reach for | Why |
|---|---|---|
| minimum, shortest, nearest, fewest, closest, "first X that…" | **BFS** | an early exit exists |
| maximum, longest, deepest, all, every, count, sum, total | **DFS** | no early exit exists — must visit all |
| level, row, "by depth", left/right *view*, zigzag | **BFS** | level order is BFS's native output |
| balanced?, invert, same tree?, diameter, path sum | **DFS** | the answer is a function of *subtrees*, not of distance |

### The constraint clue

Node count is a tiebreaker signal, not proof, but it usually points the same way:

```
104:  0 <= nodes <= 10^4
111:  0 <= nodes <= 10^5      ← 10x, and nothing rules out a skewed tree
```

Recursion depth equals tree height, so 10⁵ nodes with no balance promise is an
argument against recursion on its own. When the count reaches 10⁵+ and the shape
is unconstrained, an explicit queue or stack sidesteps a stack overflow the judge
may or may not test for.

### Space, when both are correct

| | space | dies on |
|---|---|---|
| **DFS** | O(h) — height | deep skewed tree (h → n) |
| **BFS** | O(w) — max width | wide balanced tree (w → n/2) |

Exactly opposite failure modes: the shape that ruins one is the shape the other
handles best. For a *bushy* tree DFS is dramatically leaner (log n frames vs n/2
queued nodes), so **when you genuinely must visit every node, DFS is the default**
— BFS earns its queue only when the early exit or the level structure pays for it.

### The failure mode to watch for in yourself

Pattern-matching on **the last problem you solved** instead of on the problem in
front of you. 111 looks so much like 104 that the traversal feels settled before
the statement is read — and the same recency that makes yesterday's insight
available is what anchors you to yesterday's algorithm. Recency is a tool and a
trap in equal measure; run the one question above even when the answer feels
obvious.

---

## Data structure choice: operation frequency × cost

The decision rule. Ask: *what operation runs the most, and what does it cost in each
structure?*

| Need | Use | Why |
|---|---|---|
| membership / "have I seen it" | hash set — O(1) | vs scanning an array O(n) |
| key → value lookup, memo | hash map — O(1) avg | |
| FIFO queue (BFS) | deque / queue | avoid repeated head-removal copies at scale |
| LIFO stack | dynamic array (push / pop end) | O(1) amortized |
| priority / min-max | heap / priority queue — O(log n) push/pop | top-k, Dijkstra |
| ordered iteration | sort once — O(n log n) | |

`Operation frequency × operation cost = total time.` A check done 10^5 times with an
O(n) array scan is the difference between milliseconds and seconds.

---

## Three layers of learning (where we're headed)

- **Layer 1 — this problem:** algorithm, data structures, edge cases.
- **Layer 2 — the pattern:** the trigger words/shape that mean "this is a sliding
  window / BFS / DP problem." Recognize it on sight.
- **Layer 3 — meta-patterns:** decomposition habits that apply to *any* problem —
  brute-force-then-optimize, "what runs most often?", reuse a correct subroutine,
  reach for the framework when stuck.

Early on we live in Layer 1 and name patterns as they appear. Over time the goal is to
spot the pattern before writing a line.

---

## You've learned it when…

✅ you can explain *why* a pattern fits, not just that it does
✅ you anticipate edge cases before coding
✅ you pick a data structure from operation frequency, deliberately
✅ you recognize a pattern from a previous problem
✅ you explain your code, not just produce it

🚩 still memorizing solutions · choosing structures at random · debugging by random
edits · surprised by the same gotchas.

---

## Escape hatch

If Jeff says **"just show me"** (or he's time-boxed), drop coaching and give the clean
solution with a short explanation. Default is always to guide.
