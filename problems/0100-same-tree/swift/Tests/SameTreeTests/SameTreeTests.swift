import Testing
@testable import SameTree

/// Builds a tree from LeetCode's level-order notation, where `nil` marks an
/// absent child — so a fixture below reads exactly like the input on the
/// problem page (`[1, 2, 3]`).
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

@Suite("Same Tree")
struct SameTreeTests {
    private let solution = Solution()

    // MARK: - Examples from the problem page

    @Test("example 1: identical trees")
    func example1() {
        #expect(solution.isSameTree(makeTree([1, 2, 3]), makeTree([1, 2, 3])) == true)
    }

    @Test("example 2: same values, different shape")
    func example2() {
        // [1,2] puts the 2 on the left; [1,null,2] puts it on the right.
        #expect(solution.isSameTree(makeTree([1, 2]), makeTree([1, nil, 2])) == false)
    }

    @Test("example 3: same shape, different values")
    func example3() {
        #expect(solution.isSameTree(makeTree([1, 2, 1]), makeTree([1, 1, 2])) == false)
    }

    // MARK: - Edge cases

    @Test("both trees empty")
    func bothEmpty() {
        // The constraint floor is 0 nodes — and the two nils are structurally
        // identical, so this is true, not false.
        #expect(solution.isSameTree(nil, nil) == true)
    }

    @Test("left empty, right not")
    func leftEmpty() {
        #expect(solution.isSameTree(nil, makeTree([1])) == false)
    }

    @Test("right empty, left not")
    func rightEmpty() {
        // Mirror of the case above, so neither argument order can be favored.
        #expect(solution.isSameTree(makeTree([1]), nil) == false)
    }

    @Test("single node, same value")
    func singleNodeSame() {
        #expect(solution.isSameTree(makeTree([1]), makeTree([1])) == true)
    }

    @Test("single node, different value")
    func singleNodeDifferent() {
        #expect(solution.isSameTree(makeTree([1]), makeTree([2])) == false)
    }

    @Test("identical skewed chains")
    func identicalSkewedChains() {
        #expect(solution.isSameTree(makeTree([1, 2, nil, 3]), makeTree([1, 2, nil, 3])) == true)
    }

    @Test("chains skewed opposite directions")
    func oppositeSkewedChains() {
        // Same three values in the same reading order — only the shape differs.
        #expect(solution.isSameTree(makeTree([1, 2, nil, 3]), makeTree([1, nil, 2, nil, 3])) == false)
    }

    @Test("difference is deep in the tree")
    func deepDifference() {
        // The mismatch sits at the bottom-right leaf; every node above it matches.
        #expect(solution.isSameTree(makeTree([1, 2, 3, 4, 5, 6, 7]), makeTree([1, 2, 3, 4, 5, 6, 8])) == false)
    }

    @Test("one tree is a subtree of the other")
    func subtreeMismatch() {
        // q is exactly p's left subtree — equal everywhere p has nodes, but p
        // has nodes q does not.
        #expect(solution.isSameTree(makeTree([1, 2, 3]), makeTree([2])) == false)
    }

    @Test("negative values match")
    func negativeValues() {
        // Constraints allow -10^4; the comparison must not assume positives.
        #expect(solution.isSameTree(makeTree([-1, -2]), makeTree([-1, -2])) == true)
    }
}
