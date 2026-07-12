import Testing
import MergeTwoSortedLists

@Suite
struct MergeTwoSortedListsTests {
    // Helper to build a linked list from an array
    static func buildList(_ values: [Int]) -> ListNode? {
        var head: ListNode?
        var tail: ListNode?
        for v in values {
            let node = ListNode(v)
            if head == nil {
                head = node
                tail = node
            } else {
                tail!.next = node
                tail = node
            }
        }
        return head
    }

    // Helper to convert a linked list back to an array for easy comparison
    static func listToArray(_ node: ListNode?) -> [Int] {
        var arr: [Int] = []
        var current = node
        while let n = current {
            arr.append(n.val)
            current = n.next
        }
        return arr
    }

    @Test func example1() {
        let l1 = Self.buildList([1, 2, 4])
        let l2 = Self.buildList([1, 3, 4])
        let merged = mergeTwoLists(l1, l2)
        #expect(Self.listToArray(merged) == [1, 1, 2, 3, 4, 4])
    }

    @Test func example2EmptyBoth() {
        let merged = mergeTwoLists(nil, nil)
        #expect(Self.listToArray(merged) == [])
    }

    @Test func example3OneEmpty() {
        let l2 = Self.buildList([0])
        let merged = mergeTwoLists(nil, l2)
        #expect(Self.listToArray(merged) == [0])
    }
}
