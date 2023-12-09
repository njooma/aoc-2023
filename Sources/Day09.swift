import Algorithms

struct Day09: AdventDay {

  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").compactMap { Int($0) }
    }
  }

  func part1() -> Any {
    var totals = [Int]()
    for pattern in entities {
      var lastValues = [pattern.last!]
      var currArr = pattern
      while true {
        var isAllZeroes = true
        let nextArr = currArr.adjacentPairs().map { (left, right) in
          let val = right - left
          if val != 0 {
            isAllZeroes = false
          }
          return val
        }
        lastValues.append(nextArr.last!)
        if isAllZeroes {
          break
        }
        currArr = nextArr
      }
      let next = lastValues.reduce(0, +)
      totals.append(next)
    }
    return totals.reduce(0, +)
  }

  func part2() -> Any {
    var totals = [Int]()
    for pattern in entities {
      var firstValues = [pattern.first!]
      var currArr = pattern
      while true {
        var isAllZeroes = true
        let nextArr = currArr.adjacentPairs().map { (left, right) in
          let val = right - left
          if val != 0 {
            isAllZeroes = false
          }
          return val
        }
        firstValues.append(nextArr.first!)
        if isAllZeroes {
          break
        }
        currArr = nextArr
      }
      let next = firstValues.reversed().reduce(0) { $1 - $0 }
      totals.append(next)
    }
    return totals.reduce(0, +)
  }
}
