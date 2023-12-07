import Algorithms

struct Day06: AdventDay {

  var data: String

  struct Race {
    let duration: Int
    let distance: Int
  }

  var entities: [Race] {
    let raceInfo = data.split("\n")
    let durations = raceInfo[0].split(":").last!.split(" ").compactMap(Int.init)
    let distances = raceInfo[1].split(":").last!.split(" ").compactMap(Int.init)

    var races = [Race]()
    for i in 0..<durations.count {
      let t = durations[i]
      let d = distances[i]
      races.append(Race(duration: t, distance: d))
    }
    return races
  }

  func part1() -> Any {
    var result = 1
    for race in entities {
      let half = race.duration / 2

      var waysToWin = 0
      for i in stride(from: half, through: 0, by: -1) {
        if (race.duration - i) * i <= race.distance {
          break
        }
        waysToWin += 2
      }
      if race.duration.isMultiple(of: 2) {
        waysToWin -= 1
      }
      result *= waysToWin == 0 ? 1 : waysToWin
    }
    return result
  }

  func part2() -> Any {
    var duration = "0"
    var distance = "0"

    for race in entities {
      duration += "\(race.duration)"
      distance += "\(race.distance)"
    }

    let race = Race(duration: Int(duration)!, distance: Int(distance)!)

    let half = race.duration / 2

    var waysToWin = 0
    for i in stride(from: half, through: 0, by: -1) {
      if (race.duration - i) * i <= race.distance {
        break
      }
      waysToWin += 2
    }
    if race.duration.isMultiple(of: 2) {
      waysToWin -= 1
    }
    return waysToWin
  }
}
