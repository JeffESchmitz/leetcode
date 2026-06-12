package main

import "testing"

func TestDetectInput(t *testing.T) {
	cases := []struct {
		in       string
		wantKind inputKind
		wantSlug string
		wantNum  int
	}{
		{"daily", inputDaily, "", 0},
		{"https://leetcode.com/problems/two-sum/", inputURL, "two-sum", 0},
		{"https://leetcode.com/problems/two-sum/description/", inputURL, "two-sum", 0},
		{"1", inputNumber, "", 1},
		{"42", inputNumber, "", 42},
		{"two-sum", inputSlug, "two-sum", 0},
	}
	for _, tc := range cases {
		got := detectInput(tc.in)
		if got.kind != tc.wantKind || got.slug != tc.wantSlug || got.num != tc.wantNum {
			t.Errorf("detectInput(%q) = %+v, want kind=%v slug=%q num=%d",
				tc.in, got, tc.wantKind, tc.wantSlug, tc.wantNum)
		}
	}
}
