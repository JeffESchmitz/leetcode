import Testing
@testable import MaximumAverageSubarray

@Suite("Maximum Average Subarray I")
struct MaximumAverageSubarrayTests {
    private let solution = Solution()

    /// LeetCode accepts answers within 1e-5 of the expected value.
    private let tolerance = 1e-5

    @Test("example 1: [1,12,-5,-6,50,3], k = 4")
    func example1() {
        #expect(abs(solution.findMaxAverage([1, 12, -5, -6, 50, 3], 4) - 12.75) < tolerance)
    }

    @Test("example 2: single element, k = 1")
    func example2() {
        #expect(abs(solution.findMaxAverage([5], 1) - 5.0) < tolerance)
    }

    @Test("k equals the whole array: only one window exists")
    func windowIsWholeArray() {
        #expect(abs(solution.findMaxAverage([1, 2, 3, 4], 4) - 2.5) < tolerance)
    }

    @Test("k = 1: the answer is just the maximum element")
    func windowOfOne() {
        #expect(abs(solution.findMaxAverage([-3, 7, 2, -8], 1) - 7.0) < tolerance)
    }

    @Test("best window is at the very start")
    func bestWindowAtStart() {
        #expect(abs(solution.findMaxAverage([9, 9, 1, 1, 1], 2) - 9.0) < tolerance)
    }

    @Test("best window is at the very end")
    func bestWindowAtEnd() {
        #expect(abs(solution.findMaxAverage([1, 1, 1, 9, 9], 2) - 9.0) < tolerance)
    }

    @Test("all values negative: max average is still negative")
    func allNegative() {
        #expect(abs(solution.findMaxAverage([-1, -12, -5, -6, -50, -3], 4) - (-6.0)) < tolerance)
    }

    @Test("all values identical: every window ties")
    func allIdentical() {
        #expect(abs(solution.findMaxAverage([4, 4, 4, 4, 4], 3) - 4.0) < tolerance)
    }

    @Test("non-integer average: must not be truncated by integer division")
    func nonIntegerAverage() {
        #expect(abs(solution.findMaxAverage([0, 1, 1, 3, 3], 2) - 3.0) < tolerance)
    }

    @Test("negative non-integer average: rounding must not drift toward zero")
    func negativeNonIntegerAverage() {
        #expect(abs(solution.findMaxAverage([-1, -2], 2) - (-1.5)) < tolerance)
    }

    @Test("value bounds: mixed extremes at the 10^4 ceiling")
    func valueBounds() {
        #expect(abs(solution.findMaxAverage([-10_000, 10_000, -10_000, 10_000], 2) - 0.0) < tolerance)
    }

    @Test("upper bound: 10^5 elements, best window at the far end")
    func upperBoundManyElements() {
        let nums = Array(repeating: 1, count: 99_000) + Array(repeating: 10_000, count: 1_000)
        #expect(abs(solution.findMaxAverage(nums, 1_000) - 10_000.0) < tolerance)
    }
}
