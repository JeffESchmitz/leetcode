import Testing
@testable import ThreeSum

@Suite("3Sum")
struct ThreeSumTests {
    private let solution = Solution()

    /// The order of the triplets, and of the numbers inside each triplet, does
    /// not matter. Sort both so any valid answer compares equal.
    private func normalized(_ triplets: [[Int]]) -> [[Int]] {
        let sortedInside = triplets.map { $0.sorted() }
        return sortedInside.sorted { $0.lexicographicallyPrecedes($1) }
    }

    /// Slow but obviously correct: try every i < j < k, keep unique triplets.
    private func bruteForce(_ nums: [Int]) -> [[Int]] {
        var seen: Set<[Int]> = []
        for i in 0..<nums.count {
            for j in (i + 1)..<nums.count {
                for k in (j + 1)..<nums.count {
                    if nums[i] + nums[j] + nums[k] == 0 {
                        seen.insert([nums[i], nums[j], nums[k]].sorted())
                    }
                }
            }
        }
        return normalized(Array(seen))
    }

    @Test("example 1: [-1,0,1,2,-1,-4] -> [[-1,-1,2],[-1,0,1]]")
    func example1() {
        let result = solution.threeSum([-1, 0, 1, 2, -1, -4])
        #expect(normalized(result) == [[-1, -1, 2], [-1, 0, 1]])
    }

    @Test("example 2: [0,1,1] -> [], no triplet sums to 0")
    func example2() {
        #expect(solution.threeSum([0, 1, 1]).isEmpty)
    }

    @Test("example 3: [0,0,0] -> [[0,0,0]]")
    func example3() {
        #expect(normalized(solution.threeSum([0, 0, 0])) == [[0, 0, 0]])
    }

    @Test("four zeros still give one triplet: no duplicates")
    func fourZeros() {
        #expect(normalized(solution.threeSum([0, 0, 0, 0])) == [[0, 0, 0]])
    }

    @Test("all positive: nothing can reach 0")
    func allPositive() {
        #expect(solution.threeSum([1, 2, 3, 4]).isEmpty)
    }

    @Test("all negative: nothing can reach 0")
    func allNegative() {
        #expect(solution.threeSum([-4, -3, -2, -1]).isEmpty)
    }

    @Test("same smallest number, two different partner pairs")
    func twoPairsForOneAnchor() {
        let result = solution.threeSum([-2, 0, 1, 1, 2])
        #expect(normalized(result) == [[-2, 0, 2], [-2, 1, 1]])
    }

    @Test("duplicates everywhere collapse to one triplet")
    func duplicatesEverywhere() {
        let result = solution.threeSum([-2, -2, 0, 0, 2, 2])
        #expect(normalized(result) == [[-2, 0, 2]])
    }

    @Test("matches brute force on a fixed pseudo-random array")
    func matchesBruteForce() {
        // Deterministic linear congruent generator, values in -10...10,
        // so there are many duplicates and many triplets.
        var state = 12345
        var nums: [Int] = []
        for _ in 0..<60 {
            state = (state * 1_103_515_245 + 12345) % 2_147_483_648
            nums.append(state % 21 - 10)
        }
        #expect(normalized(solution.threeSum(nums)) == bruteForce(nums))
    }

    @Test("3000 zeros, the max length: one triplet, and fast")
    func maxLengthZeros() {
        let nums = Array(repeating: 0, count: 3000)
        #expect(normalized(solution.threeSum(nums)) == [[0, 0, 0]])
    }
}
