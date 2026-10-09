// Promise: nums is sorted in non-decreasing order; equal values are consecutive.
// Promise: nums has at least one element; the reduction also handles empty input.
// Requirement: modify nums in place using O(1) extra space.
public struct Solution {
    public init() {}

    public func removeDuplicates(_ nums: inout [Int]) -> Int {
        // write is the next keeper slot, also the number of values kept so far
        nums.indices.reduce(into: 0) { write, read in
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
    }
}
