package main

import "testing"

func TestHTMLToText(t *testing.T) {
	in := "<p>Given <code>nums</code> &amp; <code>target</code>.</p>" +
		"<p>Return indices.</p><ul><li>1 &lt;= n</li><li>n &lt;= 100</li></ul>"
	got := htmlToText(in)
	want := "Given nums & target.\n\nReturn indices.\n\n- 1 <= n\n- n <= 100"
	if got != want {
		t.Errorf("htmlToText mismatch:\n got: %q\nwant: %q", got, want)
	}
}
