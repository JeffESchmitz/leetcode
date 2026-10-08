// Promise: nums is sorted in non-decreasing order; equal values are consecutive.
// Promise: nums has at least one element (the empty guard is extra coverage).
// Requirement: modify nums in place using O(1) extra space.
public struct Solution {
    public init() {}

    public func removeDuplicates(_ nums: inout [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }

        // first element is always kept; start writing at index 1
        var write = 1

        for read in 1..<nums.count {
            // keep the candidate if:
            // 1. write < 2.
            // OR
            // 2. nums[read] differs from nums[write - 2]
            if write < 2 || nums[read] != nums[write - 2] {
                // When keeping it,
                // copy nums[read] into nums[write]
                // increase write by 1 (++)
                nums[write] = nums[read]
                write += 1
            }
        }
        return write
    }
}
