import Testing
@testable import RemoveDuplicatesII

@Suite("Remove Duplicates from Sorted Array II")
struct RemoveDuplicatesIITests {
    private let solution = Solution()

    // Check the count and kept prefix; the ignored tail may contain any values.
    private func check(_ input: [Int], expecting expected: [Int]) {
        var nums = input
        let k = solution.removeDuplicates(&nums)
        #expect(k == expected.count)
        #expect(Array(nums.prefix(k)) == expected)
        #expect(nums.count == input.count)
    }

    @Test("example 1")
    func example1() {
        check([1, 1, 1, 2, 2, 3], expecting: [1, 1, 2, 2, 3])
    }

    @Test("example 2")
    func example2() {
        check([0, 0, 1, 1, 1, 1, 2, 3, 3], expecting: [0, 0, 1, 1, 2, 3, 3])
    }

    @Test("single element never reads a negative index")
    func singleElement() {
        check([4], expecting: [4])
    }

    @Test("second copy is kept without reading a negative index")
    func twoEqual() {
        check([4, 4], expecting: [4, 4])
    }

    @Test("third copy is discarded")
    func threeEqual() {
        check([4, 4, 4], expecting: [4, 4])
    }

    @Test("all identical")
    func allIdentical() {
        check([7, 7, 7, 7], expecting: [7, 7])
    }

    @Test("all different")
    func allDifferent() {
        check([-2, -1, 0, 1, 2], expecting: [-2, -1, 0, 1, 2])
    }

    @Test("singles and pairs are all kept")
    func singlesAndPairs() {
        check([-3, -3, -1, 0, 0], expecting: [-3, -3, -1, 0, 0])
    }

    @Test("new group after discarded copies: compare against kept values")
    func newGroupAfterDiscard() {
        check([4, 4, 4, 4, 5, 5, 5, 6], expecting: [4, 4, 5, 5, 6])
    }

    @Test("negative and positive value bounds")
    func valueBounds() {
        check([-10_000, -10_000, -10_000, 0, 10_000, 10_000, 10_000],
              expecting: [-10_000, -10_000, 0, 10_000, 10_000])
    }

    @Test("upper bound: 30,000 elements")
    func upperBound() {
        let input = (-100..<100).flatMap { Array(repeating: $0, count: 150) }
        let expected = (-100..<100).flatMap { [$0, $0] }
        check(input, expecting: expected)
    }

    @Test("empty input: extra behavior outside judge constraints")
    func emptyInput() {
        check([], expecting: [])
    }
}
