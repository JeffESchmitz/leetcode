# Pattern Card

A one-page lookup from **what the problem looks like** to **what structure solves it**,
built only from problems already solved in this repo. The point is recognition speed:
naming the shelf in ten seconds so the rest of the interview is transcription.

Rules for this file:

- One row per pattern, in Jeff's words. Rewrite rows freely; they are yours.
- Add a row only after solving a problem that needed it. No aspirational rows.
- The **Tell** column is the thing to train. It is what the problem *says* or
  *looks like* before you know the answer.

| Tell (what the statement looks like) | Pattern | Structure / move | Big-O | Solved here |
|---|---|---|---|---|
| "How many times does each X appear?" / "first unique" / "anagram" | **Tally, then scan** | dictionary or fixed array of counts, second pass reads it | O(n) | 387, 242 |
| "Is X in the set?" / "contains duplicate" / "jewels" | **Membership lookup** | hash set, precompute once then ask | O(n) | 217, 771 |
| "Find two things that add to target" | **Complement lookup** | hash map of seen values, ask for `target - x` | O(n) | 1 |
| Sorted input, find a value | **Binary search** | halve the range each step | O(log n) | 704 |
| In-place remove / compact / move-to-end | **Read/write two pointers** | write index trails read index | O(n) | 26, 283 |
| Compare from both ends / palindrome | **Converging two pointers** | left and right walk toward each other | O(n) | 125, 9 |
| "Longest substring/subarray with property" | **Variable sliding window** | grow right, shrink left when property breaks | O(n) | 3 |
| "Max/avg of every window of size k" | **Fixed sliding window** | running sum, add one, drop one | O(n) | 643 |
| "Sum to the left equals sum to the right" | **Prefix sum** | total once, running left sum | O(n) | 724 |
| "Best time to buy/sell" / max profit in one pass | **Running min + lookahead** | track lowest so far, compare each step | O(n) | 121 |
| Matching open/close, nested things | **Stack** | push on open, pop and compare on close | O(n) | 20 |
| "Next greater element" | **Monotonic stack** | stack keeps decreasing run, pop on bigger | O(n) | 496 |
| Element appearing more than n/2 times | **Boyer-Moore vote** | candidate + counter, cancel pairs | O(n), O(1) | 169 |
| Every element appears twice except one | **Symmetry cancellation (XOR)** | pairs cancel themselves out | O(n), O(1) | 136 |
| Linked list: middle / cycle / kth from end | **Fast & slow pointers** | one steps 1, one steps 2 | O(n), O(1) | 876, 141 |
| Linked list: reverse / merge | **Pointer rewiring with prev/current** | draw the memory first, then move one link | O(n) | 206, 21 |
| Two lists that share a tail | **Length alignment / pointer swap** | walk both, swap heads at the end | O(n+m) | 160 |
| "Ways to reach step n" | **Bottom-up DP (Fibonacci shape)** | each answer built from the previous two | O(n) | 70 |
| Tree: depth / equality / mirror | **Post-order DFS recursion** | solve children, combine at the node | O(n), O(h) | 100, 104, 111, 226 |
| Repeatedly take the two largest | **Max-heap** | pop, pop, push the difference | O(n log n) | 1046 |
| Digit loop that may cycle | **Cycle detection via seen set** | remember states, stop on repeat | — | 202 |
| Reduce a list with a known math subroutine | **Reduce to known algorithm** | Euclid's GCD | — | 1979 |
| Mapping symbols to values with a lookahead rule | **Table + one-step lookahead** | dictionary, compare with next | O(n) | 13 |

## How to use it in an interview

1. Restate the problem and trace an example (see `TRAP-WORDS.md`).
2. Scan the **Tell** column. Say the pattern name out loud: "this is a tally problem."
3. If nothing matches, say that too, and start with brute force. A named brute force
   beats a silent search for cleverness.
