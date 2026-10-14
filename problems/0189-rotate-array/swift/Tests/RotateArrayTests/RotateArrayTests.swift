import Testing
@testable import RotateArray

@Suite("Rotate Array")
struct RotateArrayTests {
    private let solution = Solution()

    private func check(_ input: [Int], steps k: Int, expecting expected: [Int]) {
        var nums = input
        solution.rotate(&nums, k)
        #expect(nums == expected)
        #expect(nums.count == input.count)
    }

    @Test("example 1: seven elements, three steps right")
    func example1() {
        check([1, 2, 3, 4, 5, 6, 7], steps: 3, expecting: [5, 6, 7, 1, 2, 3, 4])
    }

    @Test("example 2: negatives, two steps right")
    func example2() {
        check([-1, -100, 3, 99], steps: 2, expecting: [3, 99, -1, -100])
    }

    @Test("zero steps leaves every position unchanged")
    func zeroSteps() {
        check([1, 2, 3], steps: 0, expecting: [1, 2, 3])
    }

    @Test("one element, zero steps")
    func singletonZeroSteps() {
        check([7], steps: 0, expecting: [7])
    }

    @Test("one element, largest allowed step count")
    func singletonManySteps() {
        check([7], steps: 100_000, expecting: [7])
    }

    @Test("one step moves the last element to the front")
    func oneStep() {
        check([1, 2, 3, 4], steps: 1, expecting: [4, 1, 2, 3])
    }

    @Test("step count equals array length")
    func fullTurn() {
        check([1, 2, 3, 4], steps: 4, expecting: [1, 2, 3, 4])
    }

    @Test("step count exceeds array length")
    func moreThanLength() {
        check([1, 2, 3, 4], steps: 6, expecting: [3, 4, 1, 2])
    }

    @Test("multiple full turns")
    func multipleFullTurns() {
        check([1, 2, 3], steps: 99_999, expecting: [1, 2, 3])
    }

    @Test("two elements swap")
    func twoElements() {
        check([1, 2], steps: 1, expecting: [2, 1])
    }

    @Test("odd length, two steps")
    func oddLength() {
        check([1, 2, 3, 4, 5], steps: 2, expecting: [4, 5, 1, 2, 3])
    }

    @Test("even length, two steps")
    func evenLength() {
        check([1, 2, 3, 4, 5, 6], steps: 2, expecting: [5, 6, 1, 2, 3, 4])
    }

    @Test("repeated values and zero are preserved")
    func repeatedValues() {
        check([0, 1, 1, 2, 2], steps: 2, expecting: [2, 2, 0, 1, 1])
    }

    @Test("32-bit integer value bounds")
    func valueBounds() {
        check([-2_147_483_648, 0, 2_147_483_647], steps: 1,
              expecting: [2_147_483_647, -2_147_483_648, 0])
    }

    @Test("100,000 elements, one step")
    func upperBound() {
        let input = Array(0..<100_000)
        let expected = [99_999] + Array(0..<99_999)
        check(input, steps: 1, expecting: expected)
    }
}
