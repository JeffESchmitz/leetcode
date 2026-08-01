public struct Solution {
    public init() {}

    public func romanToInt(_ s: String) -> Int {
        // Step 1: the seven symbol values.
        let valueMap: [Character: Int] = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000
        ]

        // Step 2: translate the whole string into values up front.
        // "MCMXCIV" -> [1000, 100, 1000, 10, 100, 1, 5]
        // A character outside the seven symbols is invalid input, so trap
        // loudly instead of hiding it behind a default value.
        let values = s.map { char in
            guard let value = valueMap[char] else {
                fatalError("invalid roman numeral character: \(char)")
            }
            return value
        }

        // Step 3: signed sum. zip pairs each value with its right neighbor;
        // a value smaller than its neighbor is the front of a subtractive
        // pair (IV, XC, ...) and is subtracted. The last value has no pair
        // and is always added, so it seeds the reduction.
        return zip(values, values.dropFirst()).reduce(values.last ?? 0) { total, pair in
            let (current, next) = pair
            return total + (current < next ? -current : current)
        }
    }
}
