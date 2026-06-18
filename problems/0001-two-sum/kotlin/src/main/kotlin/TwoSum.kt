// LeetCode 1. Two Sum
//
// Indices of the two numbers that add up to `target`.
// Single pass with a `value -> index` map. O(n) time, O(n) space.
fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for ((i, n) in nums.withIndex()) {
        seen[target - n]?.let { return intArrayOf(it, i) }
        seen[n] = i
    }
    return intArrayOf()
}

fun main() {
    println(twoSum(intArrayOf(2, 7, 11, 15), 9).toList())
}
