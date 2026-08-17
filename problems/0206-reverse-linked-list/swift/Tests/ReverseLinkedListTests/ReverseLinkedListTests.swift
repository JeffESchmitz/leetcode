import Testing
@testable import ReverseLinkedList

@Suite("Reverse Linked List")
struct ReverseLinkedListTests {
    private let solution = Solution()

    private func buildList(_ values: [Int]) -> ListNode? {
        let nodes = values.map { ListNode($0) }
        guard !nodes.isEmpty else { return nil }
        for i in 0..<(nodes.count - 1) {
            nodes[i].next = nodes[i + 1]
        }
        return nodes[0]
    }

    private func toArray(_ head: ListNode?) -> [Int] {
        var values: [Int] = []
        var current = head
        while let node = current {
            values.append(node.val)
            current = node.next
        }
        return values
    }

    @Test("example 1: five nodes")
    func example1() {
        let head = buildList([1, 2, 3, 4, 5])
        let reversed = solution.reverseList(head)
        #expect(toArray(reversed) == [5, 4, 3, 2, 1])
    }

    @Test("example 2: two nodes")
    func example2() {
        let head = buildList([1, 2])
        let reversed = solution.reverseList(head)
        #expect(toArray(reversed) == [2, 1])
    }

    @Test("example 3: empty list")
    func example3() {
        let reversed = solution.reverseList(nil)
        #expect(toArray(reversed) == [])
    }

    @Test("single node")
    func singleNode() {
        let head = buildList([7])
        let reversed = solution.reverseList(head)
        #expect(toArray(reversed) == [7])
    }

    @Test("negative and repeated values")
    func negativeAndRepeatedValues() {
        let head = buildList([-5, 0, 0, 3, -5])
        let reversed = solution.reverseList(head)
        #expect(toArray(reversed) == [-5, 3, 0, 0, -5])
    }

    @Test("longer list")
    func longerList() {
        let head = buildList(Array(1...1000))
        let reversed = solution.reverseList(head)
        #expect(toArray(reversed) == Array((1...1000).reversed()))
    }
}
