/// LeetCode 643. Maximum Average Subarray I
/// https://leetcode.com/problems/maximum-average-subarray-i/
public struct Solution {
    public init() {}

    /// Fixed-size sliding window. Consecutive windows share `k - 1` elements, so
    /// each slide is one subtraction and one addition instead of a fresh `O(k)`
    /// sum. Full derivation in README.
    public func findMaxAverage(_ nums: [Int], _ k: Int) -> Double {
        // Seed the first window, indices 0..<k. `k <= n` promises it exists, so
        // maxSum can start from a real value rather than 0 — which would beat
        // every window in an all-negative array.
        var windowSum = nums[0..<k].reduce(0, +)
        var maxSum = windowSum

        // `index` is the right edge: the element entering. The one leaving sat
        // `k` slots back, at `index - k`.
        for index in k..<nums.count {
            windowSum += nums[index] - nums[index - k]
            maxSum = max(maxSum, windowSum)
        }

        // Accumulate in exact Int arithmetic; convert once, at the boundary.
        // `windowSum / k` here would truncate and silently lose the fraction.
        return Double(maxSum) / Double(k)
    }
}
