package main

import (
	"encoding/json"
	"regexp"
	"strconv"
	"strings"
)

type exampleCase struct {
	args        []string
	want        string
	needsReview bool
}

var outputRe = regexp.MustCompile(`(?i)Output:\s*(.+)`)

func parseOutputs(text string) []string {
	var out []string
	for _, m := range outputRe.FindAllStringSubmatch(text, -1) {
		out = append(out, strings.TrimSpace(m[1]))
	}
	return out
}

func joinInts(xs []int) string {
	parts := make([]string, len(xs))
	for i, x := range xs {
		parts[i] = strconv.Itoa(x)
	}
	return strings.Join(parts, ", ")
}

func toGoLiteral(goType, raw string) (string, bool) {
	goType = strings.TrimSpace(goType)
	raw = strings.TrimSpace(raw)
	switch goType {
	case "int", "int64", "int32":
		if _, err := strconv.Atoi(raw); err == nil {
			return raw, true
		}
	case "float64":
		if _, err := strconv.ParseFloat(raw, 64); err == nil {
			return raw, true
		}
	case "bool":
		if raw == "true" || raw == "false" {
			return raw, true
		}
	case "string":
		if strings.HasPrefix(raw, `"`) {
			return raw, true
		}
		return strconv.Quote(raw), true
	case "byte":
		r := strings.Trim(raw, `"'`)
		if len(r) == 1 {
			return "'" + r + "'", true
		}
	case "[]int", "[]int64":
		var arr []int
		if json.Unmarshal([]byte(raw), &arr) == nil {
			return goType + "{" + joinInts(arr) + "}", true
		}
	case "[]string":
		var arr []string
		if json.Unmarshal([]byte(raw), &arr) == nil {
			parts := make([]string, len(arr))
			for i, v := range arr {
				parts[i] = strconv.Quote(v)
			}
			return "[]string{" + strings.Join(parts, ", ") + "}", true
		}
	case "[]bool":
		var arr []bool
		if json.Unmarshal([]byte(raw), &arr) == nil {
			parts := make([]string, len(arr))
			for i, v := range arr {
				parts[i] = strconv.FormatBool(v)
			}
			return "[]bool{" + strings.Join(parts, ", ") + "}", true
		}
	case "[][]int":
		var arr [][]int
		if json.Unmarshal([]byte(raw), &arr) == nil {
			rows := make([]string, len(arr))
			for i, r := range arr {
				rows[i] = "{" + joinInts(r) + "}"
			}
			return "[][]int{" + strings.Join(rows, ", ") + "}", true
		}
	}
	return "", false
}

func zeroValue(t string) string {
	t = strings.TrimSpace(t)
	switch t {
	case "":
		return ""
	case "int", "int64", "int32", "float64", "byte", "rune":
		return "0"
	case "bool":
		return "false"
	case "string":
		return `""`
	}
	if strings.HasPrefix(t, "[]") || strings.HasPrefix(t, "map[") || strings.HasPrefix(t, "*") {
		return "nil"
	}
	return t + "{}"
}

func buildCases(sig goSignature, exampleTestcases, contentText string) []exampleCase {
	np := len(sig.params)
	if np == 0 {
		return nil
	}
	inputs := strings.Split(strings.TrimSpace(exampleTestcases), "\n")
	outputs := parseOutputs(contentText)

	var cases []exampleCase
	for i := 0; i+np <= len(inputs); i += np {
		idx := i / np
		c := exampleCase{}
		for j, p := range sig.params {
			lit, ok := toGoLiteral(p.typ, strings.TrimSpace(inputs[i+j]))
			if !ok {
				lit = zeroValue(p.typ)
				c.needsReview = true
			}
			c.args = append(c.args, lit)
		}
		wantRaw := ""
		if idx < len(outputs) {
			wantRaw = outputs[idx]
		}
		lit, ok := toGoLiteral(sig.retType, wantRaw)
		if !ok {
			lit = zeroValue(sig.retType)
			c.needsReview = true
		}
		c.want = lit
		cases = append(cases, c)
	}
	return cases
}
