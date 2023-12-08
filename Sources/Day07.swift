import Algorithms

struct Day07: AdventDay {

  var data: String

  enum HandType: Int {
    case highCard = 0
    case
      pair,
      twoPair,
      threeOfAKind,
      fullHouse,
      fourOfAKind,
      fiveOfAKind
  }

  struct Hand: Comparable {
    let cards: String
    let bid: Int
    let type: HandType

    init(cards: String, bid: Int) {
      self.cards = cards
      self.bid = bid

      var counts = [Character: Int]()
      for c in self.cards {
        counts[c] = (counts[c] ?? 0) + 1
      }
      switch counts.count {
      case 5:
        self.type = .highCard
      case 4:
        self.type = .pair
      case 3:
        self.type = counts.values.max()! > 2 ? .threeOfAKind : .twoPair
      case 2:
        self.type = counts.values.min()! > 1 ? .fullHouse : .fourOfAKind
      case 1:
        self.type = .fiveOfAKind
      default:
        self.type = .highCard
      }
    }

    private static func getValue(card: Character) -> Int {
      switch card {
      case "T": return 10
      case "J": return 11
      case "Q": return 12
      case "K": return 13
      case "A": return 14
      default: return Int("\(card)")!
      }
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
      if lhs.type == rhs.type {
        for i in 0..<5 {
          let lIndex = lhs.cards.index(lhs.cards.startIndex, offsetBy: i)
          let rIndex = rhs.cards.index(rhs.cards.startIndex, offsetBy: i)

          let lCard = lhs.cards[lIndex]
          let rCard = rhs.cards[rIndex]

          let lValue = getValue(card: lCard)
          let rValue = getValue(card: rCard)

          if lValue != rValue {
            return lValue < rValue
          }
        }
      }
      return lhs.type.rawValue < rhs.type.rawValue
    }
  }

  var entities: [Hand] {
    return data.split("\n").map { line in
      let info = line.split(" ")
      return Hand(cards: info.first!, bid: Int(info.last!)!)
    }
  }

  func part1() -> Any {
    let rankedHands = entities.sorted()
    var total = 0
    for (rank, hand) in rankedHands.indexed() {
      total += ((rank + 1) * hand.bid)
    }
    return total
  }

  /*************
  *** Part 2 ***
  *************/
  struct Hand2: Comparable {
    let cards: String
    let bid: Int
    let type: HandType

    init(cards: String, bid: Int) {
      self.cards = cards
      self.bid = bid

      var counts = [Character: Int]()
      for c in self.cards {
        counts[c] = (counts[c] ?? 0) + 1
      }
      let hasJ = counts.keys.contains("J")
      switch counts.count {
      case 5:
        self.type = hasJ ? .pair : .highCard
      case 4:
        self.type = hasJ ? .threeOfAKind : .pair
      case 3:
        if hasJ {
          if counts.values.max()! == 2 {
            if counts["J"]! == 2 {
              self.type = .fourOfAKind
            } else {
              self.type = .fullHouse
            }
          } else {
            self.type = .fourOfAKind
          }
        } else {
          self.type = counts.values.max()! > 2 ? .threeOfAKind : .twoPair
        }
      case 2:
        if hasJ {
          self.type = .fiveOfAKind
        } else {
          self.type = counts.values.min()! > 1 ? .fullHouse : .fourOfAKind
        }
      case 1:
        self.type = .fiveOfAKind
      default:
        self.type = hasJ ? .pair : .highCard
      }
    }

    private static func getValue(card: Character) -> Int {
      switch card {
      case "T": return 10
      case "J": return 1
      case "Q": return 12
      case "K": return 13
      case "A": return 14
      default: return Int("\(card)")!
      }
    }

    static func < (lhs: Hand2, rhs: Hand2) -> Bool {
      if lhs.type == rhs.type {
        for i in 0..<5 {
          let lIndex = lhs.cards.index(lhs.cards.startIndex, offsetBy: i)
          let rIndex = rhs.cards.index(rhs.cards.startIndex, offsetBy: i)

          let lCard = lhs.cards[lIndex]
          let rCard = rhs.cards[rIndex]

          let lValue = getValue(card: lCard)
          let rValue = getValue(card: rCard)

          if lValue != rValue {
            return lValue < rValue
          }
        }
      }
      return lhs.type.rawValue < rhs.type.rawValue
    }
  }

  var entities2: [Hand2] {
    return data.split("\n").map { line in
      let info = line.split(" ")
      let h = Hand2(cards: info.first!, bid: Int(info.last!)!)
      return h
    }
  }

  func part2() -> Any {
    let rankedHands = entities2.sorted()
    var total = 0
    for (rank, hand) in rankedHands.indexed() {
      total += ((rank + 1) * hand.bid)
    }
    return total
  }
}
