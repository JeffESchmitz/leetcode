/// LeetCode 9. Palindrome Number
///
/// Returns whether an integer `number` is a palindrome.
public struct Solution {
    public init() {}

    public func isPalindrome(_ number: Int) -> Bool {
        // Negative numbers are not palindromes
        guard number >= 0 else { return false }

        // Numbers ending in 0 (except 0 itself) cannot be palindromes
        guard number == 0 || number % 10 != 0 else { return false }

        var reversedNumber = 0
        var remainingDigits = number

        while remainingDigits > 0 {
            reversedNumber = (reversedNumber * 10) + (remainingDigits % 10)
            remainingDigits /= 10
        }

        return number == reversedNumber
    }
}
