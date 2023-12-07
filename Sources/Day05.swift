import Algorithms

struct Day05: AdventDay {

  init(data: String) {
    self.data = data

    let blocks = data.split("\n\n")

    let _seeds = blocks[0]
    self.seeds = _seeds.split(":").last!.split(" ").map({
      Int($0.trimmingCharacters(in: .whitespaces))!
    })

    let _seedToSoil = blocks[1]
    self.seedToSoil = _seedToSoil.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }

    let _soilToFertilizer = blocks[2]
    self.soilToFertilizer = _soilToFertilizer.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }

    let _fertilizerToWater = blocks[3]
    self.fertilizerToWater = _fertilizerToWater.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }

    let _waterToLight = blocks[4]
    self.waterToLight = _waterToLight.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }

    let _lightToTemperature = blocks[5]
    self.lightToTemperature = _lightToTemperature.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }

    let _temperatureToHumidity = blocks[6]
    self.temperatureToHumidity = _temperatureToHumidity.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }

    let _humidityToLocation = blocks[7]
    self.humidityToLocation = _humidityToLocation.split("\n").dropFirst().map { mapping in
      let map = mapping.split(" ")
      return Mapping(sourceStart: Int(map[1])!, destStart: Int(map[0])!, range: Int(map[2])!)
    }
  }

  var data: String

  struct Mapping {
    let sourceStart: Int
    let destStart: Int
    let range: Int

    func containsSource(index: Int) -> Bool {
      return sourceStart <= index && index < (sourceStart + range)
    }

    func containsDest(index: Int) -> Bool {
      return destStart <= index && index < (destStart + range)
    }

    func getSource(dest: Int) -> Int {
      return dest + sourceStart - destStart
    }

    func getDest(source: Int) -> Int {
      return source - sourceStart + destStart
    }
  }

  let seeds: [Int]
  let seedToSoil: [Mapping]
  let soilToFertilizer: [Mapping]
  let fertilizerToWater: [Mapping]
  let waterToLight: [Mapping]
  let lightToTemperature: [Mapping]
  let temperatureToHumidity: [Mapping]
  let humidityToLocation: [Mapping]

  private func getSource(mappings: [Mapping], dest: Int) -> Int {
    if let mapping = mappings.first(where: { $0.containsDest(index: dest) }) {
      return mapping.getSource(dest: dest)
    }
    return dest
  }

  private func getDest(mappings: [Mapping], source: Int) -> Int {
    if let mapping = mappings.first(where: { $0.containsSource(index: source) }) {
      return mapping.getDest(source: source)
    }
    return source
  }

  private func seedToLocation(seed: Int) -> Int {
    let soil = getDest(mappings: seedToSoil, source: seed)
    let fert = getDest(mappings: soilToFertilizer, source: soil)
    let water = getDest(mappings: fertilizerToWater, source: fert)
    let light = getDest(mappings: waterToLight, source: water)
    let temp = getDest(mappings: lightToTemperature, source: light)
    let humid = getDest(mappings: temperatureToHumidity, source: temp)
    let location = getDest(mappings: humidityToLocation, source: humid)
    return location
  }

  func part1() -> Any {
    var locations = [Int]()
    for seed in seeds {
      let location = seedToLocation(seed: seed)
      locations.append(location)
    }
    return locations.min()!
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let seedRanges = seeds.chunks(ofCount: 2)
    func seedExists(seed: Int) -> Bool {
      for seedRange in seedRanges {
        if (seedRange.first!..<(seedRange.first! + seedRange.last!)).contains(seed) {
          return true
        }
      }
      return false
    }

    for location in 0...10_000_000_000 {
      let humid = getSource(mappings: humidityToLocation, dest: location)
      let temp = getSource(mappings: temperatureToHumidity, dest: humid)
      let light = getSource(mappings: lightToTemperature, dest: temp)
      let water = getSource(mappings: waterToLight, dest: light)
      let fert = getSource(mappings: fertilizerToWater, dest: water)
      let soil = getSource(mappings: soilToFertilizer, dest: fert)
      let seed = getSource(mappings: seedToSoil, dest: soil)
      if seedExists(seed: seed) {
        return location
      }
    }
    return 0
  }
}
