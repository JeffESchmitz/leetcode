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
> Already solved (skip these): 1, 3, 9, 13, 20, 21, 26, 70, 100, 104, 111, 121,
> 125, 136, 141, 160, 169, 202, 206, 217, 226, 242, 283, 387, 496, 643, 704,
> 724, 771, 876, 1046, 1979.

## Log

Keep a running tally here. One line per session.

| Date | Problems | Wrong on first restate | Trap word |
|---|---|---|---|
| 2026-09-05 | 387 (live, coached by Grok) | 1 of 1 | non-repeating |
