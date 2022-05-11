// 
// 

import Foundation

struct PhoenixAnyEvent {
  let kind: String
}

// MARK: Encodable
extension PhoenixAnyEvent: PhoenixEventDecodable {
  init(from decoder: Decoder, kind: String) throws {
    self.init(kind: kind)
  }
}
