package main

import (
	"errors"
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

func TestDirName(t *testing.T) {
	qd := questionData{FrontendID: "3", TitleSlug: "longest-substring"}
	if got := dirName(qd); got != "p0003-longest-substring" {
		t.Errorf("dirName = %q", got)
	}
}

func TestScaffoldWritesCompilableFiles(t *testing.T) {
	root := t.TempDir()
	// give the temp workspace a module so `go vet` has a context
	if err := os.WriteFile(filepath.Join(root, "go.mod"), []byte("module scaffoldtest\n\ngo 1.26\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	qd := questionData{
		FrontendID:       "1",
		Title:            "Two Sum",
		TitleSlug:        "two-sum",
		Difficulty:       "Easy",
		Content:          "<p>Return indices.</p>",
		GoSnippet:        "func twoSum(nums []int, target int) []int {\n\n}",
		ExampleTestcases: "[2,7,11,15]\n9",
	}
	dir, err := scaffold(root, qd, false)
	if err != nil {
		t.Fatalf("scaffold: %v", err)
	}
	for _, f := range []string{"main.go", "main_test.go", "README.md"} {
		if _, err := os.Stat(filepath.Join(dir, f)); err != nil {
			t.Errorf("missing %s: %v", f, err)
		}
	}
	// vet the generated package compiles (from the module root)
	cmd := exec.Command("go", "vet", "./...")
	cmd.Dir = root
	if out, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("generated code does not vet: %v\n%s", err, out)
	}
	// second call without --force returns errExists
	if _, err := scaffold(root, qd, false); !errors.Is(err, errExists) {
		t.Errorf("expected errExists on second scaffold, got %v", err)
	}
}
