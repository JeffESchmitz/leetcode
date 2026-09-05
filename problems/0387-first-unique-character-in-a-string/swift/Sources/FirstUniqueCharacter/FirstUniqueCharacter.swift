/// LeetCode 387. First Unique Character in a String
/// https://leetcode.com/problems/first-unique-character-in-a-string/
public struct Solution {
    public init() {}

    public func firstUniqChar(_ s: String) -> Int {
        let tally = s.reduce(into: [Character: Int]()) { counts, letter in
            counts[letter, default: 0] += 1
        }

        return s.enumerated()
            .first { tally[$0.element] == 1 }?.offset ?? -1
    }
}
