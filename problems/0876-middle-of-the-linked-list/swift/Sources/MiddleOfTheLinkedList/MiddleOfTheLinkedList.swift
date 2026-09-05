public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

/// LeetCode 876. Middle of the Linked List
/// https://leetcode.com/problems/middle-of-the-linked-list/
public struct Solution {
    public init() {}

    public func middleNode(_ head: ListNode?) -> ListNode? {
        var slow = head
        var fast = head

        // Unwrap first so the body only touches real nodes: `current` is where
        // `fast` stands, `ahead` is the node after it. Both must exist to double-step.
        while let current = fast, let ahead = current.next {
            slow = slow?.next
            fast = ahead.next
        }

        return slow
    }
}
