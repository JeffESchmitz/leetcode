/// LeetCode 42. Trapping Rain Water
/// https://leetcode.com/problems/trapping-rain-water/
public struct Solution {
    public init() {}

    // PROMISE Pin 1: `height` array will never be empty
    // PROMISE Pin 2: none of the "bar" are negative

    /// Two strips: for every column, the tallest bar on its left and on its
    /// right (the bar counts itself). depth = min(tallestLeft, tallestRight) - height.
    /// O(n) time, O(n) extra space: trades memory for speed.
    public func trap(_ height: [Int]) -> Int {
        // SETUP: i is a COLUMN (position); height[i] is that column's BAR.
        let count = height.count
        var tallestLeft = Array(repeating: 0, count: count)
        var tallestRight = Array(repeating: 0, count: count)

        // WALK 1: left to right. The ratchet only clicks up, never down,
        // so each slot holds the tallest bar from column 0 through here.
        // Pin 1 makes height[0] safe to read.
        tallestLeft[0] = height[0]
        for i in 1..<count {
            tallestLeft[i] = max(tallestLeft[i - 1], height[i])
        }

        // WALK 2: right to left. Same ratchet from the other end:
        // the tallest bar from here through the last column.
        tallestRight[count - 1] = height[count - 1]
        for i in stride(from: count - 2, through: 0, by: -1) {
            tallestRight[i] = max(tallestRight[i + 1], height[i])
        }

        // WALK 3: every column. Water spills over the shorter of the two
        // tallest walls, so that sets the level; the bar is the floor.
        // Both strips include the bar itself, so depth is never negative.
        var totalWater = 0
        for i in 0..<count {
            let level = min(tallestLeft[i], tallestRight[i])
            let depth = level - height[i]
            totalWater += depth
        }

        // RETURN: the sum of every column's depth.
        return totalWater
    }
}
