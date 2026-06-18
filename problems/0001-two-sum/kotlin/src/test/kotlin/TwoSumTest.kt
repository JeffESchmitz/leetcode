import kotlin.test.Test
import kotlin.test.assertContentEquals

class TwoSumTest {
    @Test
    fun example1() = assertContentEquals(intArrayOf(0, 1), twoSum(intArrayOf(2, 7, 11, 15), 9))

    @Test
    fun example2() = assertContentEquals(intArrayOf(1, 2), twoSum(intArrayOf(3, 2, 4), 6))

    @Test
    fun duplicateValues() = assertContentEquals(intArrayOf(0, 1), twoSum(intArrayOf(3, 3), 6))
}
