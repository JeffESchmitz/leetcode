public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

/// LeetCode 206. Reverse Linked List
/// https://leetcode.com/problems/reverse-linked-list/
public struct Solution {
    public init() {}

    public func reverseList(_ head: ListNode?) -> ListNode? {
        // need to write psuedocode for reversing a linked list
        // 1. Initialize three pointers: prev as nil, curr as head, and next as nil
        // 2. Iterate through the linked list until curr is nil
        //    a. Store the next node: next = curr.next
        //    b. Reassign the current node's pointer to the previous pointer: curr.next = prev
        //       note: this is where the "reverse" action happens
        //    c. Move the pointers one step forward: prev = curr, curr = next
        // 3. Return prev as the new head of the reversed linked list

        var prev: ListNode? = nil
        var curr = head
        var next: ListNode? = nil

        while curr != nil {
            next = curr?.next
            curr?.next = prev
            prev = curr
            curr = next
        }

        return prev
    }
}
