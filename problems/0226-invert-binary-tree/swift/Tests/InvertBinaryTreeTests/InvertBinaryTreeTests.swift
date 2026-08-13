import Testing
@testable import InvertBinaryTree

/// Builds a tree from LeetCode's level-order notation, where `nil` marks an
/// absent child — so a fixture below reads exactly like the input on the
/// problem page (`[4, 2, 7, 1, 3, 6, 9]`).
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

/// The inverse of `makeTree`: serializes back to LeetCode's level-order notation.
///
/// The answer to this problem is a *tree*, not a number, so the fixtures need a
/// way to state an expected tree that reads like the problem page. Round-tripping
/// through this notation gives `#expect(levelOrder(result) == [4, 7, 2, 9, 6, 3, 1])`,
/// which is exactly what LeetCode prints.
///
/// Trailing `nil`s are trimmed, matching LeetCode's own convention — it writes
/// `[1, null, 2]`, not `[1, null, 2, null, null]`.
private func levelOrder(_ root: TreeNode?) -> [Int?] {
    guard let root else { return [] }

    var result: [Int?] = [root.val]
    var queue = [root]
    var head = 0

    while head < queue.count {
        let node = queue[head]
        head += 1

        for child in [node.left, node.right] {
            result.append(child?.val)

            if let child {
                queue.append(child)
            }
        }
    }

    while result.last == .some(nil) {
        result.removeLast()
    }

    return result
}

@Suite("Invert Binary Tree")
struct InvertBinaryTreeTests {
    private let solution = Solution()

    @Test("example 1")
    func example1() {
        let inverted = solution.invertTree(makeTree([4, 2, 7, 1, 3, 6, 9]))

        #expect(levelOrder(inverted) == [4, 7, 2, 9, 6, 3, 1])
    }

    @Test("example 2")
    func example2() {
        let inverted = solution.invertTree(makeTree([2, 1, 3]))

        #expect(levelOrder(inverted) == [2, 3, 1])
    }

    @Test("empty tree")
    func emptyTree() {
        #expect(solution.invertTree(nil) == nil)
    }

    @Test("single node")
    func singleNode() {
        let inverted = solution.invertTree(makeTree([1]))

        #expect(levelOrder(inverted) == [1])
    }

    @Test("root has only a left child")
    func rootWithOnlyLeftChild() {
        // The child has to change sides, which is the smallest visible inversion.
        let inverted = solution.invertTree(makeTree([1, 2]))

        #expect(levelOrder(inverted) == [1, nil, 2])
    }

    @Test("root has only a right child")
    func rootWithOnlyRightChild() {
        // Mirror of the case above, so neither direction can be favored.
        let inverted = solution.invertTree(makeTree([1, nil, 2]))

        #expect(levelOrder(inverted) == [1, 2])
    }

    @Test("left-skewed chain becomes right-skewed")
    func leftSkewedChain() {
        let inverted = solution.invertTree(makeTree([1, 2, nil, 3, nil, 4]))

        #expect(levelOrder(inverted) == [1, nil, 2, nil, 3, nil, 4])
    }

    @Test("right-skewed chain becomes left-skewed")
    func rightSkewedChain() {
        let inverted = solution.invertTree(makeTree([1, nil, 2, nil, 3, nil, 4]))

        #expect(levelOrder(inverted) == [1, 2, nil, 3, nil, 4])
    }

    @Test("lopsided tree")
    func lopsidedTree() {
        // Node 2 keeps a child while node 3 has none, so the asymmetry has to
        // survive the swap rather than being flattened by it.
        let inverted = solution.invertTree(makeTree([1, 2, 3, 4, nil, nil, nil, 5]))

        #expect(levelOrder(inverted) == [1, 3, 2, nil, nil, nil, 4, nil, 5])
    }

    @Test("negative values")
    func negativeValues() {
        // Inversion rearranges structure and never touches `val`.
        let inverted = solution.invertTree(makeTree([-10, -100, -20, nil, nil, -30]))

        #expect(levelOrder(inverted) == [-10, -20, -100, nil, -30])
    }

    @Test("a tree that is its own mirror is unchanged")
    func symmetricTreeIsUnchanged() {
        // Same shape and same values on both sides: inverting is a no-op, which
        // catches a solution that swaps one level too many or too few.
        let inverted = solution.invertTree(makeTree([1, 2, 2, 3, 3, 3, 3]))

        #expect(levelOrder(inverted) == [1, 2, 2, 3, 3, 3, 3])
    }

    @Test("inverting twice restores the original")
    func doubleInversionIsIdentity() {
        // Inversion is its own inverse. This holds for any tree, so it is the
        // one property worth checking rather than a single hand-computed answer.
        let original = levelOrder(makeTree([4, 2, 7, 1, 3, 6, 9]))
        let roundTripped = levelOrder(
            solution.invertTree(solution.invertTree(makeTree([4, 2, 7, 1, 3, 6, 9])))
        )

        #expect(roundTripped == original)
    }

    @Test("returns the root it was given")
    func returnsTheSameRoot() {
        // LeetCode's signature returns a tree, so a solution could build a new
        // one — but the expected answer keeps the root's identity, and callers
        // holding the original reference should see the inverted tree.
        let root = makeTree([4, 2, 7, 1, 3, 6, 9])
        let inverted = solution.invertTree(root)

        #expect(inverted?.val == root?.val)
        #expect(levelOrder(root) == [4, 7, 2, 9, 6, 3, 1])
    }

    @Test("tall degenerate chain")
    func tallDegenerateChain() {
        // Deep enough to be a real stack-depth question. The constraints cap at
        // 100 nodes, so this is far past anything the judge will send — it is
        // here to say what the implementation can survive, not what it must.
        let root = TreeNode(0)
        var tail = root
        for value in 1..<2_000 {
            let node = TreeNode(value)
            tail.left = node
            tail = node
        }

        var walker = solution.invertTree(root)
        var seen = 0
        while let node = walker {
            #expect(node.val == seen)
            #expect(node.left == nil)
            seen += 1
            walker = node.right
        }

        #expect(seen == 2_000)
    }

    @Test("the level-order helpers are trustworthy")
    func helperSanityCheck() {
        // Every fixture above leans on makeTree and levelOrder, so they get one
        // direct check: a fixture failing should mean the solution is wrong,
        // not the harness.
        let root = makeTree([4, 2, 7, 1, 3, 6, 9])

        #expect(root?.val == 4)
        #expect(root?.left?.val == 2)
        #expect(root?.left?.left?.val == 1)
        #expect(root?.right?.right?.val == 9)

        // Round-trips exactly, including a shape with holes in it
        #expect(levelOrder(root) == [4, 2, 7, 1, 3, 6, 9])
        #expect(levelOrder(makeTree([1, nil, 2])) == [1, nil, 2])
        #expect(levelOrder(makeTree([1, 2])) == [1, 2])
        #expect(levelOrder(nil) == [])
    }
}
