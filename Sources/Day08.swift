import Algorithms

struct Day08: AdventDay {
  init(data: String) {
    self.data = data
    self.turns = data.split("\n").first!.map(String.init)

    var ents = [String: (left: String, right: String)]()
    self.data.split("\n\n").last!.split("\n").forEach { line in
      let info = line.split(" = ")
      let name = info.first!
      let nodes = info.last!.matches(of: /[1-9A-Z]+/)
      let left = "\(nodes.first!.output)"
      let right = "\(nodes.last!.output)"
      ents[name] = (left, right)
    }
    self.entities = ents
  }

  let data: String
  let turns: [String]
  let entities: [String: (left: String, right: String)]

  func part1() -> Any {
    var step = 0
    var curr = entities["AAA"]!
    while true {
      let turn = turns[step % turns.count]
      let next: String
      if turn == "L" {
        next = curr.left
      } else {
        next = curr.right
      }
      step += 1
      if next == "ZZZ" {
        return step
      }
      curr = entities[next]!
    }
  }

  func part2() -> Any {
    var step = 0
    var curr = entities.keys.filter({ $0.last! == "A" })
    var stepsToZ = [Int]()
    while curr.count > 0 {
      let turn = turns[step % turns.count]
      var next = [String]()

      for node in curr {
        let c = entities[node]!
        let n: String
        if turn == "L" {
          n = c.left
        } else {
          n = c.right
        }
        if n.last! == "Z" {
          stepsToZ.append(step + 1)
        } else {
          next.append(n)
        }
      }
      step += 1
      curr = next
    }

    func gcd(_ n1: Int, _ n2: Int) -> Int {
      var x = 0

      var y: Int = max(n1, n2)

      var z: Int = min(n1, n2)

      while z != 0 {
        x = y
        y = z
        z = x % y
      }
      return y
    }

    func lcm(_ n1: Int, _ n2: Int) -> Int {
      return (n1 * n2 / gcd(n1, n2))
    }

    return stepsToZ.reduce(1, lcm)
  }
}
