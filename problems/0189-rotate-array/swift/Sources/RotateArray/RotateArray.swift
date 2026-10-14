// Promises: nums is non-empty and k is non-negative.
// Follow-up: rotate in place using O(1) extra space.
public struct Solution {
    public init() {}

    public func rotate(_ nums: inout [Int], _ k: Int) {
        // Calculate the shift value
        let shift = k % nums.count

        // if shift is zero, stop, as the array is already correctly rotated
        if shift == 0 {
            return
        }

        // Reverse the entire array
        reverseRange(&nums, firstPos: 0, lastPos: nums.count - 1)

        // Reverse the first shift elements.
        reverseRange(&nums, firstPos: 0, lastPos: shift - 1)
        // Reverse the remaining elements.
        reverseRange(&nums, firstPos: shift, lastPos: nums.count - 1)
    }

    func reverseRange(_ nums: inout [Int], firstPos: Int, lastPos: Int) {
        var left = firstPos
        var right = lastPos

        while left < right {
            nums.swapAt(left, right)
            left += 1
            right -= 1
        }
    }
}
