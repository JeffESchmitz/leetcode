import Testing
@testable import BestTimeToBuyAndSellStock

@Suite
struct BestTimeToBuyAndSellStockTests {
    @Test func example1() {
        #expect(maxProfit([7, 1, 5, 3, 6, 4]) == 5)
    }

    @Test func example2NoProfit() {
        #expect(maxProfit([7, 6, 4, 3, 1]) == 0)
    }

    @Test func singleDay() {
        #expect(maxProfit([1]) == 0)
    }

    @Test func twoDaysAscending() {
        #expect(maxProfit([1, 2]) == 1)
    }

    @Test func twoDaysDescending() {
        #expect(maxProfit([2, 1]) == 0)
    }

    @Test func allSamePrice() {
        #expect(maxProfit([3, 3, 3, 3]) == 0)
    }

    @Test func strictlyIncreasing() {
        #expect(maxProfit([1, 2, 3, 4, 5]) == 4)
    }

    @Test func profitAtVeryEndAfterDip() {
        #expect(maxProfit([5, 4, 3, 2, 8]) == 6)
    }

    @Test func bestBuyIsAfterAnEarlyHigh() {
        #expect(maxProfit([9, 1, 2]) == 1)
    }
}
