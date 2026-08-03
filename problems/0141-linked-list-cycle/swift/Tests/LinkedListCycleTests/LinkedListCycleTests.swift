import Testing
@testable import LinkedListCycle

@Suite("Linked List Cycle")
struct LinkedListCycleTests {
    private let solution = Solution()

    // Builds a list from `values` and, when `pos >= 0`, links the tail back
    // to the node at index `pos` — mirrors LeetCode's `pos` parameter.
    private func buildList(_ values: [Int], cycleAt pos: Int = -1) -> ListNode? {
        let nodes = values.map { ListNode($0) }
        guard !nodes.isEmpty else { return nil }

        for i in 0..<(nodes.count - 1) {
            nodes[i].next = nodes[i + 1]
        }
        if pos >= 0 {
            nodes[nodes.count - 1].next = nodes[pos]
        }
        return nodes[0]
    }

    @Test("example 1: cycle at index 1")
    func example1() {
        let head = buildList([3, 2, 0, -4], cycleAt: 1)
        #expect(solution.hasCycle(head) == true)
    }

    @Test("example 2: cycle at index 0")
    func example2() {
        let head = buildList([1, 2], cycleAt: 0)
        #expect(solution.hasCycle(head) == true)
    }

    @Test("example 3: no cycle")
    func example3() {
        let head = buildList([1])
        #expect(solution.hasCycle(head) == false)
    }

    @Test("empty list")
    func emptyList() {
        #expect(solution.hasCycle(nil) == false)
    }

    @Test("single node, self loop")
    func singleNodeSelfLoop() {
        let head = buildList([1], cycleAt: 0)
        #expect(solution.hasCycle(head) == true)
    }

    @Test("two nodes, no cycle")
    func twoNodesNoCycle() {
        let head = buildList([1, 2])
        #expect(solution.hasCycle(head) == false)
    }

    @Test("longer list, no cycle")
    func longerListNoCycle() {
        let head = buildList(Array(1...1000))
        #expect(solution.hasCycle(head) == false)
    }

    @Test("longer list, cycle near the tail")
    func longerListCycleNearTail() {
        let head = buildList(Array(1...1000), cycleAt: 998)
        #expect(solution.hasCycle(head) == true)
    }
}
