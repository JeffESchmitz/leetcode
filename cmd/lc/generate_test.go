package main

import (
	"go/format"
	"strings"
	"testing"
)

func sampleQuestion() questionData {
	return questionData{
		FrontendID:       "1",
		Title:            "Two Sum",
		TitleSlug:        "two-sum",
		Difficulty:       "Easy",
		Content:          "<p>Return indices of the two numbers.</p>",
		GoSnippet:        "func twoSum(nums []int, target int) []int {\n\n}",
		ExampleTestcases: "[2,7,11,15]\n9",
	}
}

func TestGenMainGoCompiles(t *testing.T) {
	qd := sampleQuestion()
	sig, _ := parseSignature(qd.GoSnippet)
	src := genMainGo(qd, sig, nil, htmlToText(qd.Content))
	if _, err := format.Source([]byte(src)); err != nil {
		t.Fatalf("genMainGo produced invalid Go:\n%s\nerr: %v", src, err)
	}
	if !strings.Contains(src, "func twoSum(nums []int, target int) []int") {
		t.Errorf("missing signature in:\n%s", src)
	}
	if !strings.Contains(src, "// TODO: implement") {
		t.Errorf("missing stub TODO")
	}
}

func TestGenTestGoCompiles(t *testing.T) {
	qd := sampleQuestion()
	sig, _ := parseSignature(qd.GoSnippet)
	cases := buildCases(sig, qd.ExampleTestcases, "Output: [0,1]")
	src := genTestGo(sig, cases)
	if _, err := format.Source([]byte(src)); err != nil {
		t.Fatalf("genTestGo produced invalid Go:\n%s\nerr: %v", src, err)
	}
	if !strings.Contains(src, "func TestTwoSum(t *testing.T)") {
		t.Errorf("missing test func in:\n%s", src)
	}
}

func TestGenReadme(t *testing.T) {
	qd := sampleQuestion()
	md := genReadme(qd, htmlToText(qd.Content))
	if !strings.Contains(md, "# 1. Two Sum") || !strings.Contains(md, "Easy") {
		t.Errorf("readme missing header:\n%s", md)
	}
}
