/// LeetCode 733. Flood Fill
/// https://leetcode.com/problems/flood-fill/
public struct Solution {
    public init() {}

    public func floodFill(_ image: [[Int]], _ sr: Int, _ sc: Int, _ color: Int) -> [[Int]] {
        var image = image
        let originalColor = image[sr][sc]

        // Same color as the paint: nothing to change, and painting would never
        // mark a cell as visited, so the fill would recurse forever.
        guard originalColor != color else { return image }

        // Depth-first fill. Painting a cell is the visited marker; the color
        // check on re-entry is what stops the recursion.
        func fill(_ row: Int, _ column: Int) {
            guard image.indices.contains(row),
                  image[row].indices.contains(column)
            else { return }

            guard image[row][column] == originalColor else { return }

            image[row][column] = color

            fill(row - 1, column) // up
            fill(row + 1, column) // down
            fill(row, column - 1) // left
            fill(row, column + 1) // right
        }

        fill(sr, sc)
        return image
    }
}
