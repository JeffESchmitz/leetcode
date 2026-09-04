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
        
        // Each cursor skips its own surplus; the shorter list's surplus is 0.
        var cursorA = advance(headA, by: max(0, lengthA - lengthB))
        var cursorB = advance(headB, by: max(0, lengthB - lengthA))
        
        // Aligned: step together. If the lists never meet, both hit nil together.
        while let a = cursorA, let b = cursorB {
            // Identity, not equality.
            if a === b {
                return a
            }
            cursorA = a.next
            cursorB = b.next
        }
        
        return nil
    }
    
    /// Counts the nodes reachable from `head`.
    private func length(_ head: ListNode?) -> Int {
        guard let head else {
            return 0
        }
        return sequence(first: head, next: \.next)
            .reduce(0) { count, _ in count + 1 }
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
