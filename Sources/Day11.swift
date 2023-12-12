import Algorithms

struct Day11: AdventDay {
  init(data: String) {
    self.data = data
    let entities = data.split("\n").map { $0.map { "\($0)" } }
    self.entities = entities

    var rowsToDouble = [Int]()
    for (idx, row) in entities.indexed() {
      if row.allSatisfy({ $0 == "." }) {
        rowsToDouble.append(idx)
      }
    }
    self.emptyRows = rowsToDouble

    var colsToDouble = [Int]()
    for jdx in 0..<entities[0].count {
      var allDots = true
      for row in entities {
        if row[jdx] != "." {
          allDots = false
          break
        }
      }
      if allDots {
        colsToDouble.append(jdx)
      }
    }
    self.emptyCols = colsToDouble
  }

  let data: String
  let entities: [[String]]
  let emptyRows: [Int]
  let emptyCols: [Int]

  private func getPairs() -> CombinationsSequence<[(Int, Int)]> {
    var galaxyLocations = [(Int, Int)]()
    for (idx, row) in entities.indexed() {
      for (jdx, char) in row.indexed() {
        if char == "#" {
          galaxyLocations.append((idx, jdx))
        }
      }
    }

    return galaxyLocations.combinations(ofCount: 2)

  }

  func part1() -> Any {
    let pairs = getPairs()
    var total = 0
    for pair in pairs {
      let g1 = pair[0]
      let g2 = pair[1]

      let setRows = Set(Array(g1.0..<g2.0))
      var setCols: Set<Int>
      if g1.1 < g2.1 {
        setCols = Set(Array(g1.1..<g2.1))
      } else {
        setCols = Set(Array(g2.1..<g1.1))
      }

      let multiplier = setRows.intersection(emptyRows).count + setCols.intersection(emptyCols).count

      total += (abs(g1.0 - g2.0) + abs(g1.1 - g2.1) + multiplier)
    }
    return total
  }

  func part2() -> Any {
    let pairs = getPairs()
    var total = 0
    for pair in pairs {
      let g1 = pair[0]
      let g2 = pair[1]

      let setRows = Set(Array(g1.0..<g2.0))
      var setCols: Set<Int>
      if g1.1 < g2.1 {
        setCols = Set(Array(g1.1..<g2.1))
      } else {
        setCols = Set(Array(g2.1..<g1.1))
      }

      let multiplier = setRows.intersection(emptyRows).count + setCols.intersection(emptyCols).count

      total += (abs(g1.0 - g2.0) + abs(g1.1 - g2.1) + (multiplier * 999_999))
    }
    return total
  }
}
