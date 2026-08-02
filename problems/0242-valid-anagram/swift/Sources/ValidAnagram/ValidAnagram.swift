/// LeetCode 242. Valid Anagram
/// https://leetcode.com/problems/valid-anagram/
///
/// Returns whether `t` is an anagram of `s` — the same multiset of characters
/// in a different order.
public struct Solution {
    public init() {}

    public func isAnagram(_ s: String, _ t: String) -> Bool {
        // Different lengths can never be anagrams; skip the counting entirely.
        guard s.count == t.count else {
            return false
        }

        func frequencies(_ str: String) -> [Character: Int] {
            str.reduce(into: [:]) { counts, char in
                counts[char, default: 0] += 1
            }
        }

        return frequencies(s) == frequencies(t)
    }
}
