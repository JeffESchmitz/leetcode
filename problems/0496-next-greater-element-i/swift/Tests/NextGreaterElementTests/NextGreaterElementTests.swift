import Testing
@testable import NextGreaterElement

@Suite("Next Greater Element I")
struct NextGreaterElementTests {
    private let solution = Solution()

    @Test("example 1: [4,1,2] over [1,3,4,2]")
    func example1() {
        #expect(solution.nextGreaterElement([4, 1, 2], [1, 3, 4, 2]) == [-1, 3, -1])
    }

    @Test("example 2: [2,4] over [1,2,3,4]")
    func example2() {
        #expect(solution.nextGreaterElement([2, 4], [1, 2, 3, 4]) == [3, -1])
    }

    @Test("single element in both arrays")
    func singleElement() {
        #expect(solution.nextGreaterElement([1], [1]) == [-1])
    }

    @Test("strictly ascending nums2: every answer is the neighbor to the right")
    func strictlyAscending() {
        #expect(solution.nextGreaterElement([1, 2, 3, 4], [1, 2, 3, 4]) == [2, 3, 4, -1])
    }

    @Test("strictly descending nums2: no element has a greater one to its right")
    func strictlyDescending() {
        #expect(solution.nextGreaterElement([5, 4, 3, 2, 1], [5, 4, 3, 2, 1]) == [-1, -1, -1, -1, -1])
    }

    @Test("answers follow nums1 order, not nums2 order")
    func answersFollowQueryOrder() {
        #expect(solution.nextGreaterElement([3, 1], [1, 3, 4, 2]) == [4, 3])
    }

    @Test("the greater element may be far to the right, not adjacent")
    func greaterElementIsDistant() {
        #expect(solution.nextGreaterElement([5], [5, 1, 2, 3, 9]) == [9])
    }

    @Test("zero is a legal value")
    func zeroIsALegalValue() {
        #expect(solution.nextGreaterElement([0, 1], [0, 2, 1]) == [2, -1])
    }

    @Test("a smaller element to the right does not count")
    func smallerElementToTheRightDoesNotCount() {
        #expect(solution.nextGreaterElement([6, 4], [6, 4, 5, 1]) == [-1, 5])
    }

    @Test("nums1 queries a single element buried in the middle of nums2")
    func buriedQuery() {
        #expect(solution.nextGreaterElement([7], [1, 9, 7, 3, 8, 2]) == [8])
    }

    @Test("upper bound: 1000 ascending values")
    func upperBoundAscending() {
        let nums2 = Array(1...1000)
        #expect(solution.nextGreaterElement([1, 500, 1000], nums2) == [2, 501, -1])
    }

    @Test("upper bound: 1000 descending values")
    func upperBoundDescending() {
        let nums2 = Array((1...1000).reversed())
        #expect(solution.nextGreaterElement(nums2, nums2) == Array(repeating: -1, count: 1000))
    }
}
