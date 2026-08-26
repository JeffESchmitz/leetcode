import Testing
@testable import MoveZeroes

@Suite("Move Zeroes")
struct MoveZeroesTests {
    private let solution = Solution()

    /// Runs the in-place mutation and hands back the mutated array.
    private func moved(_ input: [Int]) -> [Int] {
        var nums = input
        solution.moveZeroes(&nums)
        return nums
    }

    @Test("example 1: [0,1,0,3,12]")
    func example1() {
        #expect(moved([0, 1, 0, 3, 12]) == [1, 3, 12, 0, 0])
    }

    @Test("example 2: single zero")
    func example2() {
        #expect(moved([0]) == [0])
    }

    @Test("single non-zero element is untouched")
    func singleNonZero() {
        #expect(moved([5]) == [5])
    }

    @Test("no zeros: array is unchanged")
    func noZeros() {
        #expect(moved([1, 2, 3, 4]) == [1, 2, 3, 4])
    }

    @Test("all zeros: array is unchanged")
    func allZeros() {
        #expect(moved([0, 0, 0]) == [0, 0, 0])
    }

    @Test("zeros already at the end: nothing moves")
    func zerosAlreadyAtEnd() {
        #expect(moved([1, 2, 0, 0]) == [1, 2, 0, 0])
    }

    @Test("zeros at the front: every non-zero shifts left")
    func zerosAtFront() {
        #expect(moved([0, 0, 1, 2]) == [1, 2, 0, 0])
    }

    @Test("relative order of non-zeros is preserved, not sorted")
    func relativeOrderPreserved() {
        #expect(moved([4, 0, 3, 0, 2, 0, 1]) == [4, 3, 2, 1, 0, 0, 0])
    }

    @Test("negatives are non-zero and keep their order")
    func negatives() {
        #expect(moved([0, -1, 0, -2, 3]) == [-1, -2, 3, 0, 0])
    }

    @Test("consecutive zeros in the middle")
    func consecutiveZerosInMiddle() {
        #expect(moved([1, 0, 0, 0, 2]) == [1, 2, 0, 0, 0])
    }

    @Test("value bounds: Int32 extremes are ordinary non-zeros")
    func valueBounds() {
        let lo = Int(Int32.min), hi = Int(Int32.max)
        #expect(moved([0, lo, 0, hi]) == [lo, hi, 0, 0])
    }

    @Test("upper bound: 10^4 elements, alternating zero / non-zero")
    func upperBound() {
        let input = (1...5_000).flatMap { [0, $0] }
        let expected = Array(1...5_000) + Array(repeating: 0, count: 5_000)
        #expect(moved(input) == expected)
    }
}
