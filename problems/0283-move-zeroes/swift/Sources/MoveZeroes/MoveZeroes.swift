/// LeetCode 283. Move Zeroes
/// https://leetcode.com/problems/move-zeroes/
public struct Solution {
    public init() {}

    /// Read/write two-pointer compaction. `readIndex` visits every slot;
    /// `writeIndex` marks the next slot a non-zero belongs in and only advances
    /// when one is placed. Full derivation in README.
    public func moveZeroes(_ nums: inout [Int]) {
        var writeIndex = 0

        for readIndex in nums.indices {
            guard nums[readIndex] != 0 else { continue }

            // Until the first zero is passed the two indices are equal and the
            // swap would be a no-op; skipping it is the follow-up's "minimize
            // operations".
            if readIndex != writeIndex {
                nums.swapAt(readIndex, writeIndex)
            }
            writeIndex += 1
        }
    }
}
