extension String {
  func split(_ separator: String) -> [String] {
    return self.split(separator: separator).map(Self.init)
  }
}
