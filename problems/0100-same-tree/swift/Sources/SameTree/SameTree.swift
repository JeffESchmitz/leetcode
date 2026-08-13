// LeetCode's provided binary-tree node, verbatim, so solutions paste back into
// the judge unchanged. Same definition as in 104, 111, and 226; each leaf is
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

    public func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        guard let p, let q else {
            return p == nil && q == nil
        }
        return p.val == q.val
            && isSameTree(p.left, q.left)
            && isSameTree(p.right, q.right)
    }
}
