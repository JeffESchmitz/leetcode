# 217. Contains Duplicate

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/contains-duplicate/](https://leetcode.com/problems/contains-duplicate/)

## Problem

Given an integer array `nums`, return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: true
Explanation: The element 1 occurs at the indices 0 and 3.
```

**Example 2:**
```
Input: nums = [1,2,3,4]
Output: false
Explanation: All elements are distinct.
```

**Example 3:**
```
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true
```

**Constraints:**
- `1 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`

## Approach

Worked through the 8-step framework from `COACH.md`:

1. **GOAL** — a `Bool`. `true` if any value appears at least twice, `false` if every
   element is distinct. Not optional, no error case — the function is total. The
   caller never learns *which* value repeated, *how many* times, or *where*, so
   **no counting is required**: 2 occurrences and 5 occurrences both answer `true`.
   `nums` is never handed back, so whatever happens to it on the way is fair game.
2. **SHAPE** — `[Int]`, may contain duplicates. **No order may be assumed** —
   nothing in the problem promises sortedness.
3. **CONSTRAINTS** — `1 <= nums.length <= 10^5` and `-10^9 <= nums[i] <= 10^9`.
   At n = 100,000, an O(n²) solution performs 10¹⁰ operations against a ~1s judge
   budget — dead by two orders of magnitude. **Ceiling: O(n log n)**
   (100,000 × 17 ≈ 1.7M, trivial). The wide value range revokes one permission worth
   naming: had values been bounded to something like `0...100`, you could index a
   fixed array *by the value itself* and skip any lookup structure. Spanning ±10⁹
   makes that array 2 billion slots — off the table. No overflow risk; 10⁹ fits in
   32 bits, and Swift's `Int` is 64-bit.
4. **SIGNATURE** — `func containsDuplicate(_ nums: [Int]) -> Bool`. The `_` suppresses
   the external label entirely (not "same name inside and out") — LeetCode's harness
   calls `solution.containsDuplicate(nums)` unlabeled, so a labeled signature fails to
   compile against their driver.
5. **EXAMPLE TRACE** — the trace exists to strip away the eyesight cheat. A human
   takes in `[1, 2, 3, 1]` all at once; a machine sees one element at a time and,
   having moved past one, knows nothing about it unless it *deliberately kept
   something*. Memory is the machine's substitute for parallel vision, which turns
   the problem into one question: *standing at element `i`, what is the minimum I
   must have remembered to answer "have I seen this value before?"*

   The traces also expose the asymmetry that sets the cost floor:

   | Claim | Kind | Settled by |
   |---|---|---|
   | "a duplicate exists" | **existence** | one example — find a repeat, stop, the rest is irrelevant |
   | "every element is distinct" | **universal** | exhaustion — 99,999 clean elements prove nothing about the 100,000th |

   So the algorithm is *opportunistic*: it may quit the instant it finds a repeat, but
   absent one it must labor to the end. **Therefore no solution to this problem can
   beat O(n) in the worst case** — skipping even one element leaves open that the
   skipped one was the duplicate. That's a property of the question, not of any code.

   **Floor O(n), ceiling O(n log n).** The target zone was fixed before choosing an algorithm.

   It also fixes the code shape. `false` isn't computed — it's what you arrive at by
   surviving the whole array. Every correct solution looks like:

   ```
   loop over the elements
       if <condition> → return true immediately
   return false            // only reachable by exhausting everything
   ```
6. **PATTERN → ALGORITHM** — two candidates, both admissible:
   - **Sort + adjacent scan**, O(n log n). Rests on an invariant worth proving rather
     than assuming: *in a sorted sequence, equal elements are contiguous.* If two
     equal values `x` sit at positions `i < j` in a non-decreasing array, every
     element between them satisfies `x ≤ e ≤ x`, forcing `e == x` — you cannot wedge
     a different number between a duplicate pair. So checking only neighbors is
     sufficient. But sorting delivers *every element in its exact rank* when the
     question only asks "did anything repeat?" — total order bought, one bit used.
   - **Hash-set membership scan**, O(n) — hits the floor. This is what shipped.
7. **EDGE CASES** — empty (below the judge's `n >= 1`, but reachable through Swift's
   type system, so tested anyway), single element, all-identical, negatives,
   duplicate at first and last position.
8. **DATA STRUCTURES** — `Set<Int>`. Chosen from operation frequency × cost: the
   operation performed n times is a membership test, and a hash set answers it in
   O(1) average. O(n) space.

**This is a duplicate-detection problem solved with a single-pass hash-set membership
scan, in O(n) time and O(n) space.**

### The sort-and-scan version (first solution, kept for the record)

```swift
guard !nums.isEmpty else { return false }

let localNums = nums.sorted()
for i in 1..<localNums.count {
    if localNums[i] == localNums[i - 1] {
        return true
    }
}
return false
```

Correct and accepted-grade, but at the ceiling rather than the floor. Note the
`guard` — it exists solely because `1..<0` is an illegal *range*, constructed before
the loop body ever runs. The Set version needs no such guard.

Open question for a later sitting: **the asymptotically better version may not be the
faster one at n = 10⁵.** Sorting `Int`s is a tight, cache-local, branch-predictable
loop; a `Set<Int>` hashes every element and scatters writes across the heap. 17× fewer
operations does not automatically beat a 5–10× worse constant factor. Unmeasured —
recorded as a hypothesis, not a finding.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **`insert` returns `(inserted: Bool, memberAfterInsert: Element)`.** The obvious
    spelling — `if seen.contains(num) { return true }; seen.insert(num)` — hashes
    every element **twice**. `insert` already had to locate the slot in order to
    decide whether to write, so it just reports what it found. One lookup does both
    jobs: asks the question and records the answer.
  - **Pick an iteration shape where the edge case cannot be expressed.** The sorted
    version needed `guard !nums.isEmpty` only because `1..<count` is a *range*
    built before the loop runs, and `1..<0` traps. `for num in nums` has no boundary
    to get wrong — an empty array simply never enters. Third sighting of this same
    lesson, after `zip(values, values.dropFirst())` in
    [13. Roman to Integer](../0013-roman-to-integer/README.md): the boundary check
    dissolves into the iteration shape rather than being defended against.
  - **`Set<Int>(minimumCapacity:)`** pre-allocates so the set never rehashes mid-scan.
    Real trade-off, not a free win: on `[1, 1, ...]` it allocates 100,000 slots and
    then bails on element two. Pays off in the `false` case (which must scan
    everything anyway); slightly wasteful in the fastest `true` case.
  - **Constraints are permissions, not just limits.** `-10^9...10^9` is what *revoked*
    the counting-array approach. Reading a constraint for what it enables is a
    different habit than reading it for what it forbids.
  - **A local test can be stricter than the judge.** LeetCode guarantees
    `n >= 1`, so the empty-array test is outside its contract — but Swift's type
    system lets any caller pass `[]`, and that test is exactly what caught the
    `1..<0` trap. Constraints say what you may *optimize for*, not what you may
    *assume cannot happen*.
