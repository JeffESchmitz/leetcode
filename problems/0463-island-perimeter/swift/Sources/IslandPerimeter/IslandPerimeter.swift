/// LeetCode 463. Island Perimeter
/// https://leetcode.com/problems/island-perimeter/
public struct Solution {
    public init() {}

    public func islandPerimeter(_ grid: [[Int]]) -> Int {
        // A side is exposed if the neighbor on that side is off the board or water.
        func isExposed(_ row: Int, _ col: Int) -> Bool {
            guard
                grid.indices.contains(row),
                grid[row].indices.contains(col)
            else {
                return true
            }

            return grid[row][col] == 0
        }

        func exposedSides(_ row: Int, _ col: Int) -> Int {
            var count = 0

            // up
            if isExposed(row - 1, col) {
                count += 1
            }

            // down
            if isExposed(row + 1, col) {
                count += 1
            }

            // left
            if isExposed(row, col - 1) {
                count += 1
            }

            // right
            if isExposed(row, col + 1) {
                count += 1
            }

            return count
        }

        var perimeter = 0
        for row in grid.indices {
            for col in grid[row].indices {
                if grid[row][col] == 1 {
                    perimeter += exposedSides(row, col)
                }
            }
        }
        return perimeter
    }
}
