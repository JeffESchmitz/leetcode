// LeetCode's provided binary-tree node, verbatim, so solutions paste back into
// the judge unchanged. Same definition as in 104; each leaf is self-contained.
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

    public func minDepth(_ root: TreeNode?) -> Int {
        // nil is the base case, not a defensive check: it is where every branch ends
        guard let root else {
            return 0
        }

        let leftDepth = minDepth(root.left)
        let rightDepth = minDepth(root.right)

        // min is only meaningful when both numbers describe real paths; a missing
        // child contributes a phantom 0 that would win every min it entered
        guard 
            root.left != nil, 
            root.right != nil 
        else {
            return 1 + max(leftDepth, rightDepth)
        }

        return 1 + min(leftDepth, rightDepth)
    }

    /// Breadth-first, level by level, returning at the first leaf reached.
    ///
    /// The better fit for this problem: BFS visits in order of distance from the
    /// root, so the first leaf it meets is necessarily the shallowest one and
    /// nothing still queued can beat it. On a tree with a shallow leaf and a deep
    /// opposite side, this answers in a handful of visits where the recursive
    /// version walks the entire far subtree before discarding it.
    public func minDepthBFS(_ root: TreeNode?) -> Int {
        guard let root else {
            return 0
        }

        var level = [root]
        var depth = 0

        while !level.isEmpty {
            depth += 1
            var nextLevel: [TreeNode] = []

            for node in level {
                // Level order guarantees this is the shallowest leaf in the tree
                if node.left == nil && node.right == nil {
                    return depth
                }

                if let left = node.left {
                    nextLevel.append(left)
                }

                if let right = node.right {
                    nextLevel.append(right)
                }
            }

            level = nextLevel
        }

        // Unreachable: every non-empty finite tree contains a leaf, so the loop
        // above always returns. The compiler cannot know that.
        return depth
    }
}
