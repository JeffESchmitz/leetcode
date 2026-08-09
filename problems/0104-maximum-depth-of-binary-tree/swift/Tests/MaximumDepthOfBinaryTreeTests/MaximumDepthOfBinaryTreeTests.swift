import Testing
@testable import MaximumDepthOfBinaryTree

/// Builds a tree from LeetCode's level-order notation, where `nil` marks an
/// absent child — so a fixture below reads exactly like the input on the
/// problem page (`[3, 9, 20, nil, nil, 15, 7]`).
///
/// Level order means children are consumed in the same order their parents were
/// discovered, which is a queue. Absent children are skipped rather than
/// enqueued: a missing node has no slots of its own to fill.
private func makeTree(_ values: [Int?]) -> TreeNode? {
    guard let first = values.first, let rootValue = first else { return nil }

    let root = TreeNode(rootValue)
    var queue = [root]
    // Read cursor into `queue`; dropping from the front of an Array is O(n),
    // and this only ever moves forward.
    var parent = 0
    var next = 1

    while parent < queue.count && next < values.count {
        let node = queue[parent]
        parent += 1

        if next < values.count {
            if let value = values[next] {
                let child = TreeNode(value)
                node.left = child
                queue.append(child)
            }
            next += 1
        }

        if next < values.count {
            if let value = values[next] {
                let child = TreeNode(value)
                node.right = child
                queue.append(child)
            }
            next += 1
        }
    }

    return root
}

@Suite("Maximum Depth of Binary Tree")
struct MaximumDepthOfBinaryTreeTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        #expect(solution.maxDepth(makeTree([3, 9, 20, nil, nil, 15, 7])) == 3)
    }

    @Test("example 2")
    func example2() {
        #expect(solution.maxDepth(makeTree([1, nil, 2])) == 2)
    }

    @Test("empty tree")
    func emptyTree() {
        #expect(solution.maxDepth(nil) == 0)
    }

    @Test("single node")
    func singleNode() {
        #expect(solution.maxDepth(makeTree([1])) == 1)
    }

    @Test("left-skewed chain")
    func leftSkewedChain() {
        // A degenerate tree — a linked list wearing tree clothes. Depth == n.
        #expect(solution.maxDepth(makeTree([1, 2, nil, 3, nil, 4, nil, 5])) == 5)
    }

    @Test("right-skewed chain")
    func rightSkewedChain() {
        let root = TreeNode(1)
        var tail = root
        for value in 2...5 {
            let node = TreeNode(value)
            tail.right = node
            tail = node
        }

        #expect(solution.maxDepth(root) == 5)
    }

    @Test("perfect tree")
    func perfectTree() {
        #expect(solution.maxDepth(makeTree([1, 2, 3, 4, 5, 6, 7])) == 3)
    }

    @Test("deeper branch on the left")
    func deeperOnTheLeft() {
        // The left subtree wins. Catches a solution that always follows `right`,
        // or one that returns the first depth it reaches instead of the max.
        #expect(solution.maxDepth(makeTree([1, 2, 3, 4, nil, nil, nil, 5])) == 4)
    }

    @Test("deeper branch on the right")
    func deeperOnTheRight() {
        // Mirror of the case above, so neither side can be favored by accident.
        #expect(solution.maxDepth(makeTree([1, 2, 3, nil, nil, nil, 4, nil, 5])) == 4)
    }

    @Test("deepest branch buried in the middle")
    func deepestBranchInTheMiddle() {
        // Depth 4 hangs off an interior node, reached via left-then-right —
        // neither outer edge of the tree.
        #expect(solution.maxDepth(makeTree([1, 2, 3, nil, 4, 5, nil, nil, 6])) == 4)
    }

    @Test("negative values")
    func negativeValues() {
        // Values range down to -100; depth is about structure, never about `val`.
        #expect(solution.maxDepth(makeTree([-10, -100, -20, nil, nil, -30, nil])) == 3)
    }

    @Test("tall degenerate chain")
    func tallDegenerateChain() {
        // Deep enough to be a real stack-depth question, deliberately short of
        // the constraints' 10^4 ceiling: a test thread's stack is far smaller
        // than the main thread's, so a full-height chain can abort a correct
        // recursive solution here while passing on the judge. Where the true
        // ceiling bites is a discussion for the README, not a red test.
        let root = TreeNode(0)
        var tail = root
        for value in 1..<2_000 {
            let node = TreeNode(value)
            tail.left = node
            tail = node
        }

        #expect(solution.maxDepth(root) == 2_000)
    }

    @Test("the level-order builder itself is trustworthy")
    func builderSanityCheck() {
        // Every fixture above leans on `makeTree`, so it gets one direct check:
        // a fixture failing should mean the solution is wrong, not the harness.
        let root = makeTree([3, 9, 20, nil, nil, 15, 7])

        #expect(root?.val == 3)
        #expect(root?.left?.val == 9)
        #expect(root?.left?.left == nil)
        #expect(root?.left?.right == nil)
        #expect(root?.right?.val == 20)
        #expect(root?.right?.left?.val == 15)
        #expect(root?.right?.right?.val == 7)
    }
}
