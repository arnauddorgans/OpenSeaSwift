// 
// 

import Foundation

public enum DataURL {
  case url(URL)
  case data(String)
}

// MARK: Decodable
extension DataURL: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue = try container.decode(String.self)
    if let url = URL(string: stringValue) {
      self = .url(url)
    } else {
      self = .data(stringValue)
    }
  }
}

// MARK: Encodable
extension DataURL: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case let .url(url):
      try container.encode(url)
    case let .data(stringValue):
      try container.encode(stringValue)
    }
  }
}
