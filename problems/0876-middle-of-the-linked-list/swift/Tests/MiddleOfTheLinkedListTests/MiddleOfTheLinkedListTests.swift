import Testing
@testable import MiddleOfTheLinkedList

@Suite("Middle of the Linked List")
struct MiddleOfTheLinkedListTests {
    private let solution = Solution()

    /// Builds a list from `values` and returns its head.
    private func buildList(_ values: [Int]) -> ListNode? {
        var head: ListNode? = nil
        for value in values.reversed() {
            let node = ListNode(value)
            node.next = head
            head = node
        }
        return head
    }

    /// Walks `index` steps from `head`. Used to name the *expected node itself*,
    /// so every assertion below compares identity (`===`), not values.
    private func node(at index: Int, from head: ListNode?) -> ListNode? {
        var current = head
        for _ in 0..<index {
            current = current?.next
        }
        return current
    }

    @Test("example 1: odd length, the single middle node")
    func example1() {
        let head = buildList([1, 2, 3, 4, 5])

        #expect(solution.middleNode(head) === node(at: 2, from: head))
    }

    @Test("example 2: even length, the second of the two middles")
    func example2() {
        let head = buildList([1, 2, 3, 4, 5, 6])

        #expect(solution.middleNode(head) === node(at: 3, from: head))
    }

    @Test("single node is its own middle")
    func singleNode() {
        let head = buildList([42])

        #expect(solution.middleNode(head) === head)
    }

    @Test("two nodes: the second one")
    func twoNodes() {
        let head = buildList([1, 2])

        #expect(solution.middleNode(head) === node(at: 1, from: head))
    }

    @Test("three nodes: the one in the middle")
    func threeNodes() {
        let head = buildList([1, 2, 3])

        #expect(solution.middleNode(head) === node(at: 1, from: head))
    }

    @Test("all values equal: still the right node, by identity")
    func allValuesEqual() {
        // Every node holds 7. Only identity can tell them apart.
        let head = buildList([7, 7, 7, 7])

        #expect(solution.middleNode(head) === node(at: 2, from: head))
    }

    @Test("max length (100 nodes): index 50")
    func maxLength() {
        let head = buildList(Array(1...100))

        #expect(solution.middleNode(head) === node(at: 50, from: head))
    }
}
