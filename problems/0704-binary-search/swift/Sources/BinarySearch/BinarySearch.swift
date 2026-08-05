public struct Solution {
    public init() {}

    /// Returns the index of `target` in `nums`, or `-1` if it is not present.
    ///
    /// Iterative binary search over a moving window `low...high`. The window is the
    /// only state — the array is never sliced or copied, so an index found is
    /// already the caller's index. O(log n) time, O(1) space.
    ///
    /// - Precondition: `nums` is sorted in ascending order. This is load-bearing —
    ///   on unsorted input the search discards the half holding the target and
    ///   confidently returns `-1`. It is deliberately not checked: verifying
    ///   sortedness costs O(n) and would blow the very budget this algorithm exists
    ///   to meet.
    /// - Note: Uniqueness of the elements is what makes returning `mid` on sight
    ///   correct. With duplicates, a jumping search lands on an arbitrary match and
    ///   would need a further pass to honor a "first index" tiebreak.
    public func search(_ nums: [Int], _ target: Int) -> Int {
        var low = 0
        var high = nums.count - 1

        while low <= high {
            let mid = low + (high - low) / 2

            switch nums[mid] {
            case target:
                return mid
            case ..<target:
                low = mid + 1
            default:
                high = mid - 1
            }
        }

        return -1
    }
}
