import Testing
@testable import FindGreatestCommonDivisorOfArray

@Suite("Find Greatest Common Divisor of Array")
struct FindGreatestCommonDivisorOfArrayTests {
    private let solution = Solution()

    @Test("example 1: [2,5,6,9,10] → gcd(2,10)")
    func example1() {
        #expect(solution.findGCD([2, 5, 6, 9, 10]) == 2)
    }

    @Test("example 2: [7,5,6,8,3] → gcd(3,8), coprime")
    func example2() {
        #expect(solution.findGCD([7, 5, 6, 8, 3]) == 1)
    }

    @Test("example 3: [3,3] → min and max are the same value")
    func example3() {
        #expect(solution.findGCD([3, 3]) == 3)
    }

    @Test("all elements identical")
    func allSame() {
        #expect(solution.findGCD([7, 7, 7, 7]) == 7)
    }

    @Test("coprime min and max, neither at an end of the array")
    func coprimeMinMax() {
        #expect(solution.findGCD([4, 9, 5, 7]) == 1)
    }

    @Test("max is a multiple of min")
    func maxIsMultipleOfMin() {
        #expect(solution.findGCD([6, 7, 9, 12, 18]) == 6)
    }

    @Test("min is 1: forces the answer to 1 regardless of max")
    func minOfOne() {
        #expect(solution.findGCD([1, 1000, 500]) == 1)
    }

    @Test("min and max at the array's two ends")
    func minAndMaxAtEnds() {
        #expect(solution.findGCD([4, 7, 9, 11, 20]) == 4)
    }

    @Test("two elements, the smallest legal array")
    func twoElements() {
        #expect(solution.findGCD([12, 18]) == 6)
    }

    @Test("upper bound: values at the 1000 ceiling")
    func upperBoundValues() {
        #expect(solution.findGCD([1000, 750, 999]) == 250)
    }
}
