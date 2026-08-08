# 169. Majority Element

**Difficulty:** Easy
**Link:** [https://leetcode.com/problems/majority-element/](https://leetcode.com/problems/majority-element/)

## Problem

Given an array `nums` of size `n`, return *the majority element*.

The majority element is the element that appears more than `⌊n / 2⌋` times. You may assume that the majority element always exists in the array.

**Example 1:**
```
Input: nums = [3,2,3]
Output: 3
```

**Example 2:**
```
Input: nums = [2,2,1,1,1,2,2]
Output: 2
```

**Constraints:**
- `n == nums.length`
- `1 <= n <= 5 * 10^4`
- `-10^9 <= nums[i] <= 10^9`

**Follow-up:** Could you solve the problem in linear time and in `O(1)` space?

## Approach

_Worked through the 8-step framework from `COACH.md`. Filled in as we go._

1. **GOAL** — _TBD_
2. **SHAPE** — _TBD_
3. **CONSTRAINTS** — _TBD_
4. **SIGNATURE** — _TBD_
5. **EXAMPLE TRACE** — _TBD_
6. **PATTERN → ALGORITHM** — _TBD_
7. **EDGE CASES** — _TBD_
8. **DATA STRUCTURES** — _TBD_

**This is a [PATTERN] problem solved with [ALGORITHM] in [BIG-O].**

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Test fixtures

Every fixture honors the problem's guarantee that a majority element exists, so
no test depends on undefined behavior when it doesn't.

| Case | Why it's there |
|---|---|
| `[3,2,3]`, `[2,2,1,1,1,2,2]` | the two given examples |
| `[1]` | smallest legal input; the lone element is trivially the majority |
| `[4,4]` | even `n`: 2 > ⌊2/2⌋ = 1 |
| `[7,7,7,7]` | no minority elements at all |
| `[5,5,5,1,2]` / `[1,2,5,5,5]` | majority bunched at one end — catches position assumptions |
| `[1,2,1,2,1]` | majority never appears twice in a row — kills "longest run" thinking |
| `[-1,-1,-1,2,3]` | negative values |
| 1001 elements, interleaved | majority clears ⌊n/2⌋ by exactly one vote, maximally spread out |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_

- **Swift** — _TBD_
