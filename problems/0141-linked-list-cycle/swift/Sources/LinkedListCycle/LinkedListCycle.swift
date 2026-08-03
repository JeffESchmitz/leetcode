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
        // Floyd's tortoise and hare: slow steps 1 node, fast steps 2. If the
        // list is a straight line, fast reaches nil first. If it loops, fast
        // is always gaining one node per step once both are in the loop, so
        // it eventually laps and lands on slow's exact node. O(1) space.
        var slow = head
        var fast = head

        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            if slow === fast {
                return true
            }
        }

        return false
    }
}
