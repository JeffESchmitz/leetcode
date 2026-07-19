# 70. Climbing Stairs

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/climbing-stairs/

You are climbing a staircase. It takes `n` steps to reach the top.
Each time you can either climb `1` or `2` steps.
In how many distinct ways can you climb to the top?

## Approach

This is a counting problem, so the key is to count how many different ways there are to reach each stair.

A path to stair `n` must end in one of two ways:

- it came from stair `n - 1` with a final `1`-step move, or
- it came from stair `n - 2` with a final `2`-step move.

That means the number of ways to reach stair `n` is the sum of the number of ways to reach the two previous stairs:

$$
\text{ways}(n) = \text{ways}(n - 1) + \text{ways}(n - 2)
$$

This is the recurrence for the problem.

Why does the addition work? Because every valid path to stair `n` must end in exactly one of those two cases. The two groups of paths do not overlap, so we can add their counts together.

The base cases are simple:

- `ways(1) = 1`
- `ways(2) = 2`

From there, we can build upward. Instead of recomputing the full answer from scratch for every stair, we use dynamic programming and keep only the two most recent values:

- `prev2` stores the answer for the stair two steps behind us
- `prev1` stores the answer for the previous stair

Then for each stair from `3` up to `n`, we compute the next answer as:

```swift
let current = prev1 + prev2
```

After that, we shift the values forward so the next iteration uses the new pair of known answers.

That is why the loop starts at `3`: the answers for stairs `1` and `2` are already known, so the first new value we need to compute is for stair `3`.

This is a bottom-up dynamic programming solution. We do not need a full array of all answers. We only need the last two values because each new answer depends only on those two previous ones.

At the end of the loop, `prev1` holds the answer for the target stair `n`, so we return it.

A small worked example makes this easier to see. Suppose we want to know the number of ways to reach stair `5`.

We already know:

- `ways(1) = 1`
- `ways(2) = 2`

Now we compute the next values:

- `ways(3) = ways(2) + ways(1) = 2 + 1 = 3`
- `ways(4) = ways(3) + ways(2) = 3 + 2 = 5`
- `ways(5) = ways(4) + ways(3) = 5 + 3 = 8`

So the answer for stair `5` is `8`.

This is exactly what the loop is doing. It starts with the known answers for stairs `1` and `2`, then repeatedly builds the next answer from the previous two answers. That is why only two variables are needed.

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
