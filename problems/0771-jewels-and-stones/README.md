# 771. Jewels and Stones

**Difficulty:** Easy
**Link:** https://leetcode.com/problems/jewels-and-stones/

You're given strings `jewels` representing the types of stones that are jewels,
and `stones` representing the stones you have. Each character in `stones` is a
type of stone you have. You want to know how many of the stones you have are
also jewels.

Letters are **case sensitive**, so `"a"` is considered a different type of
stone from `"A"`.

**Example 1:**
```
Input:  jewels = "aA", stones = "aAAbbbb"
Output: 3
```

**Example 2:**
```
Input:  jewels = "z", stones = "ZZ"
Output: 0
```

Constraints:
- `1 <= jewels.length, stones.length <= 50`
- `jewels` and `stones` consist of only English letters.
- All the characters of `jewels` are **unique**.

## Approach

> **Spoiler — collapsed on purpose.** This problem is already solved in `go/`.
> The Swift leaf is a deliberate **memory test**: attempt it from scratch
> first, then open this to compare. Retrieving an answer from memory is what
> consolidates it; re-reading one feels productive and consolidates far less.

<details>
<summary>Show the approach</summary>


**This is a membership-lookup problem solved with a hash set in
`O(j + s)` time and `O(j)` space.**

### The bottleneck operation

Read the question as a loop and the cost falls out: *for each stone, is it a
jewel?* That inner question runs once per stone — up to 50 times — and how you
answer it is the entire design decision.

```
for each stone:              ← runs s times
    is it in jewels?         ← THIS is the operation to make cheap
```

Scanning the `jewels` string for each stone is `O(j)` per check, giving
`O(s × j)` overall. Loading `jewels` into a **hash set** once makes each check
`O(1)`, giving `O(j + s)` — the `COACH.md` rule again: **precompute once, then
look answers up**, turning a `×` into a `+`.

`Operation frequency × operation cost = total time.` Here the frequency is
fixed by the problem; only the cost is yours to choose.

### Honest note: the constraints do not force this

At `j, s <= 50`, brute force is at most `2,500` operations and passes
instantly. This is **not** a case where the constraint kills the naive
approach — unlike
[643](../0643-maximum-average-subarray-i/README.md), where `O(n × k)` genuinely
had to go.

The hash set is still the right call, for a different reason: it **says what
the code means**. "Membership in a set" is the actual concept in the problem
statement, and a set expresses it directly, where a nested scan makes the
reader reconstruct the intent. Pick the structure that names the idea; the
`O()` improvement is a bonus that happens to be free.

### Constraints: hint or promise?

| Constraint | Verdict | Consequence |
|---|---|---|
| `1 <= lengths <= 50` | **hint** | tiny — almost anything passes. Notably it does *not* force the hash set |
| `1 <=` (lower bound) | **promise** | neither string is empty, so no empty guard is needed. Both loops would also handle empty correctly anyway |
| only English letters | **hint** | bounds the alphabet at 52, so a fixed-size array or bitmask would also work |
| **all `jewels` chars unique** | **promise the algorithm does not need** | a set deduplicates for free. This would be load-bearing for a *counting* approach; here it costs nothing to ignore |

That last row is the interesting one. A constraint being a promise doesn't
mean your algorithm has to *use* it — this one would matter if you were
tallying multiplicities, but a set makes it irrelevant. Noticing that a
promise is unused is a signal you picked a structure that sidesteps a whole
class of bug.

### Complexity

- **Time:** `O(j + s)` — one pass to build the set, one pass to check. Sequential
  loops add; they do not multiply.
- **Space:** `O(j)` for the set, bounded at 52 by the alphabet constraint, so
  effectively `O(1)`.

### Case sensitivity

`"a"` and `"A"` are different stones. Nothing in the solution needs to *do*
anything about this — comparing characters directly already respects case.
The trap is only for anyone who reaches for a normalizing `lowercased()` out
of habit. Example 2 (`jewels = "z"`, `stones = "ZZ"` → `0`) exists precisely to
catch that.

</details>

## Solutions

Go was the source of truth here — this problem predates the polyglot
restructure and was solved before Swift became the default first language.

| Language | Harness | Run from the leaf | Status |
|----------|---------|-------------------|--------|
| Go | `go test` | `go test ./...` | ✅ solved |
| Swift | SwiftPM + Swift Testing | `swift test` | 🔴 stub — memory test, unsolved on purpose |

## Idiom notes

_What each language made me see:_

- **Go** — `map[rune]struct{}` is the idiomatic set. `struct{}` is a
  **zero-width** type, so the map stores keys and literally nothing else; a
  `map[rune]bool` would waste a byte per entry and invite the ambiguity of a
  `false` value meaning "absent" or "present but false." Membership reads as
  the two-value comma-ok form, `if _, ok := set[char]; ok`, where the value is
  deliberately discarded and only `ok` matters.
- **Go** — `for _, char := range someString` iterates **runes**, not bytes,
  decoding UTF-8 as it goes. That is why `char` is a `rune` and the set is
  keyed by `rune`. Indexing with `s[i]` instead would yield a `byte` and break
  on any multi-byte character — safe here given the English-letters
  constraint, but the wrong habit to build.
