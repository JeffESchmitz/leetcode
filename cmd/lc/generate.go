package main

import (
	"fmt"
	"strconv"
	"strings"
)

func capitalize(s string) string {
	if s == "" {
		return s
	}
	return strings.ToUpper(s[:1]) + s[1:]
}

func needsReflect(retType string) bool {
	return strings.HasPrefix(retType, "[]") ||
		strings.HasPrefix(retType, "map[") ||
		strings.HasPrefix(retType, "*")
}

// docComment turns plain text into a // comment block (first paragraph only).
func docComment(text string) string {
	para := text
	if i := strings.Index(text, "\n\n"); i >= 0 {
		para = text[:i]
	}
	var b strings.Builder
	for _, line := range strings.Split(strings.TrimSpace(para), "\n") {
		b.WriteString("// " + line + "\n")
	}
	return b.String()
}

func genMainGo(qd questionData, sig goSignature, sigErr error, text string) string {
	id, _ := strconv.Atoi(qd.FrontendID)
	var b strings.Builder
	b.WriteString("package main\n\n")
	b.WriteString(fmt.Sprintf("// %s (#%d) · %s\n", qd.Title, id, qd.Difficulty))
	b.WriteString(fmt.Sprintf("// https://leetcode.com/problems/%s/\n//\n", qd.TitleSlug))
	b.WriteString(docComment(text))
	b.WriteString("\nimport \"fmt\"\n\n")
	if sigErr != nil {
		b.WriteString("// TODO: could not parse the Go signature from LeetCode; add it manually.\n\n")
	} else {
		params := make([]string, len(sig.params))
		for i, p := range sig.params {
			params[i] = p.name + " " + p.typ
		}
		ret := sig.retType
		if ret != "" {
			ret = " " + ret
		}
		b.WriteString(fmt.Sprintf("func %s(%s)%s {\n", sig.funcName, strings.Join(params, ", "), ret))
		b.WriteString("\t// TODO: implement\n")
		if sig.retType != "" {
			b.WriteString("\treturn " + zeroValue(sig.retType) + "\n")
		}
		b.WriteString("}\n\n")
	}
	b.WriteString("func main() {\n\tfmt.Println(\"see main_test.go\")\n}\n")
	return b.String()
}

func genTestGo(sig goSignature, cases []exampleCase) string {
	var b strings.Builder
	b.WriteString("package main\n\n")
	if needsReflect(sig.retType) {
		b.WriteString("import (\n\t\"reflect\"\n\t\"testing\"\n)\n\n")
	} else {
		b.WriteString("import \"testing\"\n\n")
	}
	b.WriteString(fmt.Sprintf("func Test%s(t *testing.T) {\n", capitalize(sig.funcName)))
	b.WriteString("\tcases := []struct {\n\t\tname string\n")
	for _, p := range sig.params {
		b.WriteString(fmt.Sprintf("\t\t%s %s\n", p.name, p.typ))
	}
	b.WriteString(fmt.Sprintf("\t\twant %s\n\t}{\n", sig.retType))
	for i, c := range cases {
		b.WriteString(fmt.Sprintf("\t\t{name: \"example %d\"", i+1))
		for j, p := range sig.params {
			b.WriteString(fmt.Sprintf(", %s: %s", p.name, c.args[j]))
		}
		b.WriteString(fmt.Sprintf(", want: %s},", c.want))
		if c.needsReview {
			b.WriteString(" // TODO: verify")
		}
		b.WriteString("\n")
	}
	b.WriteString("\t}\n")
	b.WriteString("\tfor _, tc := range cases {\n\t\tt.Run(tc.name, func(t *testing.T) {\n")
	args := make([]string, len(sig.params))
	for j, p := range sig.params {
		args[j] = "tc." + p.name
	}
	b.WriteString(fmt.Sprintf("\t\t\tgot := %s(%s)\n", sig.funcName, strings.Join(args, ", ")))
	if needsReflect(sig.retType) {
		b.WriteString("\t\t\tif !reflect.DeepEqual(got, tc.want) {\n")
	} else {
		b.WriteString("\t\t\tif got != tc.want {\n")
	}
	b.WriteString("\t\t\t\tt.Fatalf(\"got %v, want %v\", got, tc.want)\n\t\t\t}\n")
	b.WriteString("\t\t})\n\t}\n}\n")
	return b.String()
}

func genReadme(qd questionData, text string) string {
	id, _ := strconv.Atoi(qd.FrontendID)
	var b strings.Builder
	b.WriteString(fmt.Sprintf("# %d. %s\n\n", id, qd.Title))
	b.WriteString(fmt.Sprintf("**Difficulty:** %s  \n", qd.Difficulty))
	b.WriteString(fmt.Sprintf("**Link:** https://leetcode.com/problems/%s/\n\n---\n\n", qd.TitleSlug))
	b.WriteString(text + "\n")
	return b.String()
}
