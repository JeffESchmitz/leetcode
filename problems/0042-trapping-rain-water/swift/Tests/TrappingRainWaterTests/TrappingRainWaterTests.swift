import Testing
@testable import TrappingRainWater

@Suite("Trapping Rain Water")
struct TrappingRainWaterTests {
    private let solution = Solution()

    @Test("example 1: [0,1,0,2,1,0,1,3,2,1,2,1] -> 6")
    func example1() {
        #expect(solution.trap([0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]) == 6)
    }

    @Test("example 2: [4,2,0,3,2,5] -> 9")
    func example2() {
        #expect(solution.trap([4, 2, 0, 3, 2, 5]) == 9)
    }

    @Test("a single bar holds nothing")
    func singleBar() {
        #expect(solution.trap([7]) == 0)
    }

    @Test("two bars hold nothing: no space between them")
    func twoBars() {
        #expect(solution.trap([3, 5]) == 0)
    }

    @Test("all zeros hold nothing")
    func allZeros() {
        #expect(solution.trap([0, 0, 0, 0]) == 0)
    }

    @Test("flat ground holds nothing")
    func flat() {
        #expect(solution.trap([3, 3, 3]) == 0)
    }

    @Test("strictly increasing: no right wall, nothing held")
    func increasing() {
        #expect(solution.trap([1, 2, 3, 4, 5]) == 0)
    }

    @Test("strictly decreasing: no left wall, nothing held")
    func decreasing() {
        #expect(solution.trap([5, 4, 3, 2, 1]) == 0)
    }

    @Test("smallest basin: [2,0,2] -> 2")
    func smallestBasin() {
        #expect(solution.trap([2, 0, 2]) == 2)
    }

    @Test("the shorter wall sets the level: [5,1,2] -> 1")
    func shorterWallSetsLevel() {
        #expect(solution.trap([5, 1, 2]) == 1)
    }

    @Test("deep and wide: [5,0,0,0,5] -> 15")
    func deepAndWide() {
        #expect(solution.trap([5, 0, 0, 0, 5]) == 15)
    }

    @Test("several separate pools: [2,0,2,0,2] -> 4")
    func severalPools() {
        #expect(solution.trap([2, 0, 2, 0, 2]) == 4)
    }

    @Test("a step inside a basin: [3,0,0,2,0,4] -> 10")
    func stepInsideBasin() {
        #expect(solution.trap([3, 0, 0, 2, 0, 4]) == 10)
    }

    @Test("upper bound: total is 1_999_800_000, just under the 32-bit limit")
    func upperBound() {
        let height = [100_000] + Array(repeating: 0, count: 19_998) + [100_000]
        #expect(solution.trap(height) == 1_999_800_000)
    }
}
