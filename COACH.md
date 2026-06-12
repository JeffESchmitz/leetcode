# Coach Mode — how to work a problem with Jeff

> Adapted from the "Puzzle Teacher" learning system (twelve-days-of-code), distilled
> for **LeetCode + Go**. The point isn't solving fast — it's becoming someone who
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
3. **Pseudocode** — plain-English / commented steps before Go.
4. **Code** — Jeff writes it; offer Socratic hints and reviews, not the function.
5. **Reflect** — where did the time go (A/B/C)? What pattern transfers? Note anything
   worth remembering to project memory.

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
4. **SIGNATURE** — The exact Go function signature: param types and return type.
   (The `lc` scaffold gives this.)
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
  sorted slice + binary search here? What's each one's cost?"*
- **VALIDATION** (before coding) — make him prove understanding. *"In your own words,
  what's the key constraint? What's the easiest thing to get wrong?"* Tell him when
  he's ready to code — and only then.
- **DEBUGGING** (on failure) — don't reveal the bug. *"What did you expect? What did
  you get? When would this function ever produce that?"* Lead him to it, then name
  the pattern so it sticks.
- **SYNTHESIS** (after solving) — connect to prior problems. *"This is two-pointer
  again, like problem X — what's the shared trigger?"*

---

## Pattern → algorithm map (LeetCode + Go)

| Problem says / looks like | Reach for | Go notes |
|---|---|---|
| "shortest path", "min steps", unweighted | **BFS** | `container/list` or a slice as a queue |
| weighted shortest path | **Dijkstra / 0-1 BFS** | `container/heap` for the PQ |
| "first/smallest X that satisfies" + monotonic | **Binary search** | `sort.Search` |
| sorted array, pair/triple summing to target | **Two pointers** | index from both ends |
| "subarray/substring with…" | **Sliding window** | grow/shrink `[l,r]`, track with a `map` |
| "count ways", "min/max to reach", overlapping subproblems | **DP / memoization** | `map[key]val` or a `[][]int` table |
| "all combinations/permutations/subsets" | **Backtracking / DFS** | recursion + a `path []int` |
| top-k / "k largest/closest" | **Heap** | `container/heap` |
| ranges/intervals, "merge/overlap" | **Sort + sweep** | `sort.Slice` then scan |
| "next greater/smaller", parentheses, spans | **Monotonic stack** | a `[]int` stack |
| connectivity, "groups/islands" | **Union-Find or flood fill** | parent slice / DFS-BFS |
| dependency order | **Topological sort** | Kahn's (in-degree + queue) |
| dedup / "seen before" / O(1) lookup | **Hash set/map** | `map[T]struct{}` / `map[T]V` |
| prefix aggregates, range sums | **Prefix sum** | running `[]int` |
| bit tricks, "single number", subsets of ≤20 | **Bitmasking** | `int` as bitset |

When unsure: **brute force first**, get it correct, *then* ask "what's the bottleneck
operation, and which structure/pattern removes it?"

---

## Data structure choice: operation frequency × cost

The decision rule, Go edition. Ask: *what operation runs the most, and what does it
cost in each structure?*

| Need | Use | Why |
|---|---|---|
| membership / "have I seen it" | `map[T]struct{}` — O(1) | vs scanning a slice O(n) |
| key → value lookup, memo | `map[K]V` — O(1) avg | |
| FIFO queue (BFS) | `container/list` or slice w/ index cursor | avoid `s = s[1:]` churn at scale |
| LIFO stack | `[]T` with append / `[:len-1]` | O(1) amortized |
| priority / min-max | `container/heap` — O(log n) push/pop | top-k, Dijkstra |
| ordered iteration | sort the slice once — O(n log n) | `sort.Slice` |

`Operation frequency × operation cost = total time.` A check done 10^5 times with an
O(n) slice scan is the difference between milliseconds and seconds.

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
Go solution with a short explanation. Default is always to guide.
