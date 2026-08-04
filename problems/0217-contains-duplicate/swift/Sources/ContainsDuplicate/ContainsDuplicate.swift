/// LeetCode 217. Contains Duplicate
/// https://leetcode.com/problems/contains-duplicate/
///
/// Given an integer array `nums`, return `true` if any value appears at least twice in the array,
/// and return `false` if every element is distinct.
public struct Solution {
    public init() {}

    /// O(n) time, O(n) space: single-pass membership scan.
    ///
    /// Trades the sort for remembered state. `insert` reports whether the value was
    /// new, so a single hash lookup both asks "seen this before?" and records the
    /// answer — no separate `contains` call. Needs no empty guard: an empty array
    /// simply never enters the loop.
    public func containsDuplicate(_ nums: [Int]) -> Bool {
        // Sized up front so a growing Set never rehashes mid-scan.
        var seen = Set<Int>(minimumCapacity: nums.count)

        for num in nums {
            if !seen.insert(num).inserted {
                return true
            }
        }
        return false
    }
}
