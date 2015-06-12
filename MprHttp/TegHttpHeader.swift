import Foundation

public struct TegHttpHeader {
  public init(field: String, value: String) {
    self.field = field
    self.value = value
  }
  
  public let field: String
  public let value: String
}

// MARK: Equatable

extension TegHttpHeader: Equatable {}

public func ==(lhs: TegHttpHeader, rhs: TegHttpHeader) -> Bool {
  return lhs.field == rhs.field && lhs.value == rhs.value
}
