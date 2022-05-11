// 
// 

import Foundation

final class PhoenixReplySubscription {
  private var handler: ((PhoenixMessage<PhoenixInternalEvent>) -> Void)?
  private var reply: PhoenixMessage<PhoenixInternalEvent>?
  
  func sink(_ handler: @escaping (PhoenixMessage<PhoenixInternalEvent>) -> Void) {
    if let reply = reply {
      handler(reply)
    } else {
      self.handler = handler
    }
  }
  
  func resume(message: PhoenixMessage<PhoenixInternalEvent>) {
    guard reply == nil else { return }
    reply = message
    handler?(message)
  }
}
