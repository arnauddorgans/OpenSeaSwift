// 
// 

import Foundation

public extension StreamEvent {
  struct ItemMetadataUpdated: Codable, StreamEventPayload {
    public let collection: StreamCollection
    public let item: StreamItem
  }
}
