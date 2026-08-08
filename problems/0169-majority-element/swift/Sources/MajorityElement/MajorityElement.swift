/// LeetCode 169. Majority Element
/// https://leetcode.com/problems/majority-element/
public struct Solution {
    public init() {}

    /// Boyer–Moore majority vote — one pass, O(n) time, O(1) space.
    ///
    /// The one idea: deleting two elements of *different* values never changes
    /// which value is the majority — a pair holds at most one copy of it, and
    /// `2a > n` implies `2(a−1) > n−2`. Cancel unequal pairs until one value is
    /// left standing; the majority can't be wiped out (it outnumbers everyone
    /// else combined), so the survivor must be it.
    ///
    /// `votes` is a *surplus*, not a count: copies of `candidate` still unmatched.
    /// The candidate may be wrong mid-pass — the state is a summary, not an
    /// answer, and means something only after the last element. Correctness
    /// spends the "majority exists" guarantee exactly once, at the end; without
    /// it this returns whatever survived and a verify pass would be required.
    public func majorityElement(_ nums: [Int]) -> Int {
        var candidate = 0 // never read: votes == 0 forces adoption on iteration 1
        var votes = 0     // surplus of standing `candidate` copies

        for num in nums {
            if votes == 0 {
                // No standing opinion — everything so far cancelled in pairs,
                // so adopting the newcomer costs nothing.
                candidate = num
                votes = 1
            } else if num == candidate {
                votes += 1 // reinforcement: one more copy standing
            } else {
                votes -= 1 // unequal pair — mutual annihilation, one-for-one
            }
        }

        return candidate // last value standing
    }
}
