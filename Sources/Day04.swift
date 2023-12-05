import Algorithms

struct Day04: AdventDay {

  var data: String

  struct Card {
    let number: Int
    let winning: [Int]
    let picked: [Int]

    var numOverlap: Int {
      Set(winning).intersection(picked).count
    }
  }

  var entities: [Card] {
    var toReturn = [Card]()
    let lines = data.split("\n")
    for line in lines {
      let cardNumGameSplit = line.split(":")
      let cardNum = Int(cardNumGameSplit.first!.split(" ").last!)!

      let gameSplit = cardNumGameSplit.last!.split("|")
      let winning = gameSplit.first!.split(" ").map({
        Int($0.trimmingCharacters(in: .whitespaces))!
      })
      let picked = gameSplit.last!.split(" ").map({
        Int($0.trimmingCharacters(in: .whitespaces))!
      })
      let card = Card(number: cardNum, winning: winning, picked: picked)
      toReturn.append(card)
    }
    return toReturn
  }

  func part1() -> Any {
    return entities.reduce(0) { runningTotal, card in
      let additive = card.numOverlap > 0 ? (2 << (card.numOverlap - 2)) : 0
      return runningTotal + additive
    }
  }

  func part2() -> Any {
    var numberOfCards = [Int: Int]()
    for card in entities {
      var cardNum = card.number
      let multiplier = (numberOfCards[card.number] ?? 0) + 1
      for _ in 0..<card.numOverlap {
        cardNum += 1
        numberOfCards[cardNum] = (numberOfCards[cardNum] ?? 0) + multiplier
      }
    }
    return numberOfCards.values.reduce(entities.count, +)
  }
}
