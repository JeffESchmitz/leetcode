package main

func lengthOfLongestSubstring(s string) int {
	m := make(map[byte]int)
	res := 0
	left := 0
	for right := range len(s) {
		if idx, ok := m[s[right]]; ok {
			left = max(left, idx+1)
		}
		m[s[right]] = right
		res = max(res, right-left+1)
	}
	return res
}
