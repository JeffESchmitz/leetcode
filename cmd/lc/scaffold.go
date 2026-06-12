package main

import (
	"errors"
	"fmt"
	"go/format"
	"os"
	"path/filepath"
	"strconv"
)

var errExists = errors.New("problem folder already exists")

func dirName(qd questionData) string {
	id, _ := strconv.Atoi(qd.FrontendID)
	return fmt.Sprintf("p%04d-%s", id, qd.TitleSlug)
}

func formatGo(src string) string {
	if out, err := format.Source([]byte(src)); err == nil {
		return string(out)
	}
	return src // fall back to unformatted; still better than nothing
}

func scaffold(repoRoot string, qd questionData, force bool) (string, error) {
	dir := filepath.Join(repoRoot, "problems", dirName(qd))
	if _, err := os.Stat(dir); err == nil && !force {
		return dir, errExists
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return dir, err
	}

	sig, sigErr := parseSignature(qd.GoSnippet)
	text := htmlToText(qd.Content)

	mainSrc := formatGo(genMainGo(qd, sig, sigErr, text))
	if err := os.WriteFile(filepath.Join(dir, "main.go"), []byte(mainSrc), 0o644); err != nil {
		return dir, err
	}

	if sigErr == nil {
		cases := buildCases(sig, qd.ExampleTestcases, text)
		testSrc := formatGo(genTestGo(sig, cases))
		if err := os.WriteFile(filepath.Join(dir, "main_test.go"), []byte(testSrc), 0o644); err != nil {
			return dir, err
		}
	}

	if err := os.WriteFile(filepath.Join(dir, "README.md"), []byte(genReadme(qd, text)), 0o644); err != nil {
		return dir, err
	}
	return dir, nil
}
