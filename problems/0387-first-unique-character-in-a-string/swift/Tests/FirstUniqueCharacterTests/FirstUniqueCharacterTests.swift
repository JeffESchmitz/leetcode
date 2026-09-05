import Testing
@testable import FirstUniqueCharacter

@Suite("First Unique Character in a String")
struct FirstUniqueCharacterTests {
    private let solution = Solution()

    @Test("example 1: first character is already unique")
    func example1() {
        #expect(solution.firstUniqChar("leetcode") == 0)
    }

    @Test("example 2: unique character appears after repeats")
    func example2() {
        #expect(solution.firstUniqChar("loveleetcode") == 2)
    }

    @Test("example 3: every character repeats")
    func example3() {
        #expect(solution.firstUniqChar("aabb") == -1)
    }

    @Test("single character is trivially unique")
    func singleCharacter() {
        #expect(solution.firstUniqChar("z") == 0)
    }

    @Test("all characters identical")
    func allSame() {
        #expect(solution.firstUniqChar("aaaa") == -1)
    }

    @Test("unique character is the last one")
    func uniqueAtEnd() {
        #expect(solution.firstUniqChar("aabbc") == 4)
    }

    @Test("first occurrence wins even when a later character is also unique")
    func earliestUniqueWins() {
        #expect(solution.firstUniqChar("abcabd") == 2)
    }

    @Test("a character repeating far apart is still not unique")
    func repeatFarApart() {
        #expect(solution.firstUniqChar("abcdefga") == 1)
    }
}
