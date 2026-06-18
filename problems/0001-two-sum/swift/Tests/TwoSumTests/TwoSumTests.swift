import Testing
@testable import TwoSum

@Test func example1() {
    #expect(twoSum([2, 7, 11, 15], 9) == [0, 1])
}

@Test func example2() {
    #expect(twoSum([3, 2, 4], 6) == [1, 2])
}

@Test func duplicateValues() {
    #expect(twoSum([3, 3], 6) == [0, 1])
}
