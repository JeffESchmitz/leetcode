# 9. Palindrome Number

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/palindrome-number/

Given an integer `x`, return `true` if `x` is a palindrome, and `false` otherwise.

## Status

- **Completed:** Swift solution implemented and verified via `swift test`.

## Approach

**Digit Reversal via Base-10 Integer Arithmetic.**

Instead of converting the integer to a `String` (which allocates extra memory), reverse the digits using `% 10` and `/ 10`:

1. **Guard Edge Cases:**
   - Negative numbers are not palindromes (`x < 0` $\implies$ `false`).
   - Numbers ending in `0` (except `0` itself) are not palindromes (`x % 10 == 0 && x != 0` $\implies$ `false`).
2. **Reverse Digits:**
   - Maintain a `temp` copy of `x` and a `reversed` accumulator (initialized to `0`).
   - Loop while `temp > 0`:
     - Extract the last digit: `let lastDigit = temp % 10`
     - Append to reversed: `reversed = reversed * 10 + lastDigit`
     - Drop the last digit: `temp /= 10`
3. **Compare:**
   - Return `x == reversed`.

- **Time Complexity:** $O(\log_{10} x)$ digits $\le 10$ iterations $\implies O(1)$ constant time.
- **Space Complexity:** $O(1)$ auxiliary space.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |
| Python | stdlib `unittest`        | `python3 -m unittest` |
| Java   | single-file + `-ea`      | `java -ea Solution.java` |
| Kotlin | Gradle + `kotlin.test`   | `./gradlew test` (or `./gradlew run`) |
| Rust   | `cargo test` (inline)    | `cargo test` |
| Go     | `go test`                | `go test ./...` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** —
  - **Base-10 Math as a String Alternative:** `x % 10` extracts the ones digit by dropping all higher multiples of 10 ($d_n \cdot 10^n + \dots$), and `x / 10` drops the ones digit via Swift's truncating integer division. Accumulating via `reversed * 10 + digit` shifts existing digits left in base 10.
  - **Memory & Performance:** Operating purely on primitive `Int`s keeps state in CPU registers ($O(1)$ stack space) and avoids the heap allocation, ARC, and UTF-8 formatting cost of `String(number)`.
  - **Guard Clauses & Self-Documenting Naming:** Early exits with `guard number >= 0 else` and `guard number == 0 || number % 10 != 0 else` keep the happy path flat. Naming variables `remainingDigits` and `reversedNumber` makes the right-to-left digit draining mental model explicit.
  - **String Alternative (if needed):** `description.elementsEqual(description.reversed())` compares characters lazily against a reversed view without instantiating a second `String` allocation.
  - **Number Literals in Tests:** Swift supports digit separators (`1_234_554_321`) for readable 10-digit boundary test cases near `Int32.max`.
