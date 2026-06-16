package main

// Jewels and Stones (#771) · Easy
// https://leetcode.com/problems/jewels-and-stones/
//
// You're given strings jewels representing the types of stones that are jewels, and stones representing the stones you have. Each character in stones is a type of stone you have. You want to know how many of the stones you have are also jewels.

import "fmt"

func numJewelsInStones(jewels string, stones string) int {
	// TODO: implement

	// Create an empty Go "Set"
	jewelsSet := make(map[rune]struct{})

	// Loop through each `jewel` and store each one in the map...
	for _, char := range jewels {
		// We just marked this char as a jewel
		jewelsSet[char] = struct{}{}
	}

	// Create a counter to hold and return the count
	counter := 0

	// Loop through the `stones`
	for _, char := range stones {
		// Check if this stone is in our jewelSet
		if _, ok := jewelsSet[char]; ok {
			counter++
		}
	}

	return counter
}

func main() {
	fmt.Println("see main_test.go")
}
