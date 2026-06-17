package main

import "testing"

func TestRomanToInt(t *testing.T) {
	cases := []struct {
		name string
		s    string
		want int
	}{
		{name: "example 1", s: "III", want: 3},
		{name: "example 2", s: "LVIII", want: 58},
		{name: "example 3", s: "MCMXCIV", want: 1994},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := romanToInt(tc.s)
			if got != tc.want {
				t.Fatalf("got %v, want %v", got, tc.want)
			}
		})
	}
}
