import Testing
@testable import ContainerWithMostWater

@Suite("Container With Most Water")
struct ContainerWithMostWaterTests {
    private let solution = Solution()

    @Test("example 1: [1,8,6,2,5,4,8,3,7] -> 49")
    func example1() {
        #expect(solution.maxArea([1, 8, 6, 2, 5, 4, 8, 3, 7]) == 49)
    }

    @Test("example 2: [1,1] -> 1, smallest legal input")
    func example2() {
        #expect(solution.maxArea([1, 1]) == 1)
    }

    @Test("a zero-height line holds no water")
    func zeroHeight() {
        #expect(solution.maxArea([0, 2]) == 0)
    }

    @Test("tall lines at both ends win")
    func tallEnds() {
        #expect(solution.maxArea([10, 1, 1, 1, 10]) == 40)
    }

    @Test("two tall lines side by side in the middle win")
    func tallMiddle() {
        #expect(solution.maxArea([1, 100, 100, 1]) == 100)
    }

    @Test("all heights equal: the widest pair wins")
    func allEqual() {
        #expect(solution.maxArea([5, 5, 5, 5]) == 15)
    }

    @Test("strictly increasing heights")
    func increasing() {
        #expect(solution.maxArea([1, 2, 3, 4, 5]) == 6)
    }

    @Test("strictly decreasing heights")
    func decreasing() {
        #expect(solution.maxArea([5, 4, 3, 2, 1]) == 6)
    }

    @Test("upper bound: 10^5 lines of height 10^4")
    func upperBound() {
        let height = Array(repeating: 10_000, count: 100_000)
        #expect(solution.maxArea(height) == 10_000 * 99_999)
    }
}
