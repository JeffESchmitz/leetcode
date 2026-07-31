import Testing
@testable import PalindromeNumber

@Suite("Palindrome Number")
struct PalindromeNumberTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        #expect(solution.isPalindrome(121) == true)
    }

    @Test("example 2")
    func example2() {
        #expect(solution.isPalindrome(-121) == false)
    }

    @Test("example 3")
    func example3() {
        #expect(solution.isPalindrome(10) == false)
    }

    @Test("zero")
    func zero() {
        #expect(solution.isPalindrome(0) == true)
    }

    @Test("single digit")
    func singleDigit() {
        #expect(solution.isPalindrome(7) == true)
    }

    @Test("trailing zeros")
    func trailingZeros() {
        #expect(solution.isPalindrome(100) == false)
    }

    @Test("larger palindrome")
    func largerPalindrome() {
        #expect(solution.isPalindrome(12321) == true)
    }

    @Test("larger non-palindrome")
    func largerNonPalindrome() {
        #expect(solution.isPalindrome(12345) == false)
    }

    @Test("10-digit palindrome")
    func tenDigitPalindrome() {
        #expect(solution.isPalindrome(1_234_554_321) == true)
    }

    @Test("10-digit non-palindrome")
    func tenDigitNonPalindrome() {
        #expect(solution.isPalindrome(1_234_567_890) == false)
    }

    @Test("10-digit near Int32 max palindrome")
    func tenDigitNearInt32MaxPalindrome() {
        #expect(solution.isPalindrome(2_147_447_412) == true)
    }
}
