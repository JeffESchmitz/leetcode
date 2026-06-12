package main

import (
	"html"
	"regexp"
	"strings"
)

var (
	reLi    = regexp.MustCompile(`(?i)<li[^>]*>`)
	reBreak = regexp.MustCompile(`(?i)</(p|div|h[1-6]|pre|ul|ol)>|<br\s*/?>`)
	reTag   = regexp.MustCompile(`<[^>]+>`)
	reWS    = regexp.MustCompile(`\n{3,}`)
)

func htmlToText(s string) string {
	s = reLi.ReplaceAllString(s, "\n- ")
	s = reBreak.ReplaceAllString(s, "\n\n")
	s = reTag.ReplaceAllString(s, "")
	s = html.UnescapeString(s)
	s = reWS.ReplaceAllString(s, "\n\n")
	// trim trailing spaces on each line
	lines := strings.Split(s, "\n")
	for i := range lines {
		lines[i] = strings.TrimRight(lines[i], " \t")
	}
	return strings.TrimSpace(strings.Join(lines, "\n"))
}
