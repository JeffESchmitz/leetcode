/// LeetCode 1. Two Sum
///
/// Returns the indices of the two numbers in `nums` that add up to `target`.
/// Single pass with a `value -> index` map. O(n) time, O(n) space.
public func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (i, n) in nums.enumerated() {
        if let j = seen[target - n] {
            return [j, i]
        }
        seen[n] = i
    }
    return []
}
