import Testing
@testable import NumberOfIslands

@Suite("Number of Islands")
struct NumberOfIslandsTests {
    private let solution = Solution()

    @Test("example 1: one large island")
    func example1() {
        let grid: [[Character]] = [["1", "1", "1", "1", "0"],
                                   ["1", "1", "0", "1", "0"],
                                   ["1", "1", "0", "0", "0"],
                                   ["0", "0", "0", "0", "0"]]

        #expect(solution.numIslands(grid) == 1)
    }

    @Test("example 2: three separate islands")
    func example2() {
        let grid: [[Character]] = [["1", "1", "0", "0", "0"],
                                   ["1", "1", "0", "0", "0"],
                                   ["0", "0", "1", "0", "0"],
                                   ["0", "0", "0", "1", "1"]]

        #expect(solution.numIslands(grid) == 3)
    }

    @Test("all water")
    func allWater() {
        let grid: [[Character]] = [["0", "0"],
                                   ["0", "0"]]

        #expect(solution.numIslands(grid) == 0)
    }

    @Test("all land is one island")
    func allLand() {
        let grid: [[Character]] = [["1", "1"],
                                   ["1", "1"]]

        #expect(solution.numIslands(grid) == 1)
    }

    @Test("single land cell")
    func singleCell() {
        #expect(solution.numIslands([["1"]]) == 1)
    }

    @Test("diagonal cells are separate islands")
    func diagonalsDoNotConnect() {
        let grid: [[Character]] = [["1", "0"],
                                   ["0", "1"]]

        #expect(solution.numIslands(grid) == 2)
    }

    @Test("checkerboard: every land cell is its own island")
    func checkerboard() {
        let grid: [[Character]] = [["1", "0", "1"],
                                   ["0", "1", "0"],
                                   ["1", "0", "1"]]

        #expect(solution.numIslands(grid) == 5)
    }

    @Test("one winding island that touches every border")
    func snake() {
        let grid: [[Character]] = [["1", "1", "1", "0"],
                                   ["0", "0", "1", "0"],
                                   ["0", "1", "1", "0"],
                                   ["0", "1", "0", "0"]]

        #expect(solution.numIslands(grid) == 1)
    }
}
