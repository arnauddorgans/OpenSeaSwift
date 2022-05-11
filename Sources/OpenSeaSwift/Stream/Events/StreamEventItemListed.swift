// 
// 

import Foundation

public extension StreamEvent {
  struct ItemListed: Codable, StreamEventPayload {
    public let collection: StreamCollection
    public let item: StreamItem
    // Waiting for matic quantity issue resolved (https://github.com/ProjectOpenSea/stream-js/issues/101)
    // public let quantity: Int
    public let listingType: String?
    public let listingDate: Date?
    public let expirationDate: Date?
    public let maker: StreamAccount
    public let taker: StreamAccount?
    public let basePrice: String
    public let paymentToken: StreamPaymentToken
    public let isPrivate: Bool
    public let eventTimestamp: Date
  }
}

// MARK: CodingKeys
extension StreamEvent.ItemListed {
  enum CodingKeys: String, CodingKey {
    case collection
    case item
    case eventTimestamp = "event_timestamp"
    case basePrice = "base_price"
    case expirationDate = "expiration_date"
    case isPrivate = "is_private"
    case listingDate = "listing_date"
    case listingType = "listing_type"
    case maker
    case paymentToken = "payment_token"
    //case quantity
    case taker
  }
}
