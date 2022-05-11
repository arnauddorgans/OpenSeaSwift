// 
// 

import Foundation

public extension StreamEvent {
  struct ItemTransferred: Codable, StreamEventPayload {
    public let collection: StreamCollection
    public let item: StreamItem
    public let fromAccount: StreamAccount
    // Waiting for matic quantity issue resolved (https://github.com/ProjectOpenSea/stream-js/issues/101)
    // public let quantity: Int
    public let toAccount: StreamAccount
    public let transaction: StreamTransaction?
    public let eventTimestamp: Date
  }
}

// MARK: CodingKeys
extension StreamEvent.ItemTransferred {
  enum CodingKeys: String, CodingKey {
    case collection
    case item
    case fromAccount = "from_account"
    //case quantity
    case toAccount = "to_account"
    case transaction
    case eventTimestamp = "event_timestamp"
  }
}
