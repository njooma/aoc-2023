import Algorithms

struct Day10: AdventDay {
  let data: String
  let entities: [[String]]

  init(data: String) {
    self.data = data
    self.entities = data.split("\n").map { $0.map({ "\($0)" }) }
  }

  enum Direction {
    case up, down, left, right
  }

  private func getNext(curr: (Int, Int), dir: Direction) -> ((Int, Int), Direction) {
    var nextIndex: (Int, Int)
    switch dir {
    case .up:
      nextIndex = (curr.0 - 1, curr.1)
    case .down:
      nextIndex = (curr.0 + 1, curr.1)
    case .left:
      nextIndex = (curr.0, curr.1 - 1)
    case .right:
      nextIndex = (curr.0, curr.1 + 1)
    }
    let nextChar = entities[nextIndex.0][nextIndex.1]
    if nextChar == "|" || nextChar == "-" {
      return (nextIndex, dir)
    }
    if nextChar == "J" {
      if dir == .down {
        return (nextIndex, .left)
      }
      return (nextIndex, .up)
    }
    if nextChar == "L" {
      if dir == .down {
        return (nextIndex, .right)
      }
      return (nextIndex, .up)
    }
    if nextChar == "F" {
      if dir == .up {
        return (nextIndex, .right)
      }
      return (nextIndex, .down)
    }
    if nextChar == "7" {
      if dir == .up {
        return (nextIndex, .left)
      }
      return (nextIndex, .down)
    }
    if nextChar == "S" {
      return (nextIndex, .up)
    }
    fatalError()
  }

  func part1() -> Any {
    let startRow = entities.firstIndex { $0.contains("S") }!
    let startCol = entities[startRow].firstIndex(of: "S")!
    let start = (startRow, startCol)
    var startDir: Direction

    var toPrint = entities.map { $0.map { _ in "." } }
    toPrint[startRow][startCol] = "S"

    if entities[startRow - 1][startCol].contains(where: { $0 == "|" || $0 == "F" || $0 == "7" }) {
      startDir = .up
    } else if entities[startRow + 1][startCol].contains(where: {
      $0 == "|" || $0 == "L" || $0 == "J"
    }) {
      startDir = .down
    } else if entities[startRow][startCol - 1].contains(where: {
      $0 == "-" || $0 == "F" || $0 == "L"
    }) {
      startDir = .left
    } else {
      startDir = .right
    }

    var currIdx: (Int, Int)
    var currDir: Direction
    (currIdx, currDir) = getNext(curr: start, dir: startDir)

    var steps = 0
    while currIdx != start {
      let curr = entities[currIdx.0][currIdx.1]
      if curr == "|" {
        toPrint[currIdx.0][currIdx.1] = "║"
      }
      if curr == "-" {
        toPrint[currIdx.0][currIdx.1] = "═"
      }
      if curr == "J" {
        toPrint[currIdx.0][currIdx.1] = "╝"
      }
      if curr == "L" {
        toPrint[currIdx.0][currIdx.1] = "╚"
      }
      if curr == "7" {
        toPrint[currIdx.0][currIdx.1] = "╗"
      }
      if curr == "F" {
        toPrint[currIdx.0][currIdx.1] = "╔"
      }

      steps += 1
      (currIdx, currDir) = getNext(curr: currIdx, dir: currDir)
    }

    print(toPrint.reduce("", { "\($0)\n\($1.joined())" }))
    return Int((Double(steps) / 2).rounded(.awayFromZero))
  }

  private func isPointInsidePolygon(polygon: [(x: Int, y: Int)], test: (x: Int, y: Int)) -> Bool {
    var contains = false

    var j = polygon.count - 1
    for i in 0..<polygon.count {
      if ((polygon[i].y < test.y && polygon[j].y >= test.y)
        || (polygon[j].y < test.y && polygon[i].y >= test.y))
        && (polygon[i].x <= test.x || polygon[j].x <= test.x)
      {
        contains =
          contains
          != (polygon[i].x + (test.y - polygon[i].y) / (polygon[j].y - polygon[i].y)
            * (polygon[j].x - polygon[i].x) < test.x)
      }
      j = i
    }

    return contains
  }

  func part2() -> Any {
    var polygon = [(x: Int, y: Int)]()

    let startRow = entities.firstIndex { $0.contains("S") }!
    let startCol = entities[startRow].firstIndex(of: "S")!
    let start = (startRow, startCol)
    polygon.append(start)
    var startDir: Direction

    var toPrint = entities.map { $0.map { _ in "." } }
    toPrint[startRow][startCol] = "S"

    if startRow > 0
      && entities[startRow - 1][startCol].contains(where: { $0 == "|" || $0 == "F" || $0 == "7" })
    {
      startDir = .up
    } else if startRow < entities.count
      && entities[startRow + 1][startCol].contains(where: {
        $0 == "|" || $0 == "L" || $0 == "J"
      })
    {
      startDir = .down
    } else if startCol > 0
      && entities[startRow][startCol - 1].contains(where: {
        $0 == "-" || $0 == "F" || $0 == "L"
      })
    {
      startDir = .left
    } else {
      startDir = .right
    }

    var currIdx: (Int, Int)
    var currDir: Direction
    (currIdx, currDir) = getNext(curr: start, dir: startDir)
    polygon.append(currIdx)

    var steps = 0
    while currIdx != start {
      let curr = entities[currIdx.0][currIdx.1]
      if curr == "|" {
        toPrint[currIdx.0][currIdx.1] = "║"
      }
      if curr == "-" {
        toPrint[currIdx.0][currIdx.1] = "═"
      }
      if curr == "J" {
        toPrint[currIdx.0][currIdx.1] = "╝"
      }
      if curr == "L" {
        toPrint[currIdx.0][currIdx.1] = "╚"
      }
      if curr == "7" {
        toPrint[currIdx.0][currIdx.1] = "╗"
      }
      if curr == "F" {
        toPrint[currIdx.0][currIdx.1] = "╔"
      }

      steps += 1
      (currIdx, currDir) = getNext(curr: currIdx, dir: currDir)
      polygon.append(currIdx)
    }

    print(toPrint.reduce("", { "\($0)\n\($1.joined())" }))

    var total = 0
    for (i, line) in entities.indexed() {
      for j in 0..<line.count {
        if polygon.contains(where: { $0 == (i, j) }) {
          continue
        }
        total += isPointInsidePolygon(polygon: polygon, test: (i, j)) ? 1 : 0
      }
    }
    return total
  }
}
