public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

public func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    // Shadow the parameters with mutable copies (a Swift idiom): these are
    // cursors that walk down each input list as we consume its nodes.
    var list1 = list1
    var list2 = list2

    // Dummy-head technique: a throwaway node in front of the result lets the
    // loop always append via `tail.next`, with no special case for the first
    // node. `tail` is the last node of the merged list so far — it always
    // points at a real node (starting with `dummy`), so it is non-optional
    // by design; nil is not a state it can be in.
    let dummy = ListNode(0)
    var tail = dummy

    // Weave phase: while BOTH lists still have nodes, take whichever head is
    // smaller. `while let` exits the moment either cursor runs off the end.
    while let node1 = list1, let node2 = list2 {
        // Pick the smaller head and advance that list's cursor past it.
        // `<=` keeps the merge stable: on ties, list1's node goes first.
        let smaller: ListNode
        if node1.val <= node2.val {
            smaller = node1
            list1 = node1.next
        } else {
            smaller = node2
            list2 = node2.next
        }
        // Splice the winner onto the merged list and make it the new tail.
        // We relink the existing nodes rather than copying them — O(1) space.
        tail.next = smaller
        tail = smaller
    }

    // One list is exhausted. The survivor (possibly nil) is already sorted,
    // so splice the entire remainder on in one step instead of node-by-node.
    tail.next = list1 ?? list2

    // The real result starts after the dummy. If both inputs were empty this
    // is nil — exactly the right answer for merging two empty lists.
    return dummy.next
}
