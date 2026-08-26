import Testing
@testable import RemoveDuplicates

@Suite("Remove Duplicates from Sorted Array")
struct RemoveDuplicatesTests {
    private let solution = Solution()

    /// Mirrors the LeetCode custom judge: run in place, then check `k` and only
    /// the first `k` elements. Whatever sits past `k` is deliberately ignored.
    private func check(_ input: [Int], expecting expected: [Int]) {
        var nums = input
        let k = solution.removeDuplicates(&nums)
        #expect(k == expected.count)
        #expect(Array(nums.prefix(k)) == expected)
    }

    @Test("example 1: [1,1,2]")
    func example1() {
        check([1, 1, 2], expecting: [1, 2])
    }

    @Test("example 2: [0,0,1,1,1,2,2,3,3,4]")
    func example2() {
        check([0, 0, 1, 1, 1, 2, 2, 3, 3, 4], expecting: [0, 1, 2, 3, 4])
    }

    @Test("single element: k = 1, untouched")
    func singleElement() {
        check([7], expecting: [7])
    }

    @Test("two equal elements collapse to one")
    func twoEqual() {
        check([3, 3], expecting: [3])
    }

    @Test("two distinct elements are both kept")
    func twoDistinct() {
        check([3, 4], expecting: [3, 4])
    }

    @Test("all unique: nothing moves, k = n")
    func allUnique() {
        check([1, 2, 3, 4, 5], expecting: [1, 2, 3, 4, 5])
    }

    @Test("all identical: k = 1")
    func allIdentical() {
        check([2, 2, 2, 2, 2, 2], expecting: [2])
    }

    @Test("duplicates only at the start")
    func duplicatesAtStart() {
        check([1, 1, 1, 2, 3], expecting: [1, 2, 3])
    }

    @Test("duplicates only at the end")
    func duplicatesAtEnd() {
        check([1, 2, 3, 3, 3], expecting: [1, 2, 3])
    }

    @Test("negatives sort before positives and dedupe the same way")
    func negatives() {
        check([-3, -3, -1, 0, 0, 0, 2], expecting: [-3, -1, 0, 2])
    }

    @Test("value bounds: -100 and 100 with runs of each")
    func valueBounds() {
        check([-100, -100, -100, 100, 100], expecting: [-100, 100])
    }

    @Test("upper bound: 3 * 10^4 elements, every value repeated 150 times")
    func upperBound() {
        // 200 distinct values (-100...99), each repeated 150 times = 30,000 elements.
        let input = (-100..<100).flatMap { Array(repeating: $0, count: 150) }
        check(input, expecting: Array(-100..<100))
    }
}
