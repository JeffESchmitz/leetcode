# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Go workspace for LeetCode practice. Single Go module (`leetcode`, Go 1.26). Each problem is a fully self-contained `package main` directory under `problems/`.

## Learning Focus (read this first)

This repo is for **learning Go and improving algorithmic reasoning — not ranking, contest scores, or speed leaderboards.** When helping with a problem, optimize for Jeff's understanding, and guide rather than hand over the answer (understand → identify solution(s) → pseudocode → code; let Jeff write it unless he asks for the solution).

The three things we measure (qualitatively, for reflection — not a scoreboard):

- **A) Mean Time to Understanding** the problem (what's asked, constraints, edge cases).
- **B) Mean Time to Identifying** a solution or solutions (ideally more than one, with tradeoffs).
- **C) Mean Time to Writing** the solution in pseudocode or actual code.

Reducing A/B/C over time is the real progress signal. After a problem, briefly reflect on where the time went.

## Commands

```bash
go test ./...                                      # run all problems' tests
go test ./problems/two-sum/                        # test one problem
go test -v -run TestTwoSum ./problems/two-sum/     # run a single test, verbose
go run ./problems/two-sum/                         # execute a problem's main()
go vet ./...                                        # vet all packages
gofmt -w problems/                                 # format
```

## Architecture & Conventions

- **Each problem is its own `package main` directory** — there is no shared library code. Because every directory is `package main`, solutions in different folders are isolated and cannot import each other; helper functions are duplicated per problem if needed.
- **Per-problem files**: `main.go` holds the solution function plus a `main()` for ad-hoc runs; `main_test.go` holds the table/case tests.
- **Naming**: newer problems use `pNNNN-kebab-title` (e.g. `p0003-longest-substring-without-repeating-characters`); a couple early ones use a bare slug (e.g. `two-sum`). Prefer the zero-padded `pNNNN-` form for new problems.
- **Solution functions** are named after the LeetCode problem (e.g. `twoSum`, not `solve`) and match the LeetCode signature so they can be pasted back into the judge.

## Adding a New Problem

Create `problems/pNNNN-title/` with a `main.go` (`package main`, solution fn + `main()`) and a `main_test.go` (`package main`, `Test...` covering the LeetCode examples plus edge cases). Then verify with `go test ./problems/pNNNN-title/`.
