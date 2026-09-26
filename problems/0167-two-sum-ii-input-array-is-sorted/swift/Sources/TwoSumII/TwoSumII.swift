/// LeetCode 167. Two Sum II - Input Array Is Sorted
/// https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/
public struct Solution {
    public init() {}

    /// Returns the **1-indexed** positions of the two values in `numbers` that
    /// sum to `target`, as `[index1, index2]` with `index1 < index2`.
    public func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
        var left = 0
        var right = numbers.count - 1
        while left < right {
            let sum = numbers[left] + numbers[right]
            if sum == target {
                // Found it. left/right are 0-based Swift indices — that's
                // what array subscripting needs while we search. But the
                // problem wants 1-based positions ("added by one"), so the
                // conversion happens here, on the way out, not during the search.
                return [left + 1, right + 1]
            } else if sum < target {
                // sum is too small. right already points at the largest
                // value still in play, so numbers[left] paired with anything
                // up to numbers[right] can't reach target either — left can
                // never be part of a valid pair now. Drop it, move inward.
                left += 1
            } else {
                // sum is too big. left already points at the smallest value
                // still in play, so numbers[right] paired with anything down
                // to numbers[left] can't reach target either — right can
                // never be part of a valid pair now. Drop it, move inward.
                right -= 1
            }
        }
        // Unreachable per the problem's constraint: "exactly one solution
        // exists" guarantees the loop above always returns before left and
        // right meet. Swift still requires every path to return.
        fatalError("No solution found, but the problem guarantees exactly one solution.")
    }
}
