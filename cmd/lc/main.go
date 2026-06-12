// Command lc scaffolds LeetCode problems into this Go workspace.
package main

import (
	"bufio"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	noOpen := flag.Bool("no-open", false, "don't open GoLand")
	noTest := flag.Bool("no-test", false, "don't run the failing test after scaffold")
	force := flag.Bool("force", false, "overwrite an existing problem folder")

	// Allow flags in any position (e.g. `lc two-sum --no-open`). All flags are
	// boolean, so partitioning on a leading '-' is unambiguous.
	var flags, positional []string
	for _, a := range os.Args[1:] {
		if strings.HasPrefix(a, "-") {
			flags = append(flags, a)
		} else {
			positional = append(positional, a)
		}
	}
	_ = flag.CommandLine.Parse(flags)

	if len(positional) != 1 {
		fmt.Fprintln(os.Stderr, "usage: lc <daily | url | number | slug> [--no-open] [--no-test] [--force]")
		os.Exit(2)
	}

	if err := run(positional[0], *noOpen, *noTest, *force); err != nil {
		fmt.Fprintln(os.Stderr, "lc:", err)
		os.Exit(1)
	}
}

func run(arg string, noOpen, noTest, force bool) error {
	in := detectInput(arg)
	slug := in.slug
	var err error
	switch in.kind {
	case inputDaily:
		if slug, err = fetchDailySlug(); err != nil {
			return err
		}
	case inputNumber:
		if slug, err = slugForNumber(in.num); err != nil {
			return err
		}
	case inputURL:
		if slug == "" {
			return fmt.Errorf("could not parse a problem slug from URL %q", arg)
		}
	}

	qd, err := fetchQuestion(slug)
	if err != nil {
		return err
	}
	if qd.IsPaidOnly {
		return fmt.Errorf("%q is a LeetCode Premium problem; its description is not publicly available", slug)
	}

	root, err := findRepoRoot()
	if err != nil {
		return err
	}

	dir, err := scaffold(root, qd, force)
	switch {
	case errors.Is(err, errExists):
		fmt.Printf("already scaffolded: %s (use --force to overwrite)\n", dir)
	case err != nil:
		return err
	default:
		fmt.Printf("scaffolded: %s\n", dir)
	}

	if !noOpen {
		if e := openInGoland(dir); e != nil {
			fmt.Fprintln(os.Stderr, "warning:", e)
		}
	}
	if !noTest {
		fmt.Println("running failing test baseline...")
		_ = runTest(root, dir) // a failing test is expected; don't treat as fatal
	}
	return nil
}

// findRepoRoot returns the leetcode module root: $LC_REPO if set, otherwise the
// nearest ancestor of the cwd containing a go.mod whose module is "leetcode".
func findRepoRoot() (string, error) {
	if env := os.Getenv("LC_REPO"); env != "" {
		return env, nil
	}
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}
	for {
		if isLeetcodeModule(filepath.Join(dir, "go.mod")) {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", fmt.Errorf("not inside the leetcode repo (no go.mod with 'module leetcode' found); run from the repo or set LC_REPO")
		}
		dir = parent
	}
}

func isLeetcodeModule(gomodPath string) bool {
	f, err := os.Open(gomodPath)
	if err != nil {
		return false
	}
	defer f.Close()
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		line := strings.TrimSpace(sc.Text())
		if strings.HasPrefix(line, "module ") {
			return strings.TrimSpace(strings.TrimPrefix(line, "module ")) == "leetcode"
		}
	}
	return false
}
