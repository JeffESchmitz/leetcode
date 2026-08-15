import Testing
@testable import HappyNumber

@Suite("Happy Number")
struct HappyNumberTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        #expect(solution.isHappy(19) == true)
    }

    @Test("example 2")
    func example2() {
        #expect(solution.isHappy(2) == false)
    }

    @Test("one is happy")
    func oneIsHappy() {
        #expect(solution.isHappy(1) == true)
    }

    @Test("seven is happy")
    func sevenIsHappy() {
        #expect(solution.isHappy(7) == true)
    }

    @Test("zero is not happy")
    func zeroIsNotHappy() {
        #expect(solution.isHappy(0) == false)
    }

    @Test("cycle without one")
    func cycleWithoutOne() {
        #expect(solution.isHappy(4) == false)
    }

    @Test("ten is happy")
    func tenIsHappy() {
        #expect(solution.isHappy(10) == true)
    }
}
