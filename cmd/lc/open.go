package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

func openInGoland(dir string) error {
	if _, err := exec.LookPath("goland"); err != nil {
		return fmt.Errorf("goland not on PATH; skipping open")
	}
	// Open the main.go file, not the directory. Pointing GoLand at a file inside an
	// already-open project opens it in that window; opening a directory triggers
	// the "Open Project" dialog. Fall back to the directory if main.go is absent
	// (e.g. the signature couldn't be parsed, so no main.go was written).
	target := filepath.Join(dir, "main.go")
	if _, err := os.Stat(target); err != nil {
		target = dir
	}
	return exec.Command("goland", target).Start()
}

func runTest(repoRoot, dir string) error {
	rel, err := filepath.Rel(repoRoot, dir)
	if err != nil {
		return err
	}
	cmd := exec.Command("go", "test", "./"+rel+"/")
	cmd.Dir = repoRoot
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
