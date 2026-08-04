import Testing
@testable import ContainsDuplicate

@Suite("Contains Duplicate")
struct ContainsDuplicateTests {
    private let solution = Solution()

    @Test("example 1: duplicate exists")
    func example1() {
        #expect(solution.containsDuplicate([1, 2, 3, 1]) == true)
    }

    @Test("example 2: all distinct elements")
    func example2() {
        #expect(solution.containsDuplicate([1, 2, 3, 4]) == false)
    }

    @Test("example 3: multiple duplicates")
    func example3() {
        #expect(solution.containsDuplicate([1, 1, 1, 3, 3, 4, 3, 2, 4, 2]) == true)
    }

    @Test("empty array")
    func emptyArray() {
        #expect(solution.containsDuplicate([]) == false)
    }

    @Test("single element")
    func singleElement() {
        #expect(solution.containsDuplicate([1]) == false)
    }

    @Test("negative numbers with duplicate")
    func negativeNumbersWithDuplicate() {
        #expect(solution.containsDuplicate([-1, -2, -1]) == true)
    }

    @Test("all elements identical")
    func allElementsIdentical() {
        #expect(solution.containsDuplicate([5, 5, 5]) == true)
    }

    @Test("duplicate at first and last position")
    func duplicateAtEnds() {
        #expect(solution.containsDuplicate([100, 2, 3, 4, 100]) == true)
    }
}
