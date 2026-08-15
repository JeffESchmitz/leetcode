# 202. Happy Number

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/happy-number/

A happy number is defined by repeatedly replacing the number with the sum of the squares of its digits until it reaches 1, or loops endlessly in a cycle that does not include 1. Determine whether a given integer is happy.

## Approach

We will track visited values while repeatedly applying the digit-square transformation. If we ever see a value twice, we have entered a cycle and the number is not happy. If we reach 1, it is happy. This is a cycle-detection problem with O(n) time in the number of transformation steps and O(k) space for the visited set, where k is the number of unique values encountered before termination.

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

- **Python** —
- **Java** —
- **Kotlin** —
- **Rust** —
- **Go** —
