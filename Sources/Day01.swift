import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    return data.split("\n")
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    return entities.reduce(
      0,
      { (total: Int, code: String) in
        let ints = code.compactMap({ Int("\($0)") })
        let first = ints.first ?? 0
        let last = ints.last ?? 0
        let additive = Int("\(first)\(last)") ?? 0
        return total + additive
      })
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var entities = self.entities
    let numberStrings = [
      "one": 1,
      "two": 2,
      "three": 3,
      "four": 4,
      "five": 5,
      "six": 6,
      "seven": 7,
      "eight": 8,
      "nine": 9,
    ]
    for idx in entities.indices {
      var ent = entities[idx]
      var newEnt = ""
      while ent.count > 0 {
        if ent.first?.isNumber ?? false {
          newEnt += String(ent.first!)
        } else {
          for (numStr, val) in numberStrings {
            if ent.starts(with: numStr) {
              newEnt += "\(val)"
            }
          }
        }
        ent = String(ent.dropFirst())
      }
      entities[idx] = newEnt
    }
    return entities.reduce(
      0,
      { (total: Int, code: String) in
        let ints = code.compactMap({ Int("\($0)") })
        let first = ints.first ?? 0
        let last = ints.last ?? 0
        let additive = Int("\(first)\(last)") ?? 0
        return total + additive
      })
  }
}
