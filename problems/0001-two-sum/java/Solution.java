import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

// LeetCode 1. Two Sum
// Single-file program: run with `java -ea Solution.java` (assertions enabled).
public class Solution {
    static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> seen = new HashMap<>(); // value -> index
        for (int i = 0; i < nums.length; i++) {
            Integer j = seen.get(target - nums[i]);
            if (j != null) {
                return new int[] {j, i};
            }
            seen.put(nums[i], i);
        }
        return new int[] {};
    }

    public static void main(String[] args) {
        assert Arrays.equals(twoSum(new int[] {2, 7, 11, 15}, 9), new int[] {0, 1});
        assert Arrays.equals(twoSum(new int[] {3, 2, 4}, 6), new int[] {1, 2});
        assert Arrays.equals(twoSum(new int[] {3, 3}, 6), new int[] {0, 1});
        System.out.println("All Two Sum tests passed.");
    }
}
