/// LeetCode 88. Merge Sorted Array
///
/// Merges the first `m` elements of `nums1` with the `n` elements of `nums2`,
/// storing the sorted result in `nums1`.
public struct Solution {
    public init() {}

    // GIVEN (what the inputs guarantee, so I don't check it):
    // 1. The first `m` values of `nums1` are sorted, non-decreasing (never goes down).
    // 2. All `n` values of `nums2` are sorted, non-decreasing.
    // 3. `nums1.count == m + n`: the last `n` slots of `nums1` are placeholders.
    //    Never read their values; only `m` says where the real data ends.
    // 4. `nums2.count == n`.
    //
    // MUST (what my code has to deliver):
    // - All `m + n` values end up in `nums1`, sorted non-decreasing.
    // - Done in place: no return value. Follow-up target is O(m + n) time.

    public func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        // 1. Three pointers, one per job (not one per array).
        // read1: the biggest unplaced value in nums1 (its last REAL value, not a placeholder).
        var read1 = m - 1
        // read2: the biggest unplaced value in nums2.
        var read2 = n - 1
        // write: the back of the bus, the seat the next winner goes into.
        var write = m + n - 1

        // 2. Loop while nums2 still has values to place.
        //    nums2 running out is the only stop: leftover nums1 values are already seated.
        while read2 >= 0 {
            // a. nums1 wins only if it still has values AND its value is bigger.
            //    Check read1 >= 0 first so nums1[-1] is never read.
            if read1 >= 0 && nums1[read1] > nums2[read2] {
                nums1[write] = nums1[read1]
                read1 -= 1
            } else {
                // b. nums2 wins: nums1 ran out, or nums2's value is bigger or equal.
                //    On a tie either side works; equal values are interchangeable.
                nums1[write] = nums2[read2]
                read2 -= 1
            }
            // c. The back of the bus moves one seat left after every placement.
            //    write never passes read1, so it only lands on values already copied.
            write -= 1
        }

        // 3. Done. When read2 hits -1, write == read1, so any nums1 values left
        //    already sit in their final seats, in sorted order (GIVEN #1).
    }
}
