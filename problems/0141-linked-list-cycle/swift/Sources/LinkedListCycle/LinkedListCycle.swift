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
/// Returns whether the list rooted at `head` contains a cycle. See the
/// problem README for the walkthrough of both approaches below.
public struct Solution {
    public init() {}

    /// Floyd's tortoise and hare — the O(1)-space answer to the problem's
    /// follow-up. `slow` steps 1 node at a time, `fast` steps 2. On a
    /// straight (non-cyclic) list, `fast` reaches `nil` first. On a cyclic
    /// list, both pointers eventually enter the loop, and `fast` gains
    /// exactly one node on `slow` every step inside it — like a faster
    /// runner lapping a slower one on a circular track — so they're
    /// guaranteed to land on the same node eventually.
    public func hasCycle(_ head: ListNode?) -> Bool {
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

    /// Original approach kept for comparison: remember every node visited
    /// (by reference identity) in a set. Seeing the same node twice means a
    /// cycle. O(n) time, but O(n) space — versus O(1) for `hasCycle` above.
    public func hasCycleUsingHashSet(_ head: ListNode?) -> Bool {
        guard let head = head else {
            return false
        }

        var seen = Set<ObjectIdentifier>()
        var current: ListNode? = head

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
