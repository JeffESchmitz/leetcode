# 704. Binary Search

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/binary-search/](https://leetcode.com/problems/binary-search/)

## Problem

Given an array of integers `nums` which is sorted in ascending order, and an integer
`target`, write a function to search `target` in `nums`. If `target` exists, then
return its index. Otherwise, return `-1`.

You must write an algorithm with `O(log n)` runtime complexity.

**Example 1:**
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9 exists in nums and its index is 4
```

**Example 2:**
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
Explanation: 2 does not exist in nums so return -1
```

**Constraints:**
- `1 <= nums.length <= 10^4`
- `-10^4 < nums[i], target < 10^4`
- All the integers in `nums` are **unique**.
- `nums` is sorted in ascending order.

## Approach

Worked through the 8-step framework from `COACH.md`:

1. **GOAL** — return the index of `target` if it is found in `nums`, otherwise `-1`.
   One `Int`, two meanings. `-1` is a legitimate **sentinel** and not a hack: valid
   indices are always `0..<count`, so a negative return can never collide with a real
   answer. "Not found" is an ordinary result, not a failure mode.

   The constraint *"all the integers in `nums` are unique"* is what keeps this GOAL
   to one sentence. Allow duplicates and the spec must add a **tiebreak rule** —
   first index, last index, or any. Uniqueness deletes that sentence, and with it a
   whole confirmation pass in the code:

   | | duplicates allowed, "return the first index" | uniqueness guaranteed |
   |---|---|---|
   | land on a match | might be the *wrong* match — index 3 of `[-1,0,9,9,9,12]` is a `9`, but `2` was the answer | the only match, by definition |
   | code must then | sweep left / re-search to confirm nothing equal precedes it | `return mid` |

   This matters precisely *because* of the `O(log n)` requirement. Log time forbids
   touching every element, which forces an algorithm that **jumps** rather than walks.
   A left-to-right scan gets "first occurrence" for free — it meets the leftmost match
   first, without trying. A jumping search lands somewhere arbitrary. **Uniqueness is
   the constraint that makes "arbitrary" and "correct" the same thing.**
2. **SHAPE** — `[Int]`, ascending, unique, `n` up to 10⁴. Values and indices are
   **separate worlds** here and conflating them is a live bug source: the array holds
   negatives, but `mid` is an index and lives in `0..<count` no matter what is stored.
   The algorithm only ever compares *values* with `<`, `>`, `==`, so negatives are
   not a special case at all.

   The one structural property that makes log time possible: standing at `mid`,
   `nums[mid] = 3` and `target = 9` tells you `nums[0]` and `nums[1]` are also less
   than the target — by sortedness (`nums[0] ≤ nums[1] ≤ nums[2]`) chained with
   transitivity. **Sortedness converts a single comparison into knowledge about an
   entire region.** In an unsorted array, reading `nums[2]` tells you about `nums[2]`
   and nothing else — which is exactly why unsorted search cannot beat O(n).
3. **CONSTRAINTS** — read every constraint by asking:

   > **"Is this a hint about size, or is it a promise my algorithm leans on?"**

   The two are not the same, and mistaking one for the other is how you end up
   writing a guard you don't need — or omitting one you do.

   - `-10^4 < nums[i], target < 10^4` is a **hint**. Nothing in the algorithm's
     logic depends on it; hand it `50_000` and it still returns a correct `-1`.
     Outside the stated constraints is *not* the same as undefined behavior.
   - `nums` is sorted ascending is a **promise the algorithm leans on**. Violate it
     and a jumping search discards the half holding the target and confidently
     reports `-1`. Load-bearing — and never worth guarding, since verifying
     sortedness costs O(n) and would blow the very budget the problem set.

   One more consequence of the size hint: halving 10⁴ elements takes
   `log₂(10⁴) ≈ 13.3` → **14 comparisons worst case**, against ~5,000 for an average
   linear scan. That gap is why the statement can demand `O(log n)` without apology,
   and why "sorted" was worth the ink.
4. **SIGNATURE** — `func search(_ nums: [Int], _ target: Int) -> Int`. Both labels
   suppressed with `_` to match LeetCode's unlabeled `solution.search(nums, target)`.
   `nums` stays a `let` — never mutated, never copied.
5. **EXAMPLE TRACE** — `nums = [-1, 0, 3, 5, 9, 12]`, `target = 2` → expect `-1`.
   The absent-target trace is the one that teaches; a found-target trace exits early
   and never shows you how the algorithm gives up.

   | iter | low, high | mid | nums[mid] | comparison | survives | update |
   |---|---|---|---|---|---|---|
   | 1 | 0, 5 | 2 | 3 | `3 > 2` → go left | left half | `high = mid - 1` → 1 |
   | 2 | 0, 1 | 0 | -1 | `-1 < 2` → go right | right half | `low = mid + 1` → 1 |
   | 3 | 1, 1 | 1 | 0 | `0 < 2` → go right | right half | `low = mid + 1` → 2 |
   | — | **2, 1** | — | — | — | — | `low > high`, window empty → `-1` |

   **The termination condition is `low > high`** — the bounds cross, the window is
   empty, there is nowhere left to probe. Not a counter, not a special case for
   absence; it falls out of the bookkeeping.

   Two things the trace pins down that prose won't:

   - **`mid = low + (high - low) / 2`**, not `(low + high) / 2`. Same value; the
     second can overflow on the sum. Irrelevant here (`Int` is 64-bit, `n ≤ 10⁴`) but
     this is the bug that sat in Java's `binarySearch` for nine years.
   - **Integer division truncates**, so even-length windows consistently round *down*
     to the left-of-center element. Arbitrary but **consistent** — and consistency is
     the requirement. Rounding sometimes left and sometimes right is how you write a
     loop that never terminates.
6. **PATTERN → ALGORITHM** — sorted array + "find the position of X" → **binary
   search**. Discard half the remaining window per comparison, O(log n).

   The remaining problem after one step is `search([5, 9, 12], 9)` — *the same
   problem, smaller*. That **self-similarity** is what licenses recursion, and each
   step strictly shrinks the window, which is what stops it running forever.

   **Recursion was considered and rejected.** Not because it's wrong — it's the
   textbook illustration — but because it's the weaker choice here:

   - **One subproblem, not two.** Recursion earns its keep when a problem *branches*
     (trees, backtracking) — there's something to unwind, results to merge on the way
     back up. Binary search follows a single path. **A single-subproblem recursion is
     a loop wearing a costume.**
   - **The state is two `Int`s.** Recursion's real value is carrying awkward state on
     the call stack. `low` and `high` are not awkward.
   - **Stack cost.** Recursive is O(log n) frames (~14 here); iterative is O(1). Swift
     does not guarantee tail-call elimination, so those frames are real.
   - **Bug visibility.** The signature failure of binary search is a window that fails
     to shrink (`high = mid` instead of `mid - 1`). In a loop, `low` and `high` sit in
     one scope and can be traced by hand. Across call frames the same bug is a stack
     overflow.

   Rule to carry forward: **recursion for branching structures; loops for linear
   narrowing.**

   Also rejected: **slicing out the surviving half** into a new array and recursing on
   it. Two things wrong. Copying is O(n) per level, which destroys the O(log n) budget
   the problem explicitly set — and an index into the slice is not the index the
   caller asked for. **Move the bounds, never the elements.** The array is read-only
   from start to finish.
7. **EDGE CASES** — every hazard in this problem is about **termination**, not
   arithmetic:
   - **empty array** — `low = 0`, `high = -1`, already crossed before the first
     iteration. The loop never runs and `-1` falls out. *No `isEmpty` guard needed.*
   - **target absent / falls between two elements** — the cases that hang forever if
     the window fails to shrink.
   - **single element, no match** — the window collapses to one element that fails,
     and the loop must notice and quit.
   - **all negatives** — *not* a hazard, despite looking like one. Value space, not
     index space.
8. **DATA STRUCTURES** — none. Two `Int`s. **O(1) space** — the other dividend of
   moving bounds instead of elements.

**This is a sorted-array search problem solved with iterative binary search, in
O(log n) time and O(1) space.**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **Pick a loop shape where the edge case cannot be expressed.** `while low <= high`
    handles the empty array with no guard at all, because `high = -1` is already
    crossed before entry. Fourth sighting of this idea, after `for num in nums` in
    [217. Contains Duplicate](../0217-contains-duplicate/README.md) and
    `zip(values, values.dropFirst())` in
    [13. Roman to Integer](../0013-roman-to-integer/README.md): the boundary check
    dissolves into the iteration shape rather than being defended against.
  - **`var` for the bounds, `let` for the array.** The mutability of `low`/`high` and
    the immutability of `nums` are the whole story of the algorithm, stated in
    keywords: the window moves, the data never does.
  - **Every `± 1` is load-bearing.** `high = mid - 1` and `low = mid + 1` step *past*
    the element just ruled out, which is what makes the window strictly shrink. Drop
    either offset and the two-element case spins forever.
  - **Value space vs index space.** `mid` is an index and always lives in `0..<count`;
    the negatives in `nums` are values and only meet `<`, `>`, `==`. Keeping the two
    apart in your head kills a whole class of binary-search bug before it's written.
