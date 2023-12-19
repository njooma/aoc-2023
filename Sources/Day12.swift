import Algorithms
import RegexBuilder

struct Day12: AdventDay {
  init(data: String) {
    self.data = data

    let split = data.split("\n")
    self.lines = split.map { ".\($0.split(" ").first!)." }
    self.groupings = split.map { $0.split(" ").last!.split(",").compactMap(Int.init(argument:)) }
  }

  let data: String
  let lines: [String]
  let groupings: [[Int]]

  private func getVariations(line: String, groups: any Collection<Int>) -> Int {
    print("\tRecursive test for \(line) \(groups.map { "\($0)" }.joined(separator: ","))")
    guard let group = groups.first else { return 1 }

    var variations = 0
    var testLine = line

    while testLine.contains("?") {
      let regex = Regex {
        Repeat(count: 1) {
          One(.anyOf(".?"))
        }
        Repeat(count: group) {
          One(.anyOf("?#"))
        }
        Repeat(count: 1) {
          One(.anyOf(".?"))
        }
      }
      if testLine.contains(regex) {
        let nextLine = testLine.replacing(regex, with: ".", maxReplacements: 1)
        testLine.replace(
          regex, with: ".\(Array(repeating: "$", count: group).joined()).", maxReplacements: 1)
        let furtherVars = getVariations(
          line: nextLine,
          groups: groups.dropFirst() as any Collection<Int>)
        if furtherVars == 0 {
          variations = 0
          continue
        } else {
          variations += furtherVars
        }
      } else {
        variations = 0
        break
      }
    }

    return variations
  }

  func part1() -> Any {
    var total = 0

    for i in 0..<lines.count {
      let line = lines[i]
      let groups = groupings[i]

      var variations = 0
      var testLine = line

      print("Testing \(line)")
      while testLine.contains("?") {
        // print("\tTest Line: \(testLine)")
        // var isValid = true
        // var lCopy = testLine
        // for group in groups {
        //   print("\t\tTesting group of \(group)")
        //   let regex = Regex {
        //     Repeat(count: 1) {
        //       One(.anyOf(".?"))
        //     }
        //     Repeat(count: group) {
        //       One(.anyOf("?#"))
        //     }
        //     Repeat(count: 1) {
        //       One(.anyOf(".?"))
        //     }
        //   }
        //   if lCopy.contains(regex) {
        //     print("\t\tDoes contain regex")
        //     lCopy.replace(
        //       regex, with: ".\(Array(repeating: "$", count: group).joined()).", maxReplacements: 1)
        //     print("\t\tReplaced lCopy: \(lCopy)")
        //   } else {
        //     print("\t\tisValid is FALSE")
        //     isValid = false
        //     break
        //   }
        // }
        // if isValid && !variations.contains(lCopy) {
        //   print("\tHave a new variation!")
        //   variations.append(lCopy)
        // }

        variations += getVariations(line: testLine, groups: groups)
        testLine.replace("?", with: ".", maxReplacements: 1)
      }
      print("\tVariations for \(line) \(groups): \(variations)")
      total += variations
    }
    return total
  }

  func part2() -> Any {
    return 0
  }
}
