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
