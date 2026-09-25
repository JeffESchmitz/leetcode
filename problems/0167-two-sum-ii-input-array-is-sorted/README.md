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

## Idiom notes

### Swift
- **0-based search, 1-based boundary**: Array subscripting in Swift is 0-indexed. Converting indices to 1-based inside the loop creates off-by-one opportunities; converting only on the `return` statement (`[left + 1, right + 1]`) isolates the problem's idiosyncrasy to the exit boundary.
- **Exhaustive control flow**: The problem guarantees that exactly one valid solution exists, so the `while left < right` loop will always find the pair and return. Swift's compiler requires every execution path to return `[Int]`. Using `fatalError("...")` past the loop asserts this problem invariant and avoids returning dummy data.
