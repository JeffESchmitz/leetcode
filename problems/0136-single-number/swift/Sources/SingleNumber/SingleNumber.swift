/// LeetCode 136. Single Number
/// https://leetcode.com/problems/single-number/
public struct Solution {
    public init() {}

    /// XOR is self-cancelling (`a ^ a == 0`) and order-independent, so folding every
    /// value together leaves only the one with no matching pair. Full derivation in README.
    public func singleNumber(_ nums: [Int]) -> Int {
        nums.reduce(0, ^)
    }
}
