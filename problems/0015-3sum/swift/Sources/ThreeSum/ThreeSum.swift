/// LeetCode 15. 3Sum
/// https://leetcode.com/problems/3sum/
public struct Solution {
    public init() {}

    /// Returns every set of three numbers from different positions that sums
    /// to 0. Two triplets with the same values, in any order, count once.
    public func threeSum(_ nums: [Int]) -> [[Int]] {
        // PROMISES
        // - i, left, right are POSITIONS; duplicates are judged by VALUES.
        // - nums is NOT sorted, so sort a copy first. Safe: the answer is
        //   values, not positions, and O(n log n) is dwarfed by the O(n²) below.
        let nums = nums.sorted()
        var result: [[Int]] = []

        // Anchor one number (clamp it like a capo), then run 167's two
        // pointers on everything to its right.
        for i in 0..<nums.count {
            // Same anchor value as last time gives the same triplets. Sorting
            // put equal values side by side, so the previous slot is enough.
            if i > 0 && nums[i] == nums[i - 1] {
                continue
            }

            // Start after the anchor: never reuse its slot.
            var left = i + 1
            var right = nums.count - 1

            while left < right {
                let sum = nums[i] + nums[left] + nums[right]

                if sum == 0 {
                    result.append([nums[i], nums[left], nums[right]])

                    // Both values are used. Move each pointer past every copy
                    // of the value it just used (compare to the slot it left),
                    // or the next match repeats this triplet.
                    repeat {
                        left += 1
                    } while left < right && nums[left] == nums[left - 1]

                    repeat {
                        right -= 1
                    } while left < right && nums[right] == nums[right + 1]
                } else if sum < 0 {
                    // Too small. Sorted, so moving left rightward gives a
                    // larger or equal number; right is already the largest.
                    left += 1
                } else {
                    // Too big. Sorted, so moving right leftward gives a
                    // smaller or equal number; left is already the smallest.
                    right -= 1
                }
            }
        }

        return result
    }
}
