// 
// 

import Foundation

extension PhoenixMessage where Event == PhoenixInternalEmptyEvent {
  init(joinRef: String? = nil,
       ref: String? = randomRef(),
       topic: String,
       eventKind: PhoenixInternalEventKind) {
    self.init(joinRef: joinRef,
              ref: ref,
              topic: topic,
              event: .init(kind: eventKind))
  }
}
