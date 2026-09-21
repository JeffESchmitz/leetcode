import Testing
@testable import TwoSumII

@Suite("Two Sum II - Input Array Is Sorted")
struct TwoSumIITests {
    private let solution = Solution()

    @Test("example 1: [2,7,11,15], target = 9")
    func example1() {
        #expect(solution.twoSum([2, 7, 11, 15], 9) == [1, 2])
    }

    @Test("example 2: [2,3,4], target = 6 — the pair straddles the middle")
    func example2() {
        #expect(solution.twoSum([2, 3, 4], 6) == [1, 3])
    }

    @Test("example 3: [-1,0], target = -1 — negatives, smallest legal input")
    func example3() {
        #expect(solution.twoSum([-1, 0], -1) == [1, 2])
    }

    @Test("the answer is the first two elements")
    func pairAtTheFront() {
        #expect(solution.twoSum([1, 2, 9, 20, 50], 3) == [1, 2])
    }

    @Test("the answer is the last two elements")
    func pairAtTheBack() {
        #expect(solution.twoSum([1, 2, 9, 20, 50], 70) == [4, 5])
    }

    @Test("the answer is the two outermost elements")
    func pairAtBothEnds() {
        #expect(solution.twoSum([1, 2, 9, 20, 50], 51) == [1, 5])
    }

    @Test("duplicate values: the two equal elements are the pair")
    func duplicatesFormThePair() {
        #expect(solution.twoSum([1, 3, 3, 7], 6) == [2, 3])
    }

    @Test("duplicates elsewhere must not be mistaken for the pair")
    func duplicatesAreNotThePair() {
        #expect(solution.twoSum([2, 2, 5, 9], 14) == [3, 4])
    }

    @Test("all negative values")
    func allNegative() {
        #expect(solution.twoSum([-9, -7, -4, -1], -11) == [2, 3])
    }

    @Test("target is zero, spanning the sign change")
    func targetZeroAcrossSigns() {
        #expect(solution.twoSum([-5, -2, 0, 2, 6], 0) == [2, 4])
    }

    @Test("a zero is one half of the pair")
    func zeroIsHalfThePair() {
        #expect(solution.twoSum([-4, 0, 3], 3) == [2, 3])
    }

    @Test("value bounds: the -1000 and 1000 extremes")
    func valueBounds() {
        #expect(solution.twoSum([-1000, -999, 999, 1000], 1) == [2, 4])
    }

    @Test("upper bound: 3*10^4 elements, pair at the far end")
    func upperBoundManyElements() {
        var numbers = Array(repeating: -1000, count: 29_998)
        numbers.append(contentsOf: [999, 1000])
        #expect(solution.twoSum(numbers, 1999) == [29_999, 30_000])
    }

    @Test("upper bound: 3*10^4 elements, pair at the very front")
    func upperBoundPairAtFront() {
        var numbers = [-1000, -999]
        numbers.append(contentsOf: Array(repeating: 1000, count: 29_998))
        #expect(solution.twoSum(numbers, -1999) == [1, 2])
    }
}
