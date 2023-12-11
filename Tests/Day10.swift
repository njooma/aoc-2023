import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day10Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

  func testPart1() throws {
    let challenge = Day10(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "8")
  }

  func testPart2() throws {
    let testData = """
      FF7FSF7F7F7F7F7F---7
      L|LJ||||||||||||F--J
      FL-7LJLJ||||||LJL-77
      F--JF--7||LJLJIF7FJ-
      L---JF-JLJIIIIFJLJJ7
      |F|F-JF---7IIIL7L|7|
      |FFJF7L7F-JF7IIL---7
      7-L-JL7||F7|L7F-7F7|
      L.L7LFJ|||||FJL7||LJ
      L7JLJL-JLJLJL--JLJ.L
      """
    let challenge = Day10(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "10")
  }
}
