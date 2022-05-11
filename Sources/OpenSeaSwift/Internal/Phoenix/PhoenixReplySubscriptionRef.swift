// 
// 

import Foundation

struct PhoenixReplySubscriptionRef: Hashable {
  // We do not support joining the same topic multiple times
  // let joinRef: String?
  let ref: String?
  let topic: String
}
