/// LeetCode 26. Remove Duplicates from Sorted Array
/// https://leetcode.com/problems/remove-duplicates-from-sorted-array/
public struct Solution {
    public init() {}

    /// Read/write two-pointer compaction, same skeleton as 283 (Move Zeroes).
    /// `read` visits every slot; `write` marks the next slot a unique value belongs in,
    /// advancing only when one is kept.
    public func removeDuplicates(_ nums: inout [Int]) -> Int {
        // nums.length >= 1 is guaranteed, so index 0 is always kept
        var write = 1

        for read in 1 ..< nums.count {
            // Keep nums[read] only if it differs from the last value written.
            if nums[read] != nums[write - 1] {
                nums[write] = nums[read]
                write += 1
            }
        }
        return write
    }
}
