public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

/// LeetCode 141. Linked List Cycle
/// https://leetcode.com/problems/linked-list-cycle/
///
/// Returns whether the list rooted at `head` contains a cycle.
public struct Solution {
    public init() {}

    public func hasCycle(_ head: ListNode?) -> Bool {
        if head == nil { return false }
        var seen = Set<ObjectIdentifier>()
        var current = head
        while current != nil {
            if seen.contains(ObjectIdentifier(current!)) {
                return true
            }
            seen.insert(ObjectIdentifier(current!))
            current = current?.next
        }
        return false
    }
}
