package main

import (
	"regexp"
	"strconv"
	"strings"
)

type inputKind int

const (
	inputDaily inputKind = iota
	inputURL
	inputNumber
	inputSlug
)

type resolvedInput struct {
	kind inputKind
	raw  string
	slug string
	num  int
}

var (
	urlSlugRe   = regexp.MustCompile(`leetcode\.com/problems/([a-z0-9-]+)`)
	allDigitsRe = regexp.MustCompile(`^\d+$`)
)

func detectInput(arg string) resolvedInput {
	a := strings.TrimSpace(arg)
	switch {
	case strings.EqualFold(a, "daily"):
		return resolvedInput{kind: inputDaily, raw: a}
	case strings.HasPrefix(a, "http"):
		slug := ""
		if m := urlSlugRe.FindStringSubmatch(a); len(m) == 2 {
			slug = m[1]
		}
		return resolvedInput{kind: inputURL, raw: a, slug: slug}
	case allDigitsRe.MatchString(a):
		n, _ := strconv.Atoi(a)
		return resolvedInput{kind: inputNumber, raw: a, num: n}
	default:
		return resolvedInput{kind: inputSlug, raw: a, slug: a}
	}
}
