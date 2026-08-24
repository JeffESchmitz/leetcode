/// LeetCode 1979. Find Greatest Common Divisor of Array
/// https://leetcode.com/problems/find-greatest-common-divisor-of-array/
public struct Solution {
    public init() {}

    /// The array is a decoy: only `min` and `max` matter, so two scans reduce the
    /// problem to a two-number GCD. Full derivation in README.
    public func findGCD(_ nums: [Int]) -> Int {
        // `2 <= nums.length` is promised, so the array is never empty and the
        // force-unwraps cannot trap.
        gcd(nums.min()!, nums.max()!)
    }

    /// Euclid: gcd(a, b) == gcd(b, a % b), because any common divisor of `a` and
    /// `b` also divides their remainder. `b == 0` is the base case — everything
    /// divides 0, so the answer is whatever `a` has become.
    private func gcd(_ a: Int, _ b: Int) -> Int {
        b == 0 ? a : gcd(b, a % b)
    }
}
