# 202. Happy Number

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/happy-number/

A happy number is defined by repeatedly replacing the number with the sum of the squares of its digits until it reaches 1, or loops endlessly in a cycle that does not include 1. Determine whether a given integer is happy.

## Approach

Track visited values while repeatedly applying the digit-square-sum transform.
Hit `1` → happy. See a value twice → non-1 cycle → not happy. This is **cycle
detection on an implicit functional path** (each value has one successor), the same
shape as [141. Linked List Cycle](../0141-linked-list-cycle/README.md) with
`next(x)` instead of `node.next`.

After roughly one transform, values live in a small finite box (worst-case sum of
squared digits for a 10-digit number is on the order of hundreds), so a repeat is
inevitable if `1` never appears — pigeonhole + determinism, not a timeout.

- **Set version (what we shipped):** O(log n)-ish time from digit work / short
  chain; visited set size bounded by the box → O(1)-bounded space in practice,
  higher memory on the judge chart than Floyd.
- **Optional follow-up:** Floyd tortoise/hare — same cycle idea, true O(1) extra
  space, no set.

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
