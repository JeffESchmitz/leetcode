// LeetCode's provided binary-tree node, verbatim, so solutions paste back into
// the judge unchanged. A class (not a struct) because a tree is a graph of
// references — value semantics would copy subtrees on every assignment, and a
// struct cannot contain a stored property of its own type.
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?

    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }

    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }

    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

public struct Solution {
    public init() {}

    public func maxDepth(_ root: TreeNode?) -> Int {
        // nil is the base case, not a defensive check: it is where every branch ends
        guard let root else {
            return 0
        }

        let leftDepth = maxDepth(root.left)
        let rightDepth = maxDepth(root.right)

        return 1 + max(leftDepth, rightDepth)
    }
}
