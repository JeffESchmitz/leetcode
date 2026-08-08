import Testing
@testable import MajorityElement

@Suite("Majority Element")
struct MajorityElementTests {
    private let solution = Solution()

    // Every fixture below satisfies the problem's guarantee: a majority
    // element (appearing strictly more than n/2 times) always exists.

    @Test("example 1")
    func example1() {
        #expect(solution.majorityElement([3, 2, 3]) == 3)
    }

    @Test("example 2")
    func example2() {
        #expect(solution.majorityElement([2, 2, 1, 1, 1, 2, 2]) == 2)
    }

    @Test("single element")
    func singleElement() {
        #expect(solution.majorityElement([1]) == 1)
    }

    @Test("two elements, both the same")
    func twoIdenticalElements() {
        #expect(solution.majorityElement([4, 4]) == 4)
    }

    @Test("every element the same")
    func allSame() {
        #expect(solution.majorityElement([7, 7, 7, 7]) == 7)
    }

    @Test("majority runs at the front")
    func majorityAtFront() {
        #expect(solution.majorityElement([5, 5, 5, 1, 2]) == 5)
    }

    @Test("majority runs at the back")
    func majorityAtBack() {
        #expect(solution.majorityElement([1, 2, 5, 5, 5]) == 5)
    }

    @Test("majority never appears twice in a row")
    func majorityInterleaved() {
        #expect(solution.majorityElement([1, 2, 1, 2, 1]) == 1)
    }

    @Test("negative values")
    func negativeValues() {
        #expect(solution.majorityElement([-1, -1, -1, 2, 3]) == -1)
    }

    @Test("large input, majority by exactly one vote, fully interleaved")
    func largeInputBarelyMajority() {
        // 501 nines alternating with 500 distinct non-nines: n = 1001, and
        // floor(1001 / 2) == 500, so nine clears the bar by a single vote.
        var values: [Int] = []
        for other in 101...600 {
            values.append(9)
            values.append(other)
        }
        values.append(9)

        #expect(values.count == 1001)
        #expect(solution.majorityElement(values) == 9)
    }
}
