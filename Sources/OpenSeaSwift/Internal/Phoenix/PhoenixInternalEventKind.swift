// 
// 

import Foundation

enum PhoenixInternalEventKind: String, Codable {
  case join = "phx_join"
  case heartbeat = "heartbeat"
  case reply = "phx_reply"
  case leave = "phx_leave"
}
