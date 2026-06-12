package main

import "testing"

func TestToGoLiteral(t *testing.T) {
	cases := []struct {
		typ, raw, want string
		ok             bool
	}{
		{"int", "9", "9", true},
		{"string", "abc", `"abc"`, true},
		{"string", `"abc"`, `"abc"`, true},
		{"bool", "true", "true", true},
		{"[]int", "[2,7,11,15]", "[]int{2, 7, 11, 15}", true},
		{"[]string", `["a","b"]`, `[]string{"a", "b"}`, true},
		{"[][]int", "[[1,2],[3,4]]", "[][]int{{1, 2}, {3, 4}}", true},
		{"*ListNode", "[1,2,3]", "", false},
	}
	for _, tc := range cases {
		got, ok := toGoLiteral(tc.typ, tc.raw)
		if ok != tc.ok || (ok && got != tc.want) {
			t.Errorf("toGoLiteral(%q,%q) = (%q,%v), want (%q,%v)",
				tc.typ, tc.raw, got, ok, tc.want, tc.ok)
		}
	}
}

func TestParseOutputs(t *testing.T) {
	text := "Example 1:\nInput: nums = [2,7]\nOutput: [0,1]\n\nExample 2:\nOutput: [1,2]"
	got := parseOutputs(text)
	if len(got) != 2 || got[0] != "[0,1]" || got[1] != "[1,2]" {
		t.Errorf("parseOutputs = %#v", got)
	}
}

func TestBuildCases(t *testing.T) {
	sig := goSignature{
		funcName: "twoSum",
		params:   []param{{"nums", "[]int"}, {"target", "int"}},
		retType:  "[]int",
	}
	exampleTestcases := "[2,7,11,15]\n9\n[3,2,4]\n6"
	text := "Output: [0,1]\nOutput: [1,2]"
	cases := buildCases(sig, exampleTestcases, text)
	if len(cases) != 2 {
		t.Fatalf("got %d cases, want 2", len(cases))
	}
	if cases[0].args[0] != "[]int{2, 7, 11, 15}" || cases[0].args[1] != "9" || cases[0].want != "[]int{0, 1}" {
		t.Errorf("case0 = %+v", cases[0])
	}
	if cases[0].needsReview {
		t.Errorf("case0 should not need review")
	}
}
