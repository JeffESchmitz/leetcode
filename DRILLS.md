# Understanding Drills

Training for **A: Mean Time to Understanding**, in isolation. No code. No
pseudocode. The only output is a restatement and the expected answer for each
example. The bottleneck is seeing the problem, so this drills only that.

Designed for use with Claude.ai on a phone: walking, a soccer sideline, a
waiting room. Paste the prompt below, then go.

## The drill

For each problem, five minutes, out loud or typed:

1. **Restate** the problem in your own words without using any word from
   `TRAP-WORDS.md`. It should read like a two-step algorithm.
2. **Trace** every example given. State the output and one sentence of why.
3. **Name the pattern** from `PATTERNS.md`, or say "no match, brute force is ..."
4. Stop. Do not code.

The coach confirms or corrects the restatement, then moves to the next problem.
Score is not time; score is whether the first restatement was right.

## Prompt for Claude.ai

Paste this to start a session:

> You are running understanding drills for LeetCode interview prep. Give me one
> easy problem at a time, by number and title, with its full statement, examples,
> and constraints. I will restate it in my own words and give the expected
> output for each example. Do not let me code or pseudocode. Confirm my
> restatement or correct it with a counterexample, then ask me to name the
> algorithmic pattern in one phrase. Then move to the next problem. Pick
> problems I have not listed below. After ten problems, tell me which
> restatements were wrong on the first try and what word tripped me.
>
> Already solved (skip these): 1, 3, 9, 13, 20, 21, 26, 70, 88, 100, 104, 111, 121,
> 11, 15, 125, 136, 141, 160, 167, 169, 202, 206, 217, 226, 242, 283, 387, 463, 496,
> 643, 704, 724, 733, 771, 876, 1046, 1979.

## Log

Keep a running tally here. One line per session.

| Date | Problems | Wrong on first restate | Trap word |
|---|---|---|---|
| 2026-09-05 | 387 (live, coached by Grok) | 1 of 1 | non-repeating |
| 2026-09-07 | 733 (live, coached by Claude) | 1 of 1 | `sr`/`sc` read as a filter over all cells, not one start cell; ~20 min to understanding |
| 2026-09-21, 09-25 | 167 (live, coached by Claude) | 0 of 1 | none bit A; "non-decreasing" was spotted, then dropped, and cost ~1 hr of B |
| 2026-09-26 | 11 (live, coached by Claude) | 1 of 1 | water read as a **sum** of heights, not shorter height × width; then index/value and fencepost slips on width |
| 2026-09-27 | 11 cold re-run, understanding only (coached by Claude) | 0 of 1 on the reading; width still 6 not 7 | walls pictured as **blocks**, not lines; "peak" used as the reason to move instead of "shorter" |
| 2026-09-28 | 15 (live, coached by Claude) | 1 of 1 | the two lenses swapped: "same **indexes** count once" instead of same **values**; `i != j` briefly read as values |
| 2026-10-02 | 88 (live, coached by Claude) | partial: hung up repeatedly on `m` | not a word, a **variable**: `m` is a *count* of real values, which makes it also the index of the first open seat; it kept getting used as a place to read or write (`nums1[m]`). Then a hidden third pointer (`write`) was the B bottleneck |

## Re-solve queue

Cold re-solves, spaced out until the solution comes from memory. A re-solve
counts only if it's cold: no hints, no Copilot, no peeking.

| Problem | Why | Dates |
|---|---|---|
| 42 Trapping Rain Water | first Hard; 2h45 coached, code handed over | 10-01, 10-03, 10-07, 10-14, 10-28 |
| 15 3Sum | not cold on 09-28 | owed |
| 977 Squares of a Sorted Array | read, not solved | owed |

**The one piece of 42 to own:** walk 1's answers are gone by the time walk 2
needs them, so write them down in a strip (an array the same length as
`height`). Everything else in 42 was solved on 2026-09-30.

## Read One: the daily surface-area drill

**Goal: see more patterns, faster.** Each pattern has a small set of standard
solutions (six solutions to 11 were one algorithm with different variable
names), so reading solutions widens the set of patterns you recognize quickly.
It only sticks if **you explain why the solution works**; reading and nodding
feels like learning but doesn't stick.

About 10 minutes, once a day, alongside the day's problem:

1. **Pick a problem outside the Top 150** in the pattern currently being worked
   (list below). Never read solutions for a problem still ahead in the plan.
2. **Before opening any solution:** restate it without trap words and trace one
   example. This is the A-drill above, and it is the point.
3. **Guess** the pattern and the move in one sentence (for two pointers: which
   end can never do better?).
4. **Open the top two or three solutions.** Check the guess. Explain *why* it
   works out loud. Note where the solutions differ; that's idiom material.
5. **Log one line** below.

### Queue: Two Pointers (outside the Top 150)

| # | Problem | Difficulty | Notes |
|---|---|---|---|
| 344 | Reverse String | Easy | the simplest version of converging pointers |
| 977 | Squares of a Sorted Array | Easy | converging, filling the output from the back |
| 881 | Boats to Save People | Medium | sorted + greedy pairing |
| 1679 | Max Number of K-Sum Pairs | Medium | 167's move, repeated |
| 75 | Sort Colors | Medium | three pointers (Dutch national flag) |
| 16 | 3Sum Closest | Medium | 15 solved 2026-09-28, so this is unlocked: same skeleton, track closest instead of exact |

### Read One log

| Date | Problem | Guess right? | The tell |
|---|---|---|---|
| 2026-09-28 | 977 Squares of a Sorted Array (read, **not solved**) | half: "never the middle" by instinct, but guessed "left" with no reason; answer was given | squares make a **V** (high at both ends), so the biggest is always at an end; fill the output from the back |

### Read One notes

**977 Squares of a Sorted Array (2026-09-28).** Read, not solved. Snagged on
"non-decreasing" again (see `TRAP-WORDS.md`): it means *never goes down*,
repeats allowed.

- **Squaring measures distance from zero**, not sign. `-4` and `4` both square
  to 16, so there is no negative check and no `x -1`. Negatives are why the
  squares stop being sorted.
- **Why the biggest square is always at an end:** in a sorted array the values
  farthest from 0 sit at the two ends (most negative on the left, most positive
  on the right); the middle is closest to 0. Plotted, the squares make a **V**.
  Compare the two ends each step; it may be either side.
- **Fill from the back.** The answer runs smallest to biggest, but the pointers
  find the biggest first. Make a result of the same length, start `write` at
  the last slot, place the bigger end's square there, move `write` left.
  Because the pointers close in on the value nearest zero, the last square
  placed is the smallest and lands in slot 0: fill from the back, **end up with
  the smallest at the front**.
- **`left <= right`, not `<`.** 11 needs two walls; here every element,
  including the last one where the pointers meet, must land in the output.
- **No running best.** Contrast with 11's `maxWater`. The tell: *returns one
  best thing* means keep a running best; *returns a whole collection* means
  place each item where it belongs, and the slot (`write`) does the
  remembering.
- Brute force is square then sort, `O(n log n)`; the follow-up asks for `O(n)`.

Still owed: read the top solutions (do they compare `abs()` or the squares?)
and say "why the biggest is always at an end" in one sentence, unaided.
