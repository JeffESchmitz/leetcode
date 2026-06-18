"""LeetCode 1. Two Sum."""


def two_sum(nums: list[int], target: int) -> list[int]:
    """Indices of the two numbers that add up to ``target``.

    Single pass with a ``value -> index`` dict. O(n) time, O(n) space.
    """
    seen: dict[int, int] = {}
    for i, n in enumerate(nums):
        j = seen.get(target - n)
        if j is not None:
            return [j, i]
        seen[n] = i
    return []
