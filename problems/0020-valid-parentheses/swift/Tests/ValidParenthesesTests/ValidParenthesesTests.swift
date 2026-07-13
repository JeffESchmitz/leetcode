import Testing
@testable import ValidParentheses

@Suite
struct ValidParenthesesTests {
    @Test func example1() {
        #expect(isValid("()") == true)
    }

    @Test func example2() {
        #expect(isValid("()[]{}") == true)
    }

    @Test func example3() {
        #expect(isValid("(]") == false)
    }

    @Test func nestedValid() {
        #expect(isValid("([])") == true)
        #expect(isValid("{[()]}") == true)
    }

    @Test func singleCharacter() {
        #expect(isValid("(") == false)
        #expect(isValid("]") == false)
    }

    @Test func incorrectNesting() {
        #expect(isValid("([)]") == false)
    }

    @Test func unmatchedOpen() {
        #expect(isValid("(((") == false)
        #expect(isValid("(()") == false)
    }

    @Test func unmatchedClose() {
        #expect(isValid("))}") == false)
        #expect(isValid("())") == false)
    }
}
