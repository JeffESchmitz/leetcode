import Testing
@testable import ReverseWords

@Suite("Reverse Words in a String")
struct ReverseWordsTests {
    private let solution = Solution()

    @Test("example 1: reverse word order")
    func example1() {
        #expect(solution.reverseWords("the sky is blue") == "blue is sky the")
    }

    @Test("example 2: trim spaces at both ends")
    func example2() {
        #expect(solution.reverseWords("  hello world  ") == "world hello")
    }

    @Test("example 3: reduce spaces between words")
    func example3() {
        #expect(solution.reverseWords("a good   example") == "example good a")
    }

    @Test("single character")
    func singleCharacter() {
        #expect(solution.reverseWords("a") == "a")
    }

    @Test("single word keeps its internal character order")
    func singleWord() {
        #expect(solution.reverseWords("   Swift   ") == "Swift")
    }

    @Test("letters and digits retain their case and order")
    func lettersAndDigits() {
        #expect(solution.reverseWords("iOS 26 Swift6") == "Swift6 26 iOS")
    }

    @Test("mixed padding and long separators")
    func mixedSpaces() {
        #expect(solution.reverseWords("   one    two  three ") == "three two one")
    }

    @Test("repeated words are preserved")
    func repeatedWords() {
        #expect(solution.reverseWords("go go Swift go") == "go Swift go go")
    }

    @Test("10,000-character input with asymmetric words and padding")
    func upperBound() {
        let input = " " + String(repeating: "a ", count: 4_998) + "xyz"
        let expected = "xyz " + Array(repeating: "a", count: 4_998).joined(separator: " ")
        #expect(solution.reverseWords(input) == expected)
    }
}
