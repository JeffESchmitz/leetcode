package main

import "testing"

func TestNumJewelsInStones(t *testing.T) {
	cases := []struct {
		name   string
		jewels string
		stones string
		want   int
	}{
		{name: "example 1", jewels: "aA", stones: "aAAbbbb", want: 3},
		{name: "example 2", jewels: "z", stones: "ZZ", want: 0},
		{
			name:   "random large",
			jewels: "abcd",
			stones: func() string {
				// We'll use a local deterministic "random" generator for reproducibility
				const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
				res := make([]byte, 1000)
				for i := range 1000 {
					// Using a simple formula to pick indices
					res[i] = charset[(i*7+3)%len(charset)]
				}
				return string(res)
			}(),
			want: func() int {
				// We calculate the expected 'want' by looking for 'a', 'b', 'c', 'd'
				const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
				count := 0
				for i := range 1000 {
					char := charset[(i*7+3)%len(charset)]
					if char == 'a' || char == 'b' || char == 'c' || char == 'd' {
						count++
					}
				}
				return count
			}(),
		},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := numJewelsInStones(tc.jewels, tc.stones)
			if got != tc.want {
				t.Fatalf("got %v, want %v", got, tc.want)
			}
		})
	}
}
