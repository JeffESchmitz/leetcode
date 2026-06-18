// LeetCode 1. Two Sum
// Run: kotlinc Solution.kt -include-runtime -d solution.jar && java -jar solution.jar

fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>() // value -> index
    for ((i, n) in nums.withIndex()) {
        seen[target - n]?.let { return intArrayOf(it, i) }
        seen[n] = i
    }
    return intArrayOf()
}

fun main() {
    check(twoSum(intArrayOf(2, 7, 11, 15), 9).contentEquals(intArrayOf(0, 1)))
    check(twoSum(intArrayOf(3, 2, 4), 6).contentEquals(intArrayOf(1, 2)))
    check(twoSum(intArrayOf(3, 3), 6).contentEquals(intArrayOf(0, 1)))
    println("All Two Sum tests passed.")
}
