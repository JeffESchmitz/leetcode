// LeetCode's provided binary-tree node, verbatim, so solutions paste back into
// the judge unchanged. Same definition as in 104 and 111; each leaf is
// self-contained.
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

    public func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard let root else {
            return nil
        }

        (root.left, root.right) = (root.right, root.left)
        root.left = invertTree(root.left)
        root.right = invertTree(root.right)
        return root
    }
}
