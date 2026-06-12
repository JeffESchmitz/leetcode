# leetcode (Go)

A Go workspace for LeetCode practice — focused on learning Go and algorithmic
reasoning (see `COACH.md` for how problems are worked, and `CLAUDE.md` for details).

## Fetching a problem

```bash
lc daily | lc <url> | lc <number> | lc <slug>
```

Scaffolds `problems/pNNNN-slug/` with a stub, a failing test auto-parsed from the
examples, and the problem README, then opens it in GoLand and runs the failing test.
Source in `cmd/lc/`; install with `go install ./cmd/lc`.

## Running

```bash
go test ./...                    # all problems
go test ./problems/two-sum/      # one problem
go run ./problems/two-sum/       # run a problem's main()
```
