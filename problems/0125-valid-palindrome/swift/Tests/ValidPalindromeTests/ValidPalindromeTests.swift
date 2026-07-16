import Testing
@testable import ValidPalindrome

@Suite
struct ValidPalindromeTests {
    @Test func example1() {
        // "amanaplanacanalpanama" is a palindrome.
        #expect(isPalindrome("A man, a plan, a canal: Panama") == true)
    }

    @Test func example2() {
        // "raceacar" is not a palindrome.
        #expect(isPalindrome("race a car") == false)
    }

    @Test func example3() {
        // Empty after removing non-alphanumerics -> palindrome.
        #expect(isPalindrome(" ") == true)
    }

    @Test func singleCharacter() {
        #expect(isPalindrome("a") == true)
    }

    @Test func onlyPunctuation() {
        #expect(isPalindrome(".,!?") == true)
    }

    @Test func mixedCase() {
        #expect(isPalindrome("Noon") == true)
        #expect(isPalindrome("AbBa") == true)
    }

    @Test func digitsCount() {
        #expect(isPalindrome("0P") == false)
        #expect(isPalindrome("121") == true)
        #expect(isPalindrome("1a2a1") == true)
    }

    @Test func almostPalindrome() {
        #expect(isPalindrome("abca") == false)
    }
}
