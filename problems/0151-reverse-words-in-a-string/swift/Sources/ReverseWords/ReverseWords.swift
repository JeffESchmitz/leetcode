// Promise: the input contains at least one word; it is not empty or all spaces.
public struct Solution {
    public init() {}

    public func reverseWords(_ s: String) -> String {
    // 1. Split the input into words, ignoring empty parts from spaces.
    // 2. Reverse the order of the words.
    // 3. Join the words exactly one space between them.
    s.split(separator: " ")
        .reversed()
        .joined(separator: " ")
    }
}
