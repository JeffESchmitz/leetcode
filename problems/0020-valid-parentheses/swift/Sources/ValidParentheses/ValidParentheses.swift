/// LeetCode 20. Valid Parentheses
///
/// Returns whether the input string `s` contains valid parentheses.
public func isValid(_ s: String) -> Bool {

    // Maps each closing bracket to the opening bracket it must match.
    let closingToOpeningBracket: [Character: Character] = [
        ")": "(",
        "]": "[",
        "}": "{"
    ]

    // Open brackets waiting to be closed, most recent on top.
    var openBrackets: [Character] = []

    for character in s {
        guard let expectedOpener = closingToOpeningBracket[character] else {
            // Not a closer, so it's an opener — remember it for later.
            openBrackets.append(character)
            continue
        }

        // `character` is a closer: the most recently opened bracket must match it.
        if let poppedOpener = openBrackets.popLast() {
            if poppedOpener != expectedOpener {
                return false
            }
        } else {
            // A closer with nothing open to match it.
            return false
        }
    }

    // Valid only if every opener found a matching closer.
    return openBrackets.isEmpty
}