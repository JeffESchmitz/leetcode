import Testing
@testable import IntersectionOfTwoLinkedLists

@Suite("Intersection of Two Linked Lists")
struct IntersectionOfTwoLinkedListsTests {
    private let solution = Solution()

    /// Builds a list from `values`, ending at `tail` (nil by default).
    /// Passing a shared `tail` into two separate builds is how these tests
    /// create a *real* intersection — same node objects, not just equal values.
    private func buildList(_ values: [Int], tail: ListNode? = nil) -> ListNode? {
        var head: ListNode? = tail
        for value in values.reversed() {
            let node = ListNode(value)
            node.next = head
            head = node
        }
        return head
    }

    @Test("example 1: intersect partway through, at value 8")
    func example1() {
        let shared = buildList([8, 4, 5])
        let headA = buildList([4, 1], tail: shared)
        let headB = buildList([5, 6, 1], tail: shared)

        #expect(solution.getIntersectionNode(headA, headB) === shared)
    }

    @Test("example 2: intersect closer to the end, at value 2")
    func example2() {
        let shared = buildList([2, 4])
        let headA = buildList([1, 9, 1], tail: shared)
        let headB = buildList([3], tail: shared)

        #expect(solution.getIntersectionNode(headA, headB) === shared)
    }

    @Test("no intersection: entirely separate lists")
    func noIntersection() {
        let headA = buildList([2, 6, 4])
        let headB = buildList([1, 5])

        #expect(solution.getIntersectionNode(headA, headB) == nil)
    }

    @Test("equal values but distinct node objects: still no intersection")
    func equalValuesDifferentNodes() {
        // A naive value-comparison (instead of node identity) would wrongly
        // report an intersection here.
        let headA = buildList([1, 2, 3])
        let headB = buildList([1, 2, 3])

        #expect(solution.getIntersectionNode(headA, headB) == nil)
    }

    @Test("full overlap: both heads are the same node")
    func fullOverlap() {
        let shared = buildList([1, 2, 3])

        #expect(solution.getIntersectionNode(shared, shared) === shared)
    }

    @Test("one list is entirely the other's tail (empty prefix)")
    func oneListIsPureTail() {
        let shared = buildList([5, 6, 7])
        let headA = buildList([9, 9], tail: shared)

        #expect(solution.getIntersectionNode(headA, shared) === shared)
    }

    @Test("single shared node, different-length prefixes")
    func singleSharedNode() {
        let shared = buildList([42])
        let headA = buildList([1, 1, 1, 1], tail: shared)
        let headB = buildList([2], tail: shared)

        #expect(solution.getIntersectionNode(headA, headB) === shared)
    }

    @Test("longer lists with a large length difference still find the shared tail")
    func largeLengthDifference() {
        let shared = buildList([100])
        let headA = buildList(Array(1...500), tail: shared)
        let headB = buildList([999], tail: shared)

        #expect(solution.getIntersectionNode(headA, headB) === shared)
    }
}
