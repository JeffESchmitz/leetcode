import Testing
@testable import FindPivotIndex

@Suite("Find Pivot Index")
struct FindPivotIndexTests {
    private let solution = Solution()

    @Test("example 1: [1,7,3,6,5,6]")
    func example1() {
        #expect(solution.pivotIndex([1, 7, 3, 6, 5, 6]) == 3)
    }

    @Test("example 2: no pivot exists")
    func example2() {
        #expect(solution.pivotIndex([1, 2, 3]) == -1)
    }

    @Test("example 3: pivot at index 0, with a negative value")
    func example3() {
        #expect(solution.pivotIndex([2, 1, -1]) == 0)
    }

    @Test("single element: trivially its own pivot")
    func singleElement() {
        #expect(solution.pivotIndex([5]) == 0)
    }

    @Test("negative values, pivot in the middle")
    func negativeValuesPivotInMiddle() {
        #expect(solution.pivotIndex([-2, 3, -5, 4, -3]) == 2)
    }

    @Test("pivot at the last index")
    func pivotAtLastIndex() {
        #expect(solution.pivotIndex([1, -1, 3, -3, 5]) == 4)
    }

    @Test("multiple valid pivot indices: returns the leftmost")
    func multipleValidPivotsReturnsLeftmost() {
        #expect(solution.pivotIndex([1, -1, 0, 0, 1, -1]) == 2)
    }

    @Test("upper bound: 9,999 elements")
    func upperBoundManyElements() {
        let nums = Array(repeating: 1, count: 4_999) + [0] + Array(repeating: 1, count: 4_999)
        #expect(solution.pivotIndex(nums) == 4_999)
    }
}
