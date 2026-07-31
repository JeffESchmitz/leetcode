import Testing
@testable import ClimbingStairs

@Suite("Climbing Stairs")
struct ClimbingStairsTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        #expect(solution.climbStairs(2) == 2)
    }

    @Test("example 2")
    func example2() {
        #expect(solution.climbStairs(3) == 3)
    }

    @Test("one step")
    func oneStep() {
        #expect(solution.climbStairs(1) == 1)
    }

    @Test("four steps")
    func fourSteps() {
        #expect(solution.climbStairs(4) == 5)
    }

    @Test("five steps")
    func fiveSteps() {
        #expect(solution.climbStairs(5) == 8)
    }

    @Test("max constraint")
    func maxConstraint() {
        #expect(solution.climbStairs(45) == 1_836_311_903)
    }
}
