import Testing
@testable import IslandPerimeter

@Suite("Island Perimeter")
struct IslandPerimeterTests {
    private let solution = Solution()

    @Test("example 1: plus-shaped island with a tail")
    func example1() {
        let grid = [[0, 1, 0, 0],
                    [1, 1, 1, 0],
                    [0, 1, 0, 0],
                    [1, 1, 0, 0]]

        #expect(solution.islandPerimeter(grid) == 16)
    }

    @Test("example 2: single land cell")
    func example2() {
        #expect(solution.islandPerimeter([[1]]) == 4)
    }

    @Test("example 3: single land cell next to water")
    func example3() {
        #expect(solution.islandPerimeter([[1, 0]]) == 4)
    }

    @Test("two land cells side by side share one edge")
    func twoCellsHorizontal() {
        #expect(solution.islandPerimeter([[1, 1]]) == 6)
    }

    @Test("two land cells stacked share one edge")
    func twoCellsVertical() {
        #expect(solution.islandPerimeter([[1], [1]]) == 6)
    }

    @Test("full 2x2 block")
    func square() {
        #expect(solution.islandPerimeter([[1, 1], [1, 1]]) == 8)
    }

    @Test("island touching the grid edge still counts the edge as water")
    func touchesBorder() {
        let grid = [[1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1]]

        #expect(solution.islandPerimeter(grid) == 12)
    }

    @Test("a straight line of land")
    func line() {
        #expect(solution.islandPerimeter([[1, 1, 1, 1]]) == 10)
    }
}
