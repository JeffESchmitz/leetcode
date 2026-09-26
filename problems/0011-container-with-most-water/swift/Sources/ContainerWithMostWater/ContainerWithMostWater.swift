/// LeetCode 11. Container With Most Water
/// https://leetcode.com/problems/container-with-most-water/
public struct Solution {
    public init() {}

    /// Returns the most water any two lines can hold:
    /// (shorter height) × (distance between their indices), maximized.
    public func maxArea(_ height: [Int]) -> Int {
        // left and right are INDICES (positions of the walls), not heights.
        var left = 0
        var right = height.count - 1
        var maxWater = 0

        while left < right {
            // Width counts the gaps between the walls, not the walls:
            // nut to 8th fret is 8 fret spaces.
            let width = right - left
            // Water spills over the shorter wall.
            let waterHeight = min(height[left], height[right])
            let water = waterHeight * width
            maxWater = max(maxWater, water)

            // The shorter wall is finished: every future partner is closer
            // (smaller width) and the water is still capped by this wall.
            // On a tie both walls are finished, so the else is safe.
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }

        return maxWater
    }
}
