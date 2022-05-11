// 
// 

import Foundation

public struct StreamTrait: Codable {
  public let traitType: String
  public let value: String?
  public let displayType: String?
  public let maxValue: Int?
  public let traitCount: Int
  public let order: Int?
}

// MARK: CodingKeys
extension StreamTrait {
  enum CodingKeys: String, CodingKey {
    case traitType = "trait_type"
    case value
    case displayType = "display_type"
    case maxValue = "max_value"
    case traitCount = "trait_count"
    case order
  }
}
