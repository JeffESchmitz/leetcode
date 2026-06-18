# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A **polyglot translation dojo** for LeetCode practice. Each problem is solved once
in a language Jeff thinks in (usually Swift), then translated into other languages
to learn their idioms. The algorithm is the warm-up; the practice is seeing how
each language expresses the same idea.

## Learning Focus (read this first)

This repo is for **sharpening algorithmic reasoning and learning languages by
translation — not ranking, contest scores, or speed leaderboards.** When helping
with a problem, optimize for Jeff's understanding, and guide rather than hand over
the answer (understand → identify solution(s) → pseudocode → code; let Jeff write
it unless he asks for the solution).

Two kinds of learning happen here:

- **Algorithmic** — solving the problem the first time, in the source language.
- **Idiomatic** — re-expressing a solved algorithm in a new language, the right way.

The things we measure (qualitatively, for reflection — not a scoreboard):

- **A) Mean Time to Understanding** the problem (what's asked, constraints, edge cases).
- **B) Mean Time to Identifying** a solution or solutions (ideally more than one, with tradeoffs).
- **C) Mean Time to Writing** the solution in pseudocode or actual code.
- **D) Idiom insights** — what each translation target made Jeff see.

**Default to Coach Mode.** When working any problem, follow `COACH.md` — guide Jeff
with Socratic questions through understand → identify → pseudocode → code → reflect,
using the 8-step framework and the 5 teaching modes. Hand over the full solution
only if Jeff says "just show me."

## Structure

Problem-first, language-second. Each problem is a folder; each solution language is
a self-contained leaf beneath it.

```
problems/
  0001-two-sum/
    README.md          # display title ("1. Two Sum"), approach, per-language idiom notes
    swift/             # source of truth (solved first)
    python/  java/  kotlin/  rust/  go/
```

- **Folder names are toolchain-safe**: zero-padded `NNNN-kebab-title` for problems,
  lowercase language names for leaves (`swift python java kotlin rust go cpp c
  javascript typescript`). The pretty `1. Two Sum` display title lives in the
  problem README, never in the folder name.
- **No shared build.** Each leaf is independent and runs on its own terms — there is
  no top-level module unifying languages. Swift is the source of truth; the other
  leaves are translations of it.
- **Solution functions** match the LeetCode signature in each language so they can be
  pasted back into the judge.

## Running a leaf (from inside the leaf folder)

| Language | Harness | Run |
|----------|---------|-----|
| Swift  | SwiftPM + Swift Testing | `swift test` |
| Python | stdlib `unittest`       | `python3 -m unittest` |
| Java   | single-file + `-ea`     | `java -ea Solution.java` |
| Kotlin | Gradle + `kotlin.test`  | `./gradlew test` (or `./gradlew run`) |
| Rust   | `cargo test` (inline)   | `cargo test` |
| Go     | `go test`               | `go test ./...` |

Each language re-expresses the example + edge-case tests in its own native test idiom.

## Adding a problem

1. Create `problems/NNNN-slug/README.md` with the display title, LeetCode link,
   approach, and an empty per-language idiom-notes section.
2. Solve it first in the source language (usually `swift/`) under Coach Mode.
3. Add a leaf per translation target with the solution + tests in that language's
   native style; verify each with the command above.

> Note: the `lc` scaffolder (`cmd/lc/`) still emits the old Go-only layout — rewriting
> it to scaffold `problems/NNNN-slug/<lang>/` is a planned follow-up.
