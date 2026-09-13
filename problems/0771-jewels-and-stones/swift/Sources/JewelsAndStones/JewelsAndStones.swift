/// LeetCode 771. Jewels and Stones
/// https://leetcode.com/problems/jewels-and-stones/
public struct Solution {
    public init() {}

    public func numJewelsInStones(_ jewels: String, _ stones: String) -> Int {
        // `jewels` is a group of kinds, and the only question asked of it is
        // "is this kind in the group?", so give it its real type. A Set makes
        // each check O(1) and removes duplicates on construction, so the
        // "all jewels are unique" constraint is no longer load-bearing.
        let jewelKinds = Set(jewels)

        // Count once per stone, not once per matching (jewel, stone) pair:
        // a stone is either a jewel or it is not. O(j) to build + O(s) to check.
        return stones.count(where: { jewelKinds.contains($0) })
    }
}
