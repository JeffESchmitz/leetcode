public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

/// LeetCode 160. Intersection of Two Linked Lists
/// https://leetcode.com/problems/intersection-of-two-linked-lists/
public struct Solution {
    public init() {}

    /// Returns the first node both lists share (same object, not equal value),
    /// or `nil` if they never meet.
    ///
    /// Lists that meet can never split again, so the overlap is a shared suffix.
    /// Align both cursors by distance from the end, then walk them in lockstep.
    ///
    /// O(m + n) time, O(1) space.
    public func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        let lengthA = length(headA)
        let lengthB = length(headB)

        var cursorA = headA
        var cursorB = headB

        // Give the longer list a head start equal to the length difference.
        if lengthA > lengthB {
            cursorA = advance(cursorA, by: lengthA - lengthB)
        } else {
            cursorB = advance(cursorB, by: lengthB - lengthA)
        }

        // Aligned: step together. If the lists never meet, both hit nil together.
        while cursorA != nil && cursorB != nil {
            // Identity, not equality.
            if cursorA === cursorB {
                return cursorA
            }
            cursorA = cursorA?.next
            cursorB = cursorB?.next
        }

        return nil
    }

    /// Counts the nodes reachable from `head`.
    private func length(_ head: ListNode?) -> Int {
        var count = 0
        var current = head
        while current != nil {
            count += 1
            current = current?.next
        }
        return count
    }

    /// Walks `steps` nodes forward without inspecting them.
    private func advance(_ node: ListNode?, by steps: Int) -> ListNode? {
        var current = node
        for _ in 0..<steps {
            current = current?.next
        }
        return current
    }
}
