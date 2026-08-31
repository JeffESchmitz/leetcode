import Collections

/// LeetCode 1046. Last Stone Weight
/// https://leetcode.com/problems/last-stone-weight/
public struct Solution {
    public init() {}

    public func lastStoneWeight(_ stones: [Int]) -> Int {
        var heap = Heap(stones)

        while heap.count > 1 {
            let y = heap.popMax()!
            let x = heap.popMax()!
            if y != x {
                heap.insert(y - x)
            }
        }

        return heap.popMax() ?? 0
    }
}
