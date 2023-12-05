import Algorithms

class Day03: AdventDay {
  required init(data: String) {
    self.data = data
  }

  var data: String = ""

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    return data.split("\n")
  }

  struct Node: Hashable {
    let row: Int
    let startIndex: Int
    let endIndex: Int
    let span: Int
    let value: Int
    var isPart: Bool = false

    func contains(idx: Int) -> Bool {
      return startIndex <= idx && idx <= endIndex
    }
  }

  var nodes: [Node] = []

  func createNodes() {
    nodes.removeAll()
    for (idx, line) in entities.indexed() {
      var jdx = line.startIndex
      while jdx < line.endIndex {
        if line[jdx].isNumber {
          let startIdx = jdx.utf16Offset(in: line)
          var endIndex = startIdx
          var num = ""
          while line[jdx].isNumber {
            endIndex = jdx.utf16Offset(in: line)
            num += "\(line[jdx])"
            jdx = line.index(after: jdx)
            if jdx == line.endIndex {
              break
            }
          }
          nodes.append(
            Node(
              row: idx, startIndex: startIdx, endIndex: endIndex,
              span: num.count,
              value: Int(num)!))
        } else {
          jdx = line.index(after: jdx)
        }
      }
    }
  }

  func part1() -> Any {
    createNodes()

    for (idx, line) in entities.indexed() {
      for (jdx, char) in line.indexed() {
        if !char.isLetter && !char.isNumber && char != "." {

          // check left
          let leftIdx = line.index(before: jdx).utf16Offset(in: line)
          if let nodeIdx = nodes.firstIndex(where: { $0.endIndex == leftIdx && $0.row == idx }) {
            nodes[nodeIdx].isPart = true
          }

          // check right
          let rightIdx = line.index(after: jdx).utf16Offset(in: line)
          if let nodeIdx = nodes.firstIndex(where: { $0.startIndex == rightIdx && $0.row == idx }) {
            nodes[nodeIdx].isPart = true
          }

          // check above
          let upNodes = nodes.filter({ $0.row == idx - 1 }).filter({
            $0.contains(idx: jdx.utf16Offset(in: line)) || $0.contains(idx: leftIdx)
              || $0.contains(idx: rightIdx)
          })
          upNodes.forEach({ node in
            if let nodeIdx = nodes.firstIndex(of: node) {
              nodes[nodeIdx].isPart = true
            }
          })

          // check below
          let downNodes = nodes.filter({ $0.row == idx + 1 }).filter({
            $0.contains(idx: jdx.utf16Offset(in: line)) || $0.contains(idx: leftIdx)
              || $0.contains(idx: rightIdx)
          })
          downNodes.forEach({ node in
            if let nodeIdx = nodes.firstIndex(of: node) {
              nodes[nodeIdx].isPart = true
            }
          })
        }
      }
    }

    var total = 0
    for node in nodes.filter({ $0.isPart }) {
      total += node.value
    }

    return total
  }

  func part2() -> Any {
    createNodes()

    var total = 0
    for (idx, line) in entities.indexed() {
      for (jdx, char) in line.indexed() {
        if char == "*" {
          var maybes = [Node]()

          // check left
          let leftIdx = line.index(before: jdx).utf16Offset(in: line)
          if let node = nodes.first(where: { $0.endIndex == leftIdx && $0.row == idx }) {
            maybes.append(node)
          }

          // check right
          let rightIdx = line.index(after: jdx).utf16Offset(in: line)
          if let node = nodes.first(where: { $0.startIndex == rightIdx && $0.row == idx }) {
            maybes.append(node)
          }

          // check above
          let upNodes = nodes.filter({ $0.row == idx - 1 }).filter({
            $0.contains(idx: jdx.utf16Offset(in: line)) || $0.contains(idx: leftIdx)
              || $0.contains(idx: rightIdx)
          })
          maybes.append(contentsOf: upNodes)

          // check below
          let downNodes = nodes.filter({ $0.row == idx + 1 }).filter({
            $0.contains(idx: jdx.utf16Offset(in: line)) || $0.contains(idx: leftIdx)
              || $0.contains(idx: rightIdx)
          })
          maybes.append(contentsOf: downNodes)

          if maybes.count != 2 {
            continue
          }

          total += maybes[0].value * maybes[1].value
        }
      }
    }

    return total
  }
}
