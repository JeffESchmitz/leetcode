import Testing
@testable import RomanToInteger

@Suite("Roman to Integer")
struct RomanToIntegerTests {
    private let solution = Solution()

    @Test("example 1: III")
    func example1() {
        #expect(solution.romanToInt("III") == 3)
    }

    @Test("example 2: LVIII")
    func example2() {
        #expect(solution.romanToInt("LVIII") == 58)
    }

    @Test("example 3: MCMXCIV")
    func example3() {
        #expect(solution.romanToInt("MCMXCIV") == 1994)
    }

    @Test("single symbol")
    func singleSymbol() {
        #expect(solution.romanToInt("V") == 5)
    }

    @Test("smallest value")
    func smallestValue() {
        #expect(solution.romanToInt("I") == 1)
    }

    @Test("all six subtractive pairs")
    func subtractivePairs() {
        #expect(solution.romanToInt("IV") == 4)
        #expect(solution.romanToInt("IX") == 9)
        #expect(solution.romanToInt("XL") == 40)
        #expect(solution.romanToInt("XC") == 90)
        #expect(solution.romanToInt("CD") == 400)
        #expect(solution.romanToInt("CM") == 900)
    }

    @Test("subtractive pair at the end")
    func subtractiveAtEnd() {
        #expect(solution.romanToInt("XXIV") == 24)
    }

    @Test("maximum value")
    func maximumValue() {
        #expect(solution.romanToInt("MMMCMXCIX") == 3999)
    }

    @Test("no subtractive pairs, descending")
    func descendingOnly() {
        #expect(solution.romanToInt("MDCLXVI") == 1666)
    }
}
