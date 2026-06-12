package main

import "testing"

func TestParseProblemMap(t *testing.T) {
	data := []byte(`{"stat_status_pairs":[
		{"stat":{"frontend_question_id":1,"question__title_slug":"two-sum"}},
		{"stat":{"frontend_question_id":3,"question__title_slug":"longest-substring-without-repeating-characters"}}
	]}`)
	m, err := parseProblemMap(data)
	if err != nil {
		t.Fatal(err)
	}
	if m[1] != "two-sum" || m[3] != "longest-substring-without-repeating-characters" {
		t.Errorf("map = %#v", m)
	}
}
