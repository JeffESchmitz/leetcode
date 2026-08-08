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
        // Never read: votes == 0 forces adoption on iteration 1.
        var candidate = 0
        // Surplus of standing `candidate` copies — not a count of occurrences.
        var votes = 0

        for num in nums {
            // "votes == 0": the field is empty... 
            // Which means, the prefix annihilated in unequal pairs, which never changes the majority. 
            // Whoever shows up now takes the field. 
            // A wrong value can't hold it to the end.
            if votes == 0 {
                // new candidate: the field is empty, so this one takes it
                candidate = num
                votes = 1
            } else if num == candidate {
                // Reinforcement: one more copy standing.
                votes += 1
            } else {
                // Unequal pair — mutual annihilation, one-for-one.
                votes -= 1
            }
        }

        return candidate // last value standing
    }
}
