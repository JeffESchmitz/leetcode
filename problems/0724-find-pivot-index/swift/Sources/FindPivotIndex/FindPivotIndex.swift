/// LeetCode 724. Find Pivot Index
/// https://leetcode.com/problems/find-pivot-index/
public struct Solution {
    public init() {}

    /// Leftmost index whose strictly-left sum equals its strictly-right sum,
    /// or -1 if none. O(n) time, O(1) space.
    ///
    /// A wall at `i` splits the array into three pieces — the wall element
    /// belongs to neither side, and an empty side sums to 0:
    ///
    ///     total = leftSum + nums[i] + rightSum      ← always true (identity)
    ///     leftSum == rightSum                       ← true only at a pivot (test)
    ///
    /// Rearranging the identity makes `rightSum` free, so the right side is
    /// never summed. No empty guard: `1 <= nums.length` is a promise.
    public func pivotIndex(_ nums: [Int]) -> Int {
        let total = nums.reduce(0, +)
        var leftSum = 0

        for (i, value) in nums.enumerated() {
            // Subtracting `value` keeps the wall element out of the right side.
            let rightSum = total - leftSum - value

            // First match wins: the problem wants the *leftmost* pivot.
            if leftSum == rightSum { return i }

            // `value` is left of the *next* wall, not this one.
            leftSum += value
        }

        return -1
    }
}
