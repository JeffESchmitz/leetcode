//! LeetCode 1. Two Sum
use std::collections::HashMap;

/// Indices of the two numbers that add up to `target`.
/// Single pass with a `value -> index` map. O(n) time, O(n) space.
pub fn two_sum(nums: &[i32], target: i32) -> Vec<i32> {
    let mut seen: HashMap<i32, i32> = HashMap::new();
    for (i, &n) in nums.iter().enumerate() {
        if let Some(&j) = seen.get(&(target - n)) {
            return vec![j, i as i32];
        }
        seen.insert(n, i as i32);
    }
    Vec::new()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn example1() {
        assert_eq!(two_sum(&[2, 7, 11, 15], 9), vec![0, 1]);
    }

    #[test]
    fn example2() {
        assert_eq!(two_sum(&[3, 2, 4], 6), vec![1, 2]);
    }

    #[test]
    fn duplicate_values() {
        assert_eq!(two_sum(&[3, 3], 6), vec![0, 1]);
    }
}
