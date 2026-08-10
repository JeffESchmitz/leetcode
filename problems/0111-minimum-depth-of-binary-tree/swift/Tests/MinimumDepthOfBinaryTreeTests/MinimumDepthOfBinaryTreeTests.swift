import Testing
@testable import MinimumDepthOfBinaryTree

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

/// The two implementations, so every fixture below guards both.
///
/// An enum rather than an array of closures: `@Test(arguments:)` requires its
/// values to be `Sendable`, which a bare enum gets for free and a closure over a
/// non-`Sendable` `TreeNode` does not. It also gives each parameterized run a
/// readable name in the test output.
enum Implementation: CaseIterable {
    case recursiveDFS
    case iterativeBFS

    func minDepth(_ root: TreeNode?) -> Int {
        let solution = Solution()

        switch self {
        case .recursiveDFS:
            return solution.minDepth(root)
        case .iterativeBFS:
            return solution.minDepthBFS(root)
        }
    }
}

@Suite("Minimum Depth of Binary Tree")
struct MinimumDepthOfBinaryTreeTests {
    @Test("example 1", arguments: Implementation.allCases)
    func example1(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([3, 9, 20, nil, nil, 15, 7])) == 2)
    }

    @Test("example 2", arguments: Implementation.allCases)
    func example2(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([2, nil, 3, nil, 4, nil, 5, nil, 6])) == 5)
    }

    @Test("empty tree", arguments: Implementation.allCases)
    func emptyTree(_ implementation: Implementation) {
        #expect(implementation.minDepth(nil) == 0)
    }

    @Test("single node", arguments: Implementation.allCases)
    func singleNode(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([1])) == 1)
    }

    @Test("root has only a left child", arguments: Implementation.allCases)
    func rootWithOnlyLeftChild(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([1, 2])) == 2)
    }

    @Test("root has only a right child", arguments: Implementation.allCases)
    func rootWithOnlyRightChild(_ implementation: Implementation) {
        // Mirror of the case above, so neither side can be favored by accident.
        #expect(implementation.minDepth(makeTree([1, nil, 2])) == 2)
    }

    @Test("both children present, both leaves", arguments: Implementation.allCases)
    func bothChildrenAreLeaves(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([1, 2, 3])) == 2)
    }

    @Test("perfect tree", arguments: Implementation.allCases)
    func perfectTree(_ implementation: Implementation) {
        #expect(implementation.minDepth(makeTree([1, 2, 3, 4, 5, 6, 7])) == 3)
    }

    @Test("shallower leaf on the right", arguments: Implementation.allCases)
    func shallowerLeafOnTheRight(_ implementation: Implementation) {
        // 1 → 3 is a leaf at depth 2, while 1 → 2 → 4 → 5 runs to depth 4.
        #expect(implementation.minDepth(makeTree([1, 2, 3, 4, nil, nil, nil, 5])) == 2)
    }

    @Test("shallower leaf on the left", arguments: Implementation.allCases)
    func shallowerLeafOnTheLeft(_ implementation: Implementation) {
        // Mirror of the case above.
        #expect(implementation.minDepth(makeTree([1, 2, 3, nil, nil, 4, nil, nil, 5])) == 2)
    }

    @Test("interior node with one child, on the left", arguments: Implementation.allCases)
    func interiorSingleChildOnTheLeft(_ implementation: Implementation) {
        // Node 2 has a left child and no right child; every leaf sits at depth 3.
        #expect(implementation.minDepth(makeTree([1, 2, 3, 4, nil, 5, 6])) == 3)
    }

    @Test("interior node with one child, on the right", arguments: Implementation.allCases)
    func interiorSingleChildOnTheRight(_ implementation: Implementation) {
        // Mirror: node 3 has a right child and no left child.
        #expect(implementation.minDepth(makeTree([1, 2, 3, 4, 5, nil, 6])) == 3)
    }

    @Test("left-skewed chain", arguments: Implementation.allCases)
    func leftSkewedChain(_ implementation: Implementation) {
        // A degenerate tree with exactly one leaf, so min and max agree.
        #expect(implementation.minDepth(makeTree([1, 2, nil, 3, nil, 4, nil, 5])) == 5)
    }

    @Test("right-skewed chain", arguments: Implementation.allCases)
    func rightSkewedChain(_ implementation: Implementation) {
        let root = TreeNode(1)
        var tail = root
        for value in 2...5 {
            let node = TreeNode(value)
            tail.right = node
            tail = node
        }

        #expect(implementation.minDepth(root) == 5)
    }

    @Test("negative values", arguments: Implementation.allCases)
    func negativeValues(_ implementation: Implementation) {
        // Values range down to -1000; depth is about structure, never about `val`.
        #expect(implementation.minDepth(makeTree([-10, -100, -20, nil, nil, -30, nil])) == 2)
    }

    @Test("tall degenerate chain", arguments: Implementation.allCases)
    func tallDegenerateChain(_ implementation: Implementation) {
        // Deep enough to be a real stack-depth question, deliberately short of
        // the constraints' 10^5 ceiling: a test thread's stack is far smaller
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

        #expect(implementation.minDepth(root) == 2_000)
    }

    @Test("one shallow leaf hidden under a very deep tree", arguments: Implementation.allCases)
    func shallowLeafUnderDeepTree(_ implementation: Implementation) {
        // The whole left side is a 1,000-node chain; the right child is a leaf.
        // The answer is 2, and nothing about the left side can change that.
        // Both implementations must answer 2 — but only BFS answers it without
        // walking the chain, which is the entire argument for BFS on this problem.
        let root = TreeNode(0)
        var tail = root
        for value in 1...1_000 {
            let node = TreeNode(value)
            tail.left = node
            tail = node
        }
        root.right = TreeNode(-1)

        #expect(implementation.minDepth(root) == 2)
    }

    @Test("the level-order builder itself is trustworthy")
    func builderSanityCheck() {
        // Every fixture above leans on `makeTree`, so it gets one direct check:
        // a fixture failing should mean the solution is wrong, not the harness.
        let root = makeTree([1, 2, 3, 4, nil, 5, 6])

        #expect(root?.val == 1)
        #expect(root?.left?.val == 2)
        #expect(root?.left?.left?.val == 4)
        #expect(root?.left?.right == nil)
        #expect(root?.right?.val == 3)
        #expect(root?.right?.left?.val == 5)
        #expect(root?.right?.right?.val == 6)
    }
}
