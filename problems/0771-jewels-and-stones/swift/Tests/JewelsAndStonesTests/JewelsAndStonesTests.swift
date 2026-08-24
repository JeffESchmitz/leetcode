import Testing
@testable import JewelsAndStones

@Suite("Jewels and Stones")
struct JewelsAndStonesTests {
    private let solution = Solution()

    @Test("example 1: jewels = \"aA\", stones = \"aAAbbbb\"")
    func example1() {
        #expect(solution.numJewelsInStones("aA", "aAAbbbb") == 3)
    }

    @Test("example 2: case sensitivity means \"z\" never matches \"ZZ\"")
    func example2() {
        #expect(solution.numJewelsInStones("z", "ZZ") == 0)
    }

    @Test("no stone is a jewel")
    func noMatches() {
        #expect(solution.numJewelsInStones("xyz", "abcabc") == 0)
    }

    @Test("every stone is a jewel")
    func allMatch() {
        #expect(solution.numJewelsInStones("abc", "cbacba") == 6)
    }

    @Test("single jewel, single stone, matching")
    func singleMatch() {
        #expect(solution.numJewelsInStones("a", "a") == 1)
    }

    @Test("both cases of a letter are jewels")
    func bothCasesAreJewels() {
        #expect(solution.numJewelsInStones("aA", "aAaA") == 4)
    }

    @Test("repeated stones of one jewel type all count")
    func repeatedStonesCount() {
        #expect(solution.numJewelsInStones("a", "aaaaa") == 5)
    }

    @Test("jewels not present among the stones contribute nothing")
    func unusedJewels() {
        #expect(solution.numJewelsInStones("abcdefg", "aab") == 3)
    }

    @Test("upper bound: 50 jewels, 50 stones")
    func upperBound() {
        let jewels = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWX"
        let stones = String(repeating: "az", count: 25)
        #expect(solution.numJewelsInStones(jewels, stones) == 50)
    }
}
