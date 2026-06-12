package main

import "fmt"

func twoSum(nums []int, target int) []int {
	seen := make(map[int]int)
	for i, n := range nums {
		need := target - n
		if j, ok := seen[need]; ok {
			return []int{j, i}
		}
		seen[n] = i
	}
	return nil
}

func main() {
	fmt.Println(twoSum([]int{2, 7, 11, 15}, 9))
}
