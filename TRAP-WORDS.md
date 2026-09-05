# Trap Words

Words in problem statements that have two readings. One reading describes a
**position** ("has this happened yet as I walk?"); the other describes the
**whole input** ("what is true of this element across everything?"). They give
different problems. The examples always settle which one is meant.

**The reflex:** when one of these words appears, trace an example out loud
*before* anything else, and end with "is that right?" In an interview the
interviewer is a free oracle for this. Solo, the examples are.

| Word | Position reading (usually wrong) | Whole-input reading (usually right) | Bitten by | Date |
|---|---|---|---|---|
| **non-repeating / unique** | "first letter before any repeat shows up" | "letter whose total count is exactly 1" | 387 | 2026-09-05 |
| **repeat / duplicate** | "the second time I see it" | "any element with count > 1, including its first copy" | 387 | 2026-09-05 |
| **distinct** | — | "count of different values, not count of elements" | — | |
| **subarray vs subsequence** | — | subarray is contiguous; subsequence keeps order but skips | 3, 643 | |
| **in-place** | — | mutate the input; return value may be a length, not the array | 26, 283 | |
| **return the index vs the value** | — | read the signature; example output tells you which | 387, 1 | |
| **first / leftmost** | "first event while walking" | "leftmost among things that qualify over the whole input" | 387 | 2026-09-05 |

Add a row the moment a word costs you time. Include the problem number and the
date so the list doubles as a record of what has actually bitten you, not what
might.

## Rewording drill

A statement is understood when you can rewrite it without the trap word and it
reads like an algorithm. Today's example:

> Original: "find the first non-repeating character in it and return its index."
>
> Reworded: "For each distinct letter, count how many times it occurs across the
> entire string. Then walk left to right and stop at the first position whose
> letter has a count of 1. Return that position, or -1 if you never stop."
