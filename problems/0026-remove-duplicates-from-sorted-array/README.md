# 26. Remove Duplicates from Sorted Array

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/remove-duplicates-from-sorted-array/

Given an integer array `nums` sorted in **non-decreasing order**, remove the
duplicates **in-place** such that each unique element appears only **once**.
The **relative order** of the elements should be kept the **same**. Then return
the number of unique elements in `nums`.

Consider the number of unique elements of `nums` to be `k`; to get accepted,
you need to do the following things:

- Change the array `nums` such that the first `k` elements of `nums` contain
  the unique elements in the order they were present in `nums` initially. The
  remaining elements of `nums` are not important, as well as the size of `nums`.
- Return `k`.

**Custom Judge:** the judge tests your solution with

```
int[] nums = [...];             // Input array
int[] expectedNums = [...];     // The expected answer with correct length

int k = removeDuplicates(nums); // Calls your implementation

assert k == expectedNums.length;
for (int i = 0; i < k; i++) {
    assert nums[i] == expectedNums[i];
}
```

If all assertions pass, then your solution will be **accepted**.

**Example 1:**
```
Input:  nums = [1,1,2]
Output: 2, nums = [1,2,_]
```
Your function should return `k = 2`, with the first two elements of `nums`
being `1` and `2` respectively. It does not matter what you leave beyond the
returned `k` (hence they are underscores).

**Example 2:**
```
Input:  nums = [0,0,1,1,1,2,2,3,3,4]
Output: 5, nums = [0,1,2,3,4,_,_,_,_,_]
```

Constraints:
- `1 <= nums.length <= 3 * 10^4`
- `-100 <= nums[i] <= 100`
- `nums` is sorted in **non-decreasing** order.

## Approach

**Two-pointer (read/write) compaction — identical skeleton to
[283. Move Zeroes](../0283-move-zeroes/README.md), `O(n)` time, `O(1)` space.**

### Two things this problem is easy to get backwards on

- **Order.** The array is sorted **non-decreasing** (ties allowed, not
  strictly ascending), and survivors keep their original relative order —
  which, since the input already never drops, means the output stays
  non-decreasing too.
- **The return value.** `k` is the count of **unique elements**, not the
  count of duplicates removed. Trace `[1,1,2]`: exactly one duplicate gets
  removed, but the correct answer is `k = 2` — the count of survivors, not
  discards.

### The loop

```swift
var write = 1 // index 0 is always kept

for read in 1..<nums.count {
    if nums[read] != nums[write - 1] { // differs from the last kept value
        nums[write] = nums[read]
        write += 1
    }
}
return write
```

Same shape as 283: `read` is the clock, visiting every index once; `write` is
the next slot a *unique* value belongs in, advancing only when one is kept.
Because the input is sorted, "differs from the last **kept** value" is
equivalent to "differs from every value kept so far" — no need to look back
further than one slot.

### Constraint: hint or promise?

`1 <= nums.length` is a **promise**, not a hint — it guarantees index `0`
exists, so `write` can start at `1` unconditionally. An early draft carried a
defensive `guard !nums.isEmpty else { return 0 }`; that branch is dead code,
since the constraint makes it unreachable. Same lesson as
[283](../0283-move-zeroes/README.md) and
[724](../0724-find-pivot-index/README.md).

### Complexity

- **Time:** `O(n)` — one pass.
- **Space:** `O(1)` — two `Int` indices.

Verified: 12/12 local tests, and accepted on LeetCode (362/362 judge cases,
0ms runtime, beats 100%).

## Reflection

Solved across two short, time-boxed sessions. The GOAL step surfaced two real
misconceptions, not one: "non-decreasing" was first read as "descending" (a
vocabulary gap, resolved by definition + example trace), and the return value
was first modeled as "count of duplicates removed" rather than "count of
uniques kept" — caught only by tracing the concrete example against the
README's own stated answer (`k = 2` for `[1,1,2]`), not by inspection alone.

**Transfer from 283 was real.** Once the read/write skeleton was named,
writing the loop took minutes — B (identify) was the expensive step, C
(write) was fast. Matches 283's own note that 26 and 27 reuse its skeleton
unchanged, just with a different keep-condition.

**Environment note, unrelated to the algorithm:** the first `swift test` run
failed for reasons that had nothing to do with this code — `xcode-select`
was pointed at an installed Xcode 27 beta whose SDK doesn't compile under
plain SwiftPM. Fixed per-invocation with
`DEVELOPER_DIR=/Applications/Xcode-26.6.0.app/Contents/Developer` rather than
changing the global toolchain. Worth remembering for every other leaf in this
repo until that beta issue resolves.

## Solutions

Swift is the source of truth; the rest are translations.

| Language | Harness | Run from the leaf |
|----------|---------|-------------------|
| Swift  | SwiftPM + Swift Testing  | `swift test` |

## Idiom notes

_What each language made me see when translating from Swift (fill in as you go):_
