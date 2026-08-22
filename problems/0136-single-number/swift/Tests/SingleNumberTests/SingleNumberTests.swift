import Testing
@testable import SingleNumber

@Suite("Single Number")
struct SingleNumberTests {
    private let solution = Solution()

    @Test("example 1: [2,2,1]")
    func example1() {
        #expect(solution.singleNumber([2, 2, 1]) == 1)
    }

    @Test("example 2: [4,1,2,1,2]")
    func example2() {
        #expect(solution.singleNumber([4, 1, 2, 1, 2]) == 4)
    }

    @Test("example 3: single element")
    func example3() {
        #expect(solution.singleNumber([1]) == 1)
    }

    @Test("negative values")
    func negativeValues() {
        #expect(solution.singleNumber([-1, -1, -2]) == -2)
    }

    @Test("zero is a legal value, including as the answer")
    func zeroIsALegalValue() {
        #expect(solution.singleNumber([0, 1, 0]) == 1)
        #expect(solution.singleNumber([1, 1, 0]) == 0)
    }

    @Test("mixed positive and negative pairs")
    func mixedPositiveAndNegativePairs() {
        #expect(solution.singleNumber([5, -5, 5, 7, -5]) == 7)
    }

    @Test("the single value sits first, not last")
    func singleValueLeadsTheArray() {
        #expect(solution.singleNumber([9, 3, 3]) == 9)
    }

    @Test("upper bound: 14,999 pairs plus one single value")
    func upperBoundManyPairs() {
        let pairs = Array(1...14_999)
        let nums = pairs + pairs + [30_000]
        #expect(solution.singleNumber(nums) == 30_000)
    }
}
