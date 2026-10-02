import Testing
@testable import MergeSortedArray

@Suite("Merge Sorted Array")
struct MergeSortedArrayTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        var nums1 = [1, 2, 3, 0, 0, 0]
        solution.merge(&nums1, 3, [2, 5, 6], 3)
        #expect(nums1 == [1, 2, 2, 3, 5, 6])
    }

    @Test("example 2: nums2 is empty")
    func example2() {
        var nums1 = [1]
        solution.merge(&nums1, 1, [], 0)
        #expect(nums1 == [1])
    }

    @Test("example 3: nums1 has no real elements")
    func example3() {
        var nums1 = [0]
        solution.merge(&nums1, 0, [1], 1)
        #expect(nums1 == [1])
    }

    @Test("every nums2 element is smaller than nums1")
    func nums2AllSmaller() {
        var nums1 = [4, 5, 6, 0, 0, 0]
        solution.merge(&nums1, 3, [1, 2, 3], 3)
        #expect(nums1 == [1, 2, 3, 4, 5, 6])
    }

    @Test("every nums2 element is larger than nums1")
    func nums2AllLarger() {
        var nums1 = [1, 2, 3, 0, 0, 0]
        solution.merge(&nums1, 3, [4, 5, 6], 3)
        #expect(nums1 == [1, 2, 3, 4, 5, 6])
    }

    @Test("interleaved values")
    func interleaved() {
        var nums1 = [1, 3, 5, 7, 0, 0, 0, 0]
        solution.merge(&nums1, 4, [2, 4, 6, 8], 4)
        #expect(nums1 == [1, 2, 3, 4, 5, 6, 7, 8])
    }

    @Test("uneven lengths")
    func unevenLengths() {
        var nums1 = [2, 0, 0, 0, 0]
        solution.merge(&nums1, 1, [1, 3, 4, 5], 4)
        #expect(nums1 == [1, 2, 3, 4, 5])
    }

    @Test("duplicates across both arrays")
    func duplicates() {
        var nums1 = [1, 1, 2, 0, 0, 0]
        solution.merge(&nums1, 3, [1, 2, 2], 3)
        #expect(nums1 == [1, 1, 1, 2, 2, 2])
    }

    @Test("negative values")
    func negatives() {
        var nums1 = [-5, -1, 3, 0, 0]
        solution.merge(&nums1, 3, [-3, 0], 2)
        #expect(nums1 == [-5, -3, -1, 0, 3])
    }

    @Test("real zeros are not mistaken for padding")
    func realZeros() {
        var nums1 = [0, 0, 0, 0]
        solution.merge(&nums1, 2, [0, 0], 2)
        #expect(nums1 == [0, 0, 0, 0])
    }

    @Test("values at the constraint bounds")
    func constraintBounds() {
        var nums1 = [-1_000_000_000, 1_000_000_000, 0]
        solution.merge(&nums1, 2, [0], 1)
        #expect(nums1 == [-1_000_000_000, 0, 1_000_000_000])
    }
}
