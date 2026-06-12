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
	return exec.Command("goland", dir).Start()
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
