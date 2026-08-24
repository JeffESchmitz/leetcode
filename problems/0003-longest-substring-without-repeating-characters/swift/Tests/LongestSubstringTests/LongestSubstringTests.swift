import Testing
@testable import LongestSubstring

@Suite("Longest Substring Without Repeating Characters")
struct LongestSubstringTests {
    private let solution = Solution()

    @Test("example 1: \"abcabcbb\" → \"abc\"")
    func example1() {
        #expect(solution.lengthOfLongestSubstring("abcabcbb") == 3)
    }

    @Test("example 2: \"bbbbb\" → \"b\"")
    func example2() {
        #expect(solution.lengthOfLongestSubstring("bbbbb") == 1)
    }

    @Test("example 3: \"pwwkew\" → \"wke\", not the subsequence \"pwke\"")
    func example3() {
        #expect(solution.lengthOfLongestSubstring("pwwkew") == 3)
    }

    @Test("empty string")
    func empty() {
        #expect(solution.lengthOfLongestSubstring("") == 0)
    }

    @Test("single space is a valid one-character substring")
    func singleSpace() {
        #expect(solution.lengthOfLongestSubstring(" ") == 1)
    }

    @Test("all characters unique: the whole string")
    func allUnique() {
        #expect(solution.lengthOfLongestSubstring("abcdef") == 6)
    }

    /// The classic trap. On seeing the second `d`, a naive jump sends the left
    /// edge back to index 1 — behind where it already stood — and the window
    /// silently re-admits the first `d`. The left edge must never move backward.
    @Test("\"dvdf\" → \"vdf\": the left edge must never move backward")
    func leftEdgeMustNotRetreat() {
        #expect(solution.lengthOfLongestSubstring("dvdf") == 3)
    }

    /// Same trap, different shape: by the time the second `a` arrives, the left
    /// edge has already passed it. A stale index must not drag the window back.
    @Test("\"abba\" → \"ab\": a stale index must not drag the window back")
    func staleIndexDoesNotDragWindowBack() {
        #expect(solution.lengthOfLongestSubstring("abba") == 2)
    }

    @Test("digits, symbols and spaces all count as characters")
    func mixedCharacterClasses() {
        #expect(solution.lengthOfLongestSubstring("a1! a1!") == 4)
    }

    @Test("best window sits at the very end")
    func bestWindowAtEnd() {
        #expect(solution.lengthOfLongestSubstring("aaaaabcdef") == 6)
    }

    @Test("case sensitivity: \"aA\" holds no repeat")
    func caseSensitive() {
        #expect(solution.lengthOfLongestSubstring("aA") == 2)
    }

    @Test("upper bound: 5 * 10^4 characters")
    func upperBound() {
        let s = String(repeating: "abcd", count: 12_500)
        #expect(solution.lengthOfLongestSubstring(s) == 4)
    }
}
