# `lc` — LeetCode problem scaffolder for Go

**Date:** 2026-06-12
**Status:** Approved design, pre-implementation

## Goal

Make it one command to go from "I want to do problem X" to "GoLand is open with a
compiling, failing test and the problem text right there." Eliminate the manual
folder/file/signature/test-case typing.

## Command

A Go CLI living in this repo at `cmd/lc/`, installed globally as `lc` via
`go install ./cmd/lc`. `~/go/bin` is added to the fish PATH so `lc` works from
anywhere.

```
lc <thing> [--no-open] [--no-test] [--force]
```

### Input detection (`<thing>`)

`lc` auto-detects the argument type — no subcommand flags needed:

| Input             | Example                                             | Resolution |
|-------------------|-----------------------------------------------------|------------|
| `daily`           | `lc daily`                                           | GraphQL `activeDailyCodingChallengeQuestion` → slug |
| URL               | `lc https://leetcode.com/problems/two-sum/`          | regex extract slug from path |
| Number (all digits)| `lc 1`                                              | look up number→slug in cached problem list |
| Slug              | `lc two-sum`                                         | used directly as `titleSlug` |

Detection order: `daily` (literal) → looks-like-URL (`http`) → all-digits (number)
→ otherwise treat as slug.

### Flags

- `--no-open` — skip launching GoLand
- `--no-test` — skip the post-scaffold `go test` run
- `--force` — re-fetch and overwrite an existing problem folder (default is to
  never clobber an existing solution; without `--force` an existing folder is just
  opened)

## Data source

LeetCode's public GraphQL endpoint: `https://leetcode.com/graphql`.

1. **Question data** — query `question(titleSlug:)` for:
   - `questionFrontendId` (the human problem number)
   - `title`, `titleSlug`
   - `difficulty`
   - `content` (HTML description, examples, constraints)
   - `codeSnippets` (per-language starter code — we pick `langSlug == "golang"`)
   - `exampleTestcases` (newline-delimited raw inputs)
   - `isPaidOnly` (premium detection)
2. **Daily** — query `activeDailyCodingChallengeQuestion` → `question.titleSlug`,
   then run the question-data query.
3. **Number → slug map** — fetched from `https://leetcode.com/api/problems/all/`
   (JSON: `stat.frontend_question_id` → `stat.question__title_slug`), cached to
   `~/.cache/lc/problems.json`. Refetched if the cache is missing or the requested
   number isn't present.

No authentication: public problems and the daily challenge need no cookie.
Premium-locked problems (`isPaidOnly == true`) are detected and reported with a
clear message rather than a cryptic failure.

## Output: generated files

Target directory: `problems/pNNNN-slug/` where `NNNN` is the zero-padded
`questionFrontendId`. This matches the existing repo convention
(e.g. `problems/p0003-longest-substring-without-repeating-characters/`).

**Idempotency:** if the directory already exists, `lc` does not overwrite it
(protects in-progress solutions). It opens the existing folder instead, unless
`--force` is given.

### `main.go`

```go
package main

// <Title> (#<num>) · <Difficulty>
// https://leetcode.com/problems/<slug>/
//
// <short description / first paragraph, plain text>

import "fmt"

<official Go signature from codeSnippets, with a // TODO stub body
 returning the zero value of the return type>

func main() {
	fmt.Println("see main_test.go")
}
```

### `main_test.go`

Table-driven test, one row per parsed example:

```go
package main

import "testing"

func Test<FuncName>(t *testing.T) {
	cases := []struct {
		name string
		// typed input fields derived from the signature params
		want <returnType>
	}{
		{name: "example 1", /* args */, want: /* parsed */},
		// ...
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := <funcName>(/* tc args */)
			if !reflect.DeepEqual(got, tc.want) { // or == for comparable
				t.Fatalf("got %v, want %v", got, tc.want)
			}
		})
	}
}
```

The test compiles and **fails** until the stub is implemented.

### `README.md`

The problem `content` HTML converted to readable Markdown/plain text:
description, examples, and constraints, with a link back to the problem. For
comfortable reading inside GoLand.

## Test-case parsing (best-effort)

`exampleTestcases` provides inputs; expected outputs are parsed from the
`Output:` lines in the HTML `content`. Inputs are mapped to typed Go literals
using the parameter types from the parsed signature.

**Reliably handled types:** `int`, `int64`, `float64`, `string`, `bool`,
`[]int`, `[]string`, `[][]int`, `byte`.

**Marked, not guessed:** for types the parser can't confidently produce
(`*ListNode`, `*TreeNode`, custom structs) or known-ambiguous problems
(multiple valid answers, order-independent results), the row is emitted with a
`// TODO: verify` comment and a best-effort or zero value. **The file always
compiles** — the user eyeballs the marked rows.

Comparison in the generated test uses `==` for comparable scalar returns and
`reflect.DeepEqual` for slices/maps.

## Internal structure (`cmd/lc/`)

Split by responsibility, each unit independently testable:

- `main.go` — arg parsing, flag handling, orchestration, exit codes
- `resolve.go` — input detection + number→slug cache lookup
- `client.go` — GraphQL/HTTP calls, response structs
- `signature.go` — parse Go signature from a code snippet (func name, params, return)
- `examples.go` — parse example inputs/outputs from `exampleTestcases` + HTML → typed Go literals
- `render.go` — HTML → Markdown for the README
- `scaffold.go` — write the three files from the gathered data
- `open.go` — `goland <dir>` + `go test ./problems/...` invocation

## Error handling

- Network failure → clear message, non-zero exit.
- Unknown slug / number not found → message naming what was searched.
- `isPaidOnly` → report "this is a LeetCode Premium problem; description is not
  publicly available" and exit non-zero without scaffolding (premium problems
  return no usable `content`/`codeSnippets` without a session cookie, so there is
  nothing to scaffold).
- Signature parse failure → still scaffold `README.md`, emit a `main.go` with a
  `// TODO: could not parse signature` note rather than aborting.
- GoLand not on PATH → skip open with a warning, still run the test.

## Testing the tool

Unit tests against saved fixtures (no live network in tests):

- `resolve_test.go` — URL/number/slug/daily detection
- `signature_test.go` — signature parsing across several real snippets
- `examples_test.go` — example parsing for each supported type + the TODO fallback
- `render_test.go` — HTML→Markdown on a sample description

Live GraphQL is exercised manually, not in unit tests.

## Out of scope (YAGNI)

- Submitting solutions back to LeetCode.
- Authenticated/premium content beyond detection.
- Languages other than Go.
- A TUI / interactive picker.

## Install / wiring

- `go install ./cmd/lc` builds the binary into `~/go/bin`.
- `fish_add_path ~/go/bin` so `lc` is globally available (persisted).
- Document the `lc` usage in `CLAUDE.md` and `README.md`.
