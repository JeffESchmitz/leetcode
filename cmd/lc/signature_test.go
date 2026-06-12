package main

import "testing"

func TestParseSignature(t *testing.T) {
	snippet := "func twoSum(nums []int, target int) []int {\n    \n}"
	sig, err := parseSignature(snippet)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if sig.funcName != "twoSum" {
		t.Errorf("funcName = %q, want twoSum", sig.funcName)
	}
	if len(sig.params) != 2 ||
		sig.params[0] != (param{"nums", "[]int"}) ||
		sig.params[1] != (param{"target", "int"}) {
		t.Errorf("params = %+v", sig.params)
	}
	if sig.retType != "[]int" {
		t.Errorf("retType = %q, want []int", sig.retType)
	}
}

func TestParseSignatureGroupedParams(t *testing.T) {
	sig, err := parseSignature("func gcd(a, b int) int {}")
	if err != nil {
		t.Fatal(err)
	}
	if sig.params[0] != (param{"a", "int"}) || sig.params[1] != (param{"b", "int"}) {
		t.Errorf("grouped params = %+v", sig.params)
	}
}

func TestParseSignatureNoReturn(t *testing.T) {
	sig, err := parseSignature("func rotate(nums []int, k int)  {}")
	if err != nil {
		t.Fatal(err)
	}
	if sig.retType != "" {
		t.Errorf("retType = %q, want empty", sig.retType)
	}
}
