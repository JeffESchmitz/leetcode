package main

// Roman to Integer (#13) · Easy
// https://leetcode.com/problems/roman-to-integer/
//
// Roman numerals are represented by seven different symbols: I, V, X, L, C, D and M.

import "fmt"

func romanToInt(s string) int {
	// TODO: implement
	romanMap := map[byte]int{
		'I': 1,
		'V': 5,
		'X': 10,
		'L': 50,
		'C': 100,
		'D': 500,
		'M': 1000,
	}

	total := 0

	for i := 0; i < len(s); i++ {
		current := romanMap[s[i]]
		next := 0

		if i+1 < len(s) {
			next = romanMap[s[i+1]]
		}

		if next > current {
			total -= current
		} else {
			total += current
		}
	}

	return total
}

func main() {
	fmt.Println("see main_test.go")
}
