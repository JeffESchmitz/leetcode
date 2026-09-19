/// LeetCode 3. Longest Substring Without Repeating Characters
/// https://leetcode.com/problems/longest-substring-without-repeating-characters/
public struct Solution {
    public init() {}

    public func lengthOfLongestSubstring(_ s: String) -> Int {
        var maxLength = 0
        var lastSeen = [Character: Int]()
        var left = 0

        for (right, char) in s.enumerated() {
            // If this character was last seen inside the current window, jump left
            // just past that earlier copy. The `lastIndex >= left` check is the
            // ratchet: a stale index already behind left must not pull left backward.
            if let lastIndex = lastSeen[char], lastIndex >= left {
                left = lastIndex + 1
            }
            lastSeen[char] = right
            maxLength = max(maxLength, right - left + 1)
        }

        return maxLength
    }
}
