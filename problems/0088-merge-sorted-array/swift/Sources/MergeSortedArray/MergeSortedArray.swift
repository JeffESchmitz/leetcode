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
        fatalError("merge is not yet implemented")
    }
}
