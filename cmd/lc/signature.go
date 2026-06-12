package main

import (
	"fmt"
	"regexp"
	"strings"
)

type param struct {
	name string
	typ  string
}

type goSignature struct {
	funcName string
	params   []param
	retType  string
}

var funcRe = regexp.MustCompile(`func\s+(\w+)\s*\((.*?)\)\s*(.*?)\s*\{`)

func parseSignature(snippet string) (goSignature, error) {
	m := funcRe.FindStringSubmatch(snippet)
	if m == nil {
		return goSignature{}, fmt.Errorf("no Go func signature found")
	}
	return goSignature{
		funcName: m[1],
		params:   parseParams(m[2]),
		retType:  strings.TrimSpace(m[3]),
	}, nil
}

func parseParams(s string) []param {
	s = strings.TrimSpace(s)
	if s == "" {
		return nil
	}
	parts := strings.Split(s, ",")
	params := make([]param, 0, len(parts))
	for _, p := range parts {
		fields := strings.Fields(strings.TrimSpace(p))
		if len(fields) == 1 {
			params = append(params, param{name: fields[0]}) // grouped, type filled below
		} else {
			params = append(params, param{name: fields[0], typ: strings.Join(fields[1:], " ")})
		}
	}
	// backfill grouped params (e.g. "a, b int") from the next typed param
	for i := len(params) - 1; i >= 0; i-- {
		if params[i].typ == "" && i+1 < len(params) {
			params[i].typ = params[i+1].typ
		}
	}
	return params
}
