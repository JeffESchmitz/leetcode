# 167. Two Sum II - Input Array Is Sorted

**Difficulty:** Medium
**Link:** https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/

Given a **1-indexed** array of integers `numbers` that is already sorted in
**non-decreasing order**, find two numbers such that they add up to a specific
`target` number. Let these two numbers be `numbers[index1]` and
`numbers[index2]` where `1 <= index1 < index2 <= numbers.length`.

Return _the indices of the two numbers,_ `index1` _and_ `index2`_, **added by
one**, as an integer array_ `[index1, index2]` _of length 2._

The tests are generated such that there is **exactly one solution**. You **may
not** use the same element twice.

Your solution must use only constant extra space.

**Example 1:**
```
Input:  numbers = [2,7,11,15], target = 9
Output: [1,2]
```
The sum of 2 and 7 is 9. Therefore, `index1 = 1`, `index2 = 2`.

**Example 2:**
```
Input:  numbers = [2,3,4], target = 6
Output: [1,3]
```
The sum of 2 and 4 is 6. Therefore, `index1 = 1`, `index2 = 3`.

**Example 3:**
```
Input:  numbers = [-1,0], target = -1
Output: [1,2]
```
The sum of -1 and 0 is -1. Therefore, `index1 = 1`, `index2 = 2`.

Constraints:
- `2 <= numbers.length <= 3 * 10^4`
- `-1000 <= numbers[i] <= 1000`
- `numbers` is sorted in **non-decreasing order**.
- `-1000 <= target <= 1000`
- The tests are generated such that there is **exactly one solution**.

## Approach

**This is a converging two-pointer problem solved in $O(n)$ time and $O(1)$ extra space.**

### Contrast with Problem 1 (Unsorted Two Sum)

In [1. Two Sum](../0001-two-sum/README.md), the input is unsorted. Finding complements requires either:
- $O(n^2)$ exhaustive comparison, or
- $O(n)$ time via a hash map of complements (`target - x`), spending $O(n)$ extra space.

Here, the constraint **"must use only constant extra space"** explicitly rules out the hash map. But the problem gives us a load-bearing promise in exchange: `numbers` is already sorted in non-decreasing order.

### The Elimination Argument

Sortedness provides monotonicity: for any range `[left, right]`, `numbers[left]` is the minimum and `numbers[right]` is the maximum.

When we inspect `sum = numbers[left] + numbers[right]`:
- **If `sum == target`**: We have found the unique answer pair.
- **If `sum < target`**: The sum is too small. Because `numbers[right]` is already the largest element remaining in play, `numbers[left]` cannot reach `target` when paired with *any* element `<= numbers[right]`. Therefore, `numbers[left]` can never participate in the solution. We safely eliminate it: `left += 1`.
- **If `sum > target`**: The sum is too large. Because `numbers[left]` is already the smallest element remaining in play, `numbers[right]` cannot reach `target` when paired with *any* element `>= numbers[left]`. Therefore, `numbers[right]` can never participate in the solution. We safely eliminate it: `right -= 1`.

Each step eliminates one candidate element and narrows the search space by one. With $n$ elements, the pointers converge in at most $n - 1$ steps ($O(n)$ time), using only two integer variables ($O(1)$ extra space).

### Coordinate Boundaries

The problem specifies **1-indexed** output ("added by one"). The clean boundary rule: keep the search loop in native 0-based indices (`0 ..< numbers.count`), and convert to 1-based indexing exclusively at the return site (`[left + 1, right + 1]`).

## Reflection

**Where the time went.** Two sittings: about an hour on 2026-09-21 that ran out
of time without a solution, then 20 to 30 minutes on 2026-09-25 to finish.
**A (understanding) was mostly fine:** "return the indices" was read correctly
on the first pass. **B (identifying) ate the session.** C (writing) took five
minutes or less once the comparisons were named, with one stumble on the
`else if` branch.

**The clue was seen, then dropped.** "Sorted in non-decreasing order" was
spotted within the first two minutes and even said out loud, and then it was
forgotten for the rest of the hour. This was not a failure to understand. It
was a failure to **keep hold of a clue already found**. Sorted is a promise,
and a promise is the tell for left and right pointers. The fix is mechanical:
when a constraint reads as a promise, write it down where it stays visible (a
comment at the top of the file) so it is still on the page at minute 40.

**Two pointers, but which kind?** Day 2 opened with two pointers remembered
right away, but the first proposal was fast/slow. The unlock was one question
from the coach: **"What are we comparing?"** The answer, *values at both ends*,
brought back left-and-right walking inward from 125.

**The `if / else if / else` was invisible until the end.** It was the easiest
part of the problem and the last thing to appear. The branches only show up
once you know what the comparison is between. Ask "what are we comparing?"
first, and the three branches (equal, too small, too big) follow from it.

**Still fuzzy: why both ends and not fast/slow.** It could not be explained
unaided at reflection time. The distinction: fast/slow pointers start together
and move the same way at different speeds, measuring *position* (876, 141, on
linked lists with no back end). Converging pointers start at opposite ends and
compare *values*, which only helps because sorting makes `left` the smallest
value in play and `right` the largest. The test of whether this stuck is 11,
worked cold.

**Honest note on C:** the Swift was written with some Copilot help, though
knowing what to write. This was not a fully cold re-solve.

## Idiom notes

### Swift
- **0-based search, 1-based boundary**: Array subscripting in Swift is 0-indexed. Converting indices to 1-based inside the loop creates off-by-one opportunities; converting only on the `return` statement (`[left + 1, right + 1]`) isolates the problem's idiosyncrasy to the exit boundary.
- **Exhaustive control flow**: The problem guarantees that exactly one valid solution exists, so the `while left < right` loop will always find the pair and return. Swift's compiler requires every execution path to return `[Int]`. Using `fatalError("...")` past the loop asserts this problem invariant and avoids returning dummy data.
