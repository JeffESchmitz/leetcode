# 15. 3Sum

**Difficulty:** Medium
**Link:** https://leetcode.com/problems/3sum/

Given an integer array `nums`, return all the triplets
`[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and
`nums[i] + nums[j] + nums[k] == 0`.

Notice that the solution set must not contain duplicate triplets.

**Example 1:**
```
Input:  nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
```
nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.
nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0.
nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.
The distinct triplets are `[-1,0,1]` and `[-1,-1,2]`.
Notice that the order of the output and the order of the triplets does not
matter.

**Example 2:**
```
Input:  nums = [0,1,1]
Output: []
```
The only possible triplet does not sum up to 0.

**Example 3:**
```
Input:  nums = [0,0,0]
Output: [[0,0,0]]
```
The only possible triplet sums up to 0.

Constraints:
- `3 <= nums.length <= 3000`
- `-10^5 <= nums[i] <= 10^5`

## Restated

> Return every set of three numbers from **different positions** that sum to
> **zero**, where two triplets with the **same values** (in any order) count
> only once.

The statement has **two rules that look through different lenses**:

| Rule | Looks at | Means |
|---|---|---|
| `i != j`, `i != k`, `j != k` | **positions** | don't reuse the same slot inside one triplet |
| "no duplicate triplets" | **values** | the same three numbers count once, in any order |

In example 1, `[-1, -1, 2]` is legal: the two `-1`s come from index 0 and
index 4, two different slots. But `(0, 1, 2)` gives `[-1, 0, 1]` and
`(1, 2, 4)` gives `[0, 1, -1]`: different positions, same values, so it is one
answer, not two.

**Picking** the three is a positions question. **Reporting** them is a values
question.

## Approach

**Sort, anchor one number, and run 167's converging two pointers on the rest.
`O(n²)` time, `O(1)` extra space beyond the sort and the output.**

**Brute force** tries every `i < j < k`: about `n³ / 6`, roughly 4.5 billion
triplets at `n = 3000`. Too slow.

**Reduce to a problem already solved.** Anchor one number (clamp it like a
capo) and the other two must sum to its negative. Anchor `-4` and the other
two must sum to `+4`. That is Two Sum, and there are two known ways to solve it:

| Problem | How | Relies on |
|---|---|---|
| [1. Two Sum](../0001-two-sum/README.md) | dictionary of seen values, ask for `target - x` | nothing, works unsorted |
| [167. Two Sum II](../0167-two-sum-ii-input-array-is-sorted/README.md) | converging pointers: too small, move left; too big, move right | the input is **sorted** |

**3Sum does not promise sorted, so make the promise true yourself.** Sorting
is safe here because the answer is values, not positions: nothing depends on
where a number started. And it is cheap: one `O(n log n)` sort is dwarfed by the
`O(n²)` that follows.

**Sorting pays twice.** It makes 167's move legal, and it puts **equal values
side by side**, which makes duplicates cheap to skip:

- **Anchor duplicates:** if `nums[i] == nums[i - 1]`, this anchor would find the
  same triplets as the last one. Skip it (guard with `i > 0`).
- **Pointer duplicates:** after a match, move each pointer past every copy of
  the value it just used. Otherwise `[-2, -2, 0, 0, 2, 2]` reports `[-2, 0, 2]`
  twice.

A `Set` of sorted triplets would also remove duplicates correctly. Neighbor
comparison does it with no hashing and no extra storage, and it is what
interviewers usually expect.

**Cost:** `n` anchors × about `n` pointer steps each = `O(n²)`, about 9 million
steps at `n = 3000`. That is about 500 times fewer than brute force.

### Pseudocode

```
sort nums

for each anchor i:
    skip if i > 0 and nums[i] == nums[i - 1]        // anchor dupes

    left = i + 1                                     // never reuse the anchor's slot
    right = nums.count - 1

    while left < right:
        sum = nums[i] + nums[left] + nums[right]

        if sum < 0:  left += 1                       // too small: bigger
        else if sum > 0:  right -= 1                 // too big: smaller
        else:
            record [nums[i], nums[left], nums[right]]
            move left past every copy of the value it used
            move right past every copy of the value it used

