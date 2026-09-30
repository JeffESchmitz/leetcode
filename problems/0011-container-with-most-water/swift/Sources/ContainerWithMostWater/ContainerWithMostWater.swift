/// LeetCode 11. Container With Most Water
/// https://leetcode.com/problems/container-with-most-water/
public struct Solution {
    public init() {}

    public func maxArea(_ height: [Int]) -> Int {
        // SETUP: walls at both ends, nothing measured yet.
        // left and right are INDICES (positions), not heights.
        var left = 0
        var right = height.count - 1
        var maxWater = 0

        // LOOP: until the walls meet (a container needs two walls).
        while left < right {
            // STEP 1: Water spills over the shorter wall, so it sets the level.
            let waterLevel = min(height[left], height[right])

            // STEP 2: Width counts the gaps between the walls, not the walls:
            // nut to 8th fret is 8 fret spaces.
            let width = right - left

            // STEP 3: Water here is level × width. Keep it if it's the best so far.
            let currentWater = waterLevel * width
            maxWater = max(maxWater, currentWater)

            // STEP 4: The shorter wall is finished: every future partner is closer
            // (smaller width) and the level is still capped by this wall.
            // Moving the taller wall can't help, so move the shorter one's pointer.
            // On a tie both walls are finished, so the else is safe.
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }

        // RETURN: the best container seen.
        return maxWater
    }
}
