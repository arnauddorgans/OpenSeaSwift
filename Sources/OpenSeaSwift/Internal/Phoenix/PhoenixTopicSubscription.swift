// 
// 

import Foundation

struct PhoenixTopicSubscription {
  private let messageDecoder: (Data) throws -> Any
  private let handler: (Any) -> Void
  
  init(messageDecoder: @escaping (Data) throws -> Any, handler: @escaping (Any) -> Void) {
    self.messageDecoder = messageDecoder
    self.handler = handler
  }
  
  func decodeMessage(_ data: Data) throws -> Any {
    try messageDecoder(data)
  }
  
  func send(_ message: Any) {
    handler(message)
  }
}
