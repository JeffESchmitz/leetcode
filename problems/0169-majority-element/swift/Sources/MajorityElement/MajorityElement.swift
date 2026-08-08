/// LeetCode 169. Majority Element
/// https://leetcode.com/problems/majority-element/
public struct Solution {
    public init() {}

    /// Boyer–Moore majority vote — one pass, O(n) time, O(1) space.
    ///
    /// Deleting two elements of *different* values never changes the majority,
    /// so cancel unequal pairs until one value survives — the majority can't be
    /// wiped out, since it outnumbers everyone else combined.
    ///
    /// `votes` is a surplus, not a count. The candidate may be wrong mid-pass;
    /// only the final state means anything. Requires the "majority exists"
    /// guarantee — without it, the survivor would need a verify pass.
    public func majorityElement(_ nums: [Int]) -> Int {
        // A fold: (candidate, votes) is a summary carried across the sequence and
        // read only at the end — which is what reduce(into:) says out loud, and
        // what a `for` loop leaves implicit. The seed candidate is never read:
        // votes == 0 forces adoption on the first element.
        nums.reduce(into: (candidate: 0, votes: 0)) { field, num in
            // "votes == 0": the field is empty...
            // Which means, the prefix annihilated in unequal pairs, which never changes the majority.
            // Whoever shows up now takes the field.
            // A wrong value can't hold it to the end.
            if field.votes == 0 {
                // new candidate: the field is empty, so this one takes it
                field = (candidate: num, votes: 1)
            } else {
                // Match reinforces; mismatch annihilates one-for-one.
                field.votes += num == field.candidate ? 1 : -1
            }
        }
        // Last value standing.
        .candidate
    }
}
