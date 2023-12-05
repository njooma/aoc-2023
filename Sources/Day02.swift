import Algorithms

struct Day02: AdventDay {

  var data: String

  var entities: [Int: [String: [Int]]] {
    var toReturn: [Int: [String: [Int]]] = [:]
    let games = data.split("\n")
    for game in games {
      // game = Game 1: 1 blue, 2 green, 3 red; 7 red, 8 green; 1 green, 2 red, 1 blue; 2 green, 3 red, 1 blue; 8 green, 1 blue
      let g = game.split(":")
      let gameNum = Int(g.first!.split(" ").last!)!

      var counts = ["red": [Int](), "green": [Int](), "blue": [Int]()]
      let drawings = g.last!.split(";").map {
        $0.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      // drawings = ["1 blue, 2 green, 3 red", "7 red, 8 green", "1 green, 2 red, 1 blue", ...]
      for drawing in drawings {
        let colorCounts = drawing.split(",").map({
          $0.trimmingCharacters(in: .whitespacesAndNewlines)
        })
        for colorCount in colorCounts {
          // colorCount = "1 blue"
          let arr = colorCount.split(" ")
          counts[arr[1]]!.append(Int(arr[0])!)
        }
      }
      toReturn[gameNum] = counts
    }
    return toReturn
  }

  func part1() -> Any {
    var total = 0
    for (game, result) in entities {
      if result["red"]!.max()! > 12 {
        continue
      }
      if result["green"]!.max()! > 13 {
        continue
      }
      if result["blue"]!.max()! > 14 {
        continue
      }
      total += game
    }
    return total
  }

  func part2() -> Any {
    var total = 0
    for result in entities.values {
      let power = result["red"]!.max()! * result["green"]!.max()! * result["blue"]!.max()!
      total += power
    }
    return total
  }
}
