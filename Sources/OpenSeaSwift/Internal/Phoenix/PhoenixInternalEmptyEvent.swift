// 
// 

import Foundation

struct PhoenixInternalEmptyEvent {
  let kind: PhoenixInternalEventKind
}

// MARK: Encodable
extension PhoenixInternalEmptyEvent: PhoenixEventEncodable {
  func encode(to encoder: Encoder) throws { /* Empty */ }
}
