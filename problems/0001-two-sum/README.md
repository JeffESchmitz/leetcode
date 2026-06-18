# 1. Two Sum

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/two-sum/

Given an array of integers `nums` and an integer `target`, return the indices of
the two numbers that add up to `target`. Exactly one solution exists and the same
element may not be used twice.

## Approach

Single pass with a hash map of `value -> index`. For each `n`, check whether
`target - n` has already been seen; if so, return the stored index paired with the
current index. O(n) time, O(n) space.

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
