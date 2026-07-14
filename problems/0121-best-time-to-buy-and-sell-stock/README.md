# 121. Best Time to Buy and Sell Stock

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/best-time-to-buy-and-sell-stock/

You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`-th day.

You want to maximize your profit by choosing a **single day** to buy one stock and choosing a **different day in the future** to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return `0`.

## Approach

Worked through the 8-step framework from `COACH.md`:

1. **GOAL** — return an `Int`: the max profit (`sellPrice - buyPrice`) from one buy day
   plus one later sell day. Return `0` if no profitable trade exists.
2. **SHAPE** — `prices: [Int]`, where `prices[i]` is the stock price on day `i`.
3. **CONSTRAINTS** — sell day must be strictly *after* buy day; `1 <= prices.length <= 10^5`;
   `0 <= prices[i] <= 10^4`. Brute-forcing every buy/sell pair is O(n²) — at
   `n = 10^5` that's ~`10^10` ops, way past a ~1s judge budget. Need better than O(n²).
4. **SIGNATURE** — `func maxProfit(_ prices: [Int]) -> Int`
5. **EXAMPLE TRACE** — `[7, 1, 5, 3, 6, 4]`, tracking lowest price seen so far and best
   profit seen so far, day by day:

   | Day | Price | Lowest so far | Profit if sold today | Best profit so far |
   |---|---|---|---|---|
   | 0 | 7 | 7 | 0 | 0 |
   | 1 | 1 | 1 | 0 | 0 |
   | 2 | 5 | 1 | 4 | 4 |
   | 3 | 3 | 1 | 2 | 4 |
   | 4 | 6 | 1 | 5 | 5 |
   | 5 | 4 | 1 | 3 | 5 |

   Ends at `5`, matching the expected output.
6. **PATTERN → ALGORITHM** — single-pass / greedy scan, same family as **Kadane's
   algorithm** (max subarray sum), just applied to the running "profit if sold today"
   instead of a running sum. O(n) time.
7. **EDGE CASES** — single-element array (no valid trade, profit `0`), strictly
   descending prices (`0`), strictly ascending prices, a dip after an early high (the
   early high is a trap — don't buy there), profit only realized right at the end.
8. **DATA STRUCTURES** — two scalar variables (lowest price seen so far, best profit
   seen so far) — O(1) space, no array/map/stack needed.


## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** — Tried rewriting the `for` loop as `prices.dropFirst().reduce(...)`, threading
  a `(lowestPrice, bestProfit)` state through the sequence. It worked, but needed a
  wrapper `ProfitState` struct just to hold two fields, plus a `guard let first` to seed
  the initial value — more ceremony than the plain `for` loop with two `var`s. Lesson:
  `.reduce`/`.map` read great when the accumulator is naturally *one* value; a
  multi-field running accumulator is often a sign the imperative loop is the more
  idiomatic choice, not something to "upgrade" away from. Kept the `for` loop version.
