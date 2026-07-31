/// LeetCode 70. Climbing Stairs
///
/// You are climbing a staircase. It takes `n` steps to reach the top.
/// Each time you can either climb `1` or `2` steps.
/// Return the number of distinct ways to climb to the top.
public struct Solution {
    public func climbStairs(_ n: Int) -> Int {
        // 1, Cover the base cases first

        // step 1, 
        // If there is only one step, there is only one way to climb it.
        if n == 1 {
            return 1
        }

        // step 2, 
        // if there are two steps, there are two ways to climb it: (1+1) or (2).
        if n == 2 {
            return 2
        }

        // 2. Use dynamic programming to calculate 
        // the number of ways to climb to the top.

        // these two variables will hold the number of 
        // ways to reach the previous two steps.
        var prev2 = 1 // The answer for the smaller step we already know (calculated).
        var prev1 = 2 // The answer for the smaller step we already know (calculated).
    
    
        // We already know the answers for step 1 and step 2, covered in point 1.
        // Starting from step 3, each new answer depends only on the two previous answers:
        // ways(n) = ways(n - 1) + ways(n - 2).
        // So we keep rolling forward with the last two values instead of storing the whole history.
        for _ in 3...n {
            let current = prev1 + prev2
            prev2 = prev1
            prev1 = current
        }

        return prev1
    }
}
