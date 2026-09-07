import Testing
@testable import FloodFill

@Suite("Flood Fill")
struct FloodFillTests {
    private let solution = Solution()

    @Test("example 1: connected region recolored, diagonal corner untouched")
    func example1() {
        let image = [[1, 1, 1],
                     [1, 1, 0],
                     [1, 0, 1]]
        let expected = [[2, 2, 2],
                        [2, 2, 0],
                        [2, 0, 1]]

        #expect(solution.floodFill(image, 1, 1, 2) == expected)
    }

    @Test("example 2: new color equals original color, image unchanged")
    func example2() {
        let image = [[0, 0, 0],
                     [0, 0, 0]]

        #expect(solution.floodFill(image, 0, 0, 0) == image)
    }

    @Test("single pixel")
    func singlePixel() {
        #expect(solution.floodFill([[5]], 0, 0, 9) == [[9]])
    }

    @Test("start on a pixel that has no same-colored neighbors")
    func isolatedStart() {
        let image = [[1, 2, 1],
                     [2, 3, 2],
                     [1, 2, 1]]
        let expected = [[1, 2, 1],
                        [2, 7, 2],
                        [1, 2, 1]]

        #expect(solution.floodFill(image, 1, 1, 7) == expected)
    }

    @Test("a separate region of the same color is left alone")
    func disconnectedSameColorRegion() {
        let image = [[1, 0, 1],
                     [1, 0, 1],
                     [1, 0, 1]]
        let expected = [[4, 0, 1],
                        [4, 0, 1],
                        [4, 0, 1]]

        #expect(solution.floodFill(image, 0, 0, 4) == expected)
    }

    @Test("fill snakes through a winding path")
    func windingPath() {
        let image = [[1, 1, 1, 1],
                     [0, 0, 0, 1],
                     [1, 1, 1, 1],
                     [1, 0, 0, 0]]
        let expected = [[3, 3, 3, 3],
                        [0, 0, 0, 3],
                        [3, 3, 3, 3],
                        [3, 0, 0, 0]]

        #expect(solution.floodFill(image, 3, 0, 3) == expected)
    }

    @Test("whole image is one region")
    func entireImage() {
        let image = [[7, 7],
                     [7, 7]]

        #expect(solution.floodFill(image, 1, 1, 1) == [[1, 1], [1, 1]])
    }

    @Test("start at a corner, fill stays on the edge column")
    func edgeColumn() {
        let image = [[2, 9, 9],
                     [2, 9, 9],
                     [2, 2, 9]]
        let expected = [[6, 9, 9],
                        [6, 9, 9],
                        [6, 6, 9]]

        #expect(solution.floodFill(image, 0, 0, 6) == expected)
    }
}
