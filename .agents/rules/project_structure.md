# Project Structure Rules for LeetCode Dojo

Follow these layout and execution conventions when editing or creating code in this repository.

## Directory Layout
The repository is structured as a **problem-first, language-second** translation dojo. Each problem has a main directory, under which each language has a self-contained subdirectory:

```text
problems/
  NNNN-slug-name/
    README.md          # Pretty title (e.g. "1. Two Sum"), approach, per-language notes
    swift/             # Source of truth (usually solved first)
    python/            # Translation target
    go/                # Translation target
    rust/              # Translation target
    java/              # Translation target
    kotlin/            # Translation target
    cpp/               # Translation target
```

### Constraints:
*   **Directory Naming:** Folder names must be toolchain-safe: zero-padded `NNNN-slug-name` for problems, and lowercase language names for directories (`swift`, `python`, `java`, `kotlin`, `rust`, `go`, `cpp`, `c`, `javascript`, `typescript`).
*   **Independence:** Each leaf language directory is fully self-contained and run independently. There is no top-level module or shared build system uniting different languages.
*   **Signature:** Solutions must match the LeetCode function signature so they can be easily pasted into the online judge.

---

## Test Execution Guide
To run and verify tests for a specific language leaf, run the respective test harness from within that language's directory:

| Language | Test Command / Harness |
|---|---|
| **Swift** | `swift test` (using SwiftPM + Swift Testing) |
| **Python** | `python3 -m unittest` (stdlib `unittest`) |
| **Java** | `java -ea Solution.java` (single-file + assertions enabled) |
| **Kotlin** | `./gradlew test` (Gradle + `kotlin.test`) |
| **Rust** | `cargo test` (Cargo inline tests) |
| **Go** | `go test ./...` |

Always write example and edge-case tests matching the native idiom of that language.

---

## Scaffold / Add Problem Flow
When helping the user add a new LeetCode problem, follow this exact sequence:
1.  Create `problems/NNNN-slug/README.md` with:
    *   Display title (e.g., `# 1. Two Sum`)
    *   LeetCode problem URL
    *   Algorithmic approach
    *   Empty per-language idiom notes section
2.  Help the user solve the problem in the source language (usually Swift) first under Coach Mode.
3.  Add separate leaf folders for other languages, translating the solution and verifying via the language's test command.
