# leetcode — polyglot translation dojo

Solve each problem once in a language you think in (usually Swift), then translate
it into others to learn their idioms. The algorithm is the warm-up; the real
practice is seeing how a Rust, Python, or Kotlin developer expresses the same idea.

## Layout

Problem-first, language-second. Each problem is a folder; each solution language is
a self-contained leaf beneath it.

```
problems/
  0001-two-sum/
    README.md          # display title, approach, per-language idiom notes
    swift/             # source of truth (solved first)
    python/  java/  kotlin/  rust/  go/
```

Folder names are toolchain-safe (`0001-two-sum`, lowercase language dirs); the
pretty `1. Two Sum` title lives in the problem README.

## Workflow

1. Scaffold Swift leaf: `public struct Solution` + `@Suite` test struct, stubbing functions with `fatalError("... is not yet implemented")`.
2. Solve in Swift first — full 8-step process (see `COACH.md`).
3. Translate into each target language in its native IDE, leaning on the editor's
   inspections to learn the idiom.
4. Re-express the example + edge-case tests in that language's native test style.
5. Capture what surprised you in the problem README's idiom notes.

## Lessons that keep recurring

Cross-problem habits earned the hard way. Each links to the problem README where it
first showed up — the point of writing them here is to spot them *before* the next
problem rather than after.

- **Pick an iteration shape where the edge case cannot be expressed.** The best
  guard is the one you never write because the loop can't reach the bad state.
  `for num in nums` never enters on empty; `while low <= high` starts already
  crossed when `high = -1`. Sighted in
  [13. Roman to Integer](problems/0013-roman-to-integer/README.md),
  [217. Contains Duplicate](problems/0217-contains-duplicate/README.md), and
  [704. Binary Search](problems/0704-binary-search/README.md).
- **Ask of every constraint: hint about size, or promise the algorithm leans on?**
  A hint shapes what you can afford and is harmless to violate. A promise is
  load-bearing — violate it and you get a confident *wrong answer*, not a crash. And
  load-bearing promises are usually the ones you deliberately *don't* guard, because
  checking them costs more than the algorithm they enable. See
  [704](problems/0704-binary-search/README.md) (sortedness) and
  [217](problems/0217-contains-duplicate/README.md) (value bounds revoking a
  counting array).
- **Constraints are permissions, not just limits.** Reading one for what it *enables*
  is a different habit than reading it for what it forbids.
- **Pick data structures by operation frequency × cost.** Find the operation that
  runs `n` times, then ask which structure makes *that one* cheap.
- **Recursion for branching structures; loops for linear narrowing.** A recursion
  with a single subproblem — nothing to unwind, no results to merge on the way back
  up — is a loop wearing a costume, paying for stack frames it doesn't use.
  ([704](problems/0704-binary-search/README.md))
- **Move indices, not elements.** Slicing the surviving half into a new array is
  O(n) per level and silently destroys a log-time budget — and an index into a slice
  isn't the index the caller asked for.
- **Keep value space and index space apart.** Most binary-search bugs live in the
  confusion between "the number stored here" and "where it's stored."
- **Trace the *failing* input, not the passing one.** A found-target trace exits
  early and never shows how the algorithm gives up. The absent-target trace is where
  the termination condition reveals itself.
- **A local test may be stricter than the judge.** LeetCode's constraints say what
  you may optimize for, not what you may assume can't happen — the type system still
  lets a caller pass `[]`.
- **Judge percentiles are not all equal.** Runtime is signal. *Memory* percentile
  for an O(1)-space solution is process noise and moves between submissions of
  identical code. ([704](problems/0704-binary-search/README.md))

## Running a leaf

No shared build — each leaf runs on its own terms, from inside its folder:

| Language | Run |
|----------|-----|
| Swift  | `swift test` |
| Python | `python3 -m unittest` |
| Java   | `java -ea Solution.java` |
| Kotlin | `./gradlew test` (in the leaf) |
| Rust   | `cargo test` |
| Go     | `go test ./...` |

## Toolchains

Swift (Xcode), Python 3, Java 21, and Go come preinstalled on the dev Mac. Kotlin
(`brew install kotlin`) and Rust (`brew install rust`) are added as needed.
