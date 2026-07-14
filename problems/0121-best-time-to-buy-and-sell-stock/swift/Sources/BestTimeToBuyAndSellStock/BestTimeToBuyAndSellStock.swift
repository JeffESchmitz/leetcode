/// LeetCode 121. Best Time to Buy and Sell Stock
///
/// Returns the maximum profit achievable from a single buy/sell transaction
/// over `prices`, or 0 if no profit is possible.
public func maxProfit(_ prices: [Int]) -> Int {
    var lowestPrice = prices[0]
    var bestProfit = 0

    for price in prices {
        if price < lowestPrice {
            lowestPrice = price
        } else if price - lowestPrice > bestProfit {
            bestProfit = price - lowestPrice
        }
    }
    
    return bestProfit
}
