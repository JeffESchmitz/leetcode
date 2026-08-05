import Testing
@testable import BinarySearch

@Suite("Binary Search")
struct BinarySearchTests {
    private let solution = Solution()

    @Test("example 1: target present in the middle region")
    func example1() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], 9) == 4)
    }

    @Test("example 2: target absent")
    func example2() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], 2) == -1)
    }

    @Test("single element, match")
    func singleElementMatch() {
        #expect(solution.search([5], 5) == 0)
    }

    @Test("single element, no match")
    func singleElementNoMatch() {
        #expect(solution.search([5], -5) == -1)
    }

    @Test("target is the first element")
    func targetAtFirstIndex() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], -1) == 0)
    }

    @Test("target is the last element")
    func targetAtLastIndex() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], 12) == 5)
    }

    @Test("target below the whole range")
    func targetBelowRange() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], -100) == -1)
    }

    @Test("target above the whole range")
    func targetAboveRange() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], 100) == -1)
    }

    @Test("target falls between two elements")
    func targetBetweenElements() {
        #expect(solution.search([-1, 0, 3, 5, 9, 12], 7) == -1)
    }

    @Test("even-length array, target in the left half")
    func evenLengthLeftHalf() {
        #expect(solution.search([2, 4, 6, 8], 4) == 1)
    }

    @Test("all negative values")
    func allNegatives() {
        #expect(solution.search([-9, -7, -5, -3], -7) == 1)
    }

    @Test("empty array")
    func emptyArray() {
        #expect(solution.search([], 1) == -1)
    }
}
