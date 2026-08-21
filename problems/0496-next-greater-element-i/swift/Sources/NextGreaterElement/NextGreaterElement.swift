public struct Solution {
    public init() {}

    /// For each value in `nums1`, the first value to its right in `nums2` that is
    /// strictly greater than it, or `-1` when no such value exists.
    ///
    /// `-1` is only unambiguous as "no answer" because the problem constrains all
    /// values to be non-negative. With negatives allowed it would collide with a
    /// legitimate result, so the search itself deals in `Optional` and the sentinel
    /// is applied once, here at the boundary.
    public func nextGreaterElement(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        let nextGreaterByValue = nextGreaterElements(of: nums2)
        return nums1.map { query in
            nextGreaterByValue[query] ?? -1
        }
    }

    /// Maps every value in `numbers` to the first larger value that follows it,
    /// omitting values that have no larger successor.
    ///
    /// One left-to-right pass. `pendingValues` holds the values still looking for a
    /// successor, and it is always descending: any value it contains is smaller than
    /// the ones beneath it, because a larger arrival would have resolved and removed
    /// them. So when `value` arrives it settles a run off the top — nearest waiter
    /// first — and whatever survives is too large for it and keeps waiting.
    ///
    /// Every element is appended once and removed at most once, which makes the pass
    /// O(n) amortized despite the inner loop. Relies on the problem's uniqueness
    /// guarantee: with duplicates, one key could not name a single position.
    private func nextGreaterElements(of numbers: [Int]) -> [Int: Int] {
        var nextGreaterByValue: [Int: Int] = [:]
        var pendingValues: [Int] = []

        for value in numbers {
            while let waiting = pendingValues.last, waiting < value {
                nextGreaterByValue[waiting] = value
                pendingValues.removeLast()
            }
            pendingValues.append(value)
        }

        // Whatever is left never found a larger successor, so it stays unmapped.
        return nextGreaterByValue
    }
}
