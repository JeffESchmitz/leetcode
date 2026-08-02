import Testing
@testable import ValidAnagram

@Suite("Valid Anagram")
struct ValidAnagramTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        #expect(solution.isAnagram("anagram", "nagaram") == true)
    }

    @Test("example 2")
    func example2() {
        #expect(solution.isAnagram("rat", "car") == false)
    }

    @Test("different lengths")
    func differentLengths() {
        #expect(solution.isAnagram("a", "ab") == false)
        #expect(solution.isAnagram("ab", "a") == false)
    }

    @Test("single character match")
    func singleCharacterMatch() {
        #expect(solution.isAnagram("a", "a") == true)
    }

    @Test("single character mismatch")
    func singleCharacterMismatch() {
        #expect(solution.isAnagram("a", "b") == false)
    }

    @Test("identical strings")
    func identicalStrings() {
        #expect(solution.isAnagram("listen", "listen") == true)
    }

    @Test("same letters, different counts")
    func sameLettersDifferentCounts() {
        // Same distinct letters, so a set-based check would wrongly say true.
        #expect(solution.isAnagram("aacc", "ccac") == false)
    }

    @Test("all same character")
    func allSameCharacter() {
        #expect(solution.isAnagram("aaaa", "aaaa") == true)
        #expect(solution.isAnagram("aaaa", "aaab") == false)
    }

    @Test("full alphabet shuffled")
    func fullAlphabetShuffled() {
        #expect(solution.isAnagram("abcdefghijklmnopqrstuvwxyz",
                                   "zyxwvutsrqponmlkjihgfedcba") == true)
    }

    @Test("one letter swapped out")
    func oneLetterSwappedOut() {
        #expect(solution.isAnagram("anagram", "nagarax") == false)
    }
}
