// 
// 

import Foundation

struct PhoenixInternalEvent: PhoenixEvent {
  let kind: PhoenixInternalEventKind
  let status: Status
}

// MARK: PhoenixEventCodable
extension PhoenixInternalEvent: PhoenixEventCodable {
  init(from decoder: Decoder, kind: PhoenixInternalEventKind) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let status = try container.decode(Status.self, forKey: .status)
    self.init(kind: kind, status: status)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(status, forKey: .status)
  }
}

// MARK: CodingKeys
extension PhoenixInternalEvent {
  enum CodingKeys: String, CodingKey {
    case status
  }
}
