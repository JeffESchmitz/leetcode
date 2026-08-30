import Testing
@testable import LastStoneWeight

@Suite("Last Stone Weight")
struct LastStoneWeightTests {
    private let solution = Solution()

    @Test("example 1: [2,7,4,1,8,1]")
    func example1() {
        #expect(solution.lastStoneWeight([2, 7, 4, 1, 8, 1]) == 1)
    }

    @Test("example 2: single stone [1]")
    func example2() {
        #expect(solution.lastStoneWeight([1]) == 1)
    }

    @Test("two equal stones fully destroy each other")
    func twoEqual() {
        #expect(solution.lastStoneWeight([3, 3]) == 0)
    }

    @Test("two distinct stones leave the difference")
    func twoDistinct() {
        #expect(solution.lastStoneWeight([5, 2]) == 3)
    }

    @Test("all identical, even count: everything cancels")
    func allIdenticalEvenCount() {
        #expect(solution.lastStoneWeight([4, 4, 4, 4]) == 0)
    }

    @Test("all identical, odd count: one survives")
    func allIdenticalOddCount() {
        #expect(solution.lastStoneWeight([4, 4, 4]) == 4)
    }

    @Test("input not pre-sorted: heaviest two aren't at the ends")
    func unsortedInput() {
        #expect(solution.lastStoneWeight([1, 3, 2]) == 0)
    }

    @Test("duplicate maximums destroy each other first")
    func duplicateMaximums() {
        #expect(solution.lastStoneWeight([10, 4, 2, 10]) == 2)
    }

    @Test("single large-value stone: untouched")
    func singleLargeStone() {
        #expect(solution.lastStoneWeight([1000]) == 1000)
    }

    @Test("upper bound: 30 identical max-weight stones pair off completely")
    func upperBound() {
        let stones = Array(repeating: 1000, count: 30)
        #expect(solution.lastStoneWeight(stones) == 0)
    }
}
