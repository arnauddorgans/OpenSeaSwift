// 
// 

import Foundation

public extension StreamEvent {
  struct ItemCancelled: Codable, StreamEventPayload {
    public let collection: StreamCollection
    public let item: StreamItem
    // Waiting for matic quantity issue resolved (https://github.com/ProjectOpenSea/stream-js/issues/101)
    // public let quantity: Int
    public let listingType: String?
    public let transaction: StreamTransaction?
    public let paymentToken: StreamPaymentToken?
    public let eventTimestamp: Date
  }
}

// MARK: CodingKeys
extension StreamEvent.ItemCancelled {
  enum CodingKeys: String, CodingKey {
    case collection
    case item
    //case quantity
    case listingType = "listing_type"
    case transaction
    case paymentToken = "payment_token"
    case eventTimestamp = "event_timestamp"
  }
}