return all recorded triplets
```

## Reflection

**2026-09-28, one sitting split by a work meeting. Solved, not cold.** Every
piece of the algorithm was derived through questions, but the coach wrote the
full pseudocode on request, and Copilot helped with the Swift. Due a cold
re-solve in a few days.

### What went well

- **Cost, unaided.** "n anchors, n steps each, so n squared."
- **Anchor duplicates, unaided, in one line:** "compare it to the previous
  number, skip if same." Then wrote the `i > 0` guard correctly, keeping the
  index (`i > 0`) and the value (`nums[i] == nums[i - 1]`) apart.
- **Pointer duplicates, derived and generalized:** "keep moving left until a
  different value is found... can't we apply this same procedure to right?"
  Seeing the mirror without being told is the skill.
- **Asked for definitions instead of guessing.** "What does 'fix' mean?" and
  "what is `repeat`?" Both questions were cheap and each unblocked the next
  step.
- **Noticed "set" in the restatement** and asked if it was a hint. It was the
  right word (order doesn't matter, no repeats).

### What we missed, and how it was caught

- **The two lenses swapped at GOAL.** The first full restatement said
  "two triplets with the same **indexes** count only once." Caught by testing
  the sentence against the example: under that rule `[-1, 0, 1]` and
  `[0, 1, -1]` would both be kept, and the expected output has two triplets,
  not three. Also "equal zero" for "sum to zero," a small echo of 11's
  "sum of heights" slip.
- **Index vs value, live:** the two `-1`s at index 0 and 4 first looked like
  they broke `i != j`. They don't: the rule is about slots, not contents.
- **The pinned promise was dropped in code.** The comment at the top said
  "nums is NOT sorted, so sort it first," and the code never sorted. This is
  **the 167 lesson again**: spot the promise, then lose it. Pinning it as a
  comment helped (it was still on the page to point at), but a comment is not
  an action. **Next time: write the line of code that keeps the promise
  directly under the comment, before anything else.**
- **`result` was never declared.** The compiler caught it; cheap.
- **Couldn't name the Two Sum problems** from a fill-in-the-blank. The blank
  wanted a problem number and the prompt didn't say so. Once both were named
  with titles, the reduction was obvious.
- **"When do I pay for `.sort()`?"** Felt unknowable. Now it's a three-question
  test (below).
- **Comments said *what*, not *why*.** Two branch comments were also inaccurate
  without the sort ("need a larger number, so move left" is only true when
  sorted, and it's "larger **or equal**," because sorted means non-decreasing).

### Where the time went

- **A (understanding):** moderate. Values were read right from the start; the
  positions-vs-values split took two passes.
- **B (identifying):** the largest chunk. The reduction to Two Sum needed two
  prompts, "fix" needed a definition, and the sort decision needed a rule.
- **C (writing):** fast once pseudocode existed, with two bugs (no `result`,
  no sort), both found on the first run.

### Watch out for next time

1. **Two lenses in one statement.** When a problem has both an index rule and
   a duplicate rule, ask of each: *slots or contents?*
2. **Pinned promise, unkept.** A promise that needs an action (sort, guard,
   `+ 1` at the boundary) gets its line of code written right under the
   comment, immediately.
3. **Jargon is not a failure to understand.** "Fix" means *hold still*, not
   *repair*. Ask, as this session did.
4. **"Larger" in a sorted array means "larger or equal."** Non-decreasing
   allows repeats; that's exactly why the duplicate skips exist.

### Wisdom worth keeping

- **When to pay for `.sort()`: the three-question test.**

  | Ask | If yes |
  |---|---|
  | Does the answer need original positions? (indices, width) | don't sort (1, 11) |
  | Does order carry meaning? (subarray, window, contiguous) | don't sort (3, 643) |
  | Is the rest already `O(n log n)` or slower? | the sort is free (15) |

  It's the positions-vs-values lens again: an answer made of **values** lets
  you sort, an answer made of **positions** doesn't.
- **Anchor one, reduce to a solved problem.** 3Sum is anchor + Two Sum. The
  same move makes 4Sum anchor + 3Sum, and so on: each anchor costs one more
  factor of `n`.
- **Sorted means duplicates are neighbors.** "Have I seen this value?" becomes
  "is it the same as the one before?", with no `Set`.
- **One best vs a whole collection.** 11 returns one number, so it keeps a
  running `maxWater`. 15 returns every triplet, so it just appends. (The same
  tell showed up in the 977 Read One the same morning.)

## Idiom notes

### Swift

- **Shadow the parameter to sort it:** `let nums = nums.sorted()`. Parameters
  are `let`, so there is no in-place sort; shadowing keeps the name and
  guarantees nothing below touches the unsorted original.
- **`repeat { } while` is Swift's do-while**: the body runs first, then the
  condition, so it runs at least once. It fits "move once, then keep moving
  past duplicates" exactly. The two-step form (`left += 1` then a `while`) is
  equivalent and gives the first move its own breakpoint.
- **`[[Int]]` output with the triplet built from values**,
  `[nums[i], nums[left], nums[right]]`, never from indices.
