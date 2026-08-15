/// LeetCode 202. Happy Number
///
/// Returns whether the integer `n` is a happy number.
public struct Solution {
    public init() {}

    public func isHappy(_ n: Int) -> Bool {
        var current = n
        var seen = Set<Int>()

        while current != 1 {
            if !seen.insert(current).inserted {
                return false
            }
            current = sumOfSquaredDigits(current)
        }
        return true
    }

    private func sumOfSquaredDigits(_ n: Int) -> Int {
        var value = n
        var sum = 0
        while value > 0 {
            let digit = value % 10
            sum += digit * digit
            value /= 10
        }
        return sum
    }
}
