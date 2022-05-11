// 
// 

import Foundation

public extension StreamEvent {
  struct ItemSold: Codable, StreamEventPayload {
    public let collection: StreamCollection
    public let item: StreamItem
    // Waiting for matic quantity issue resolved (https://github.com/ProjectOpenSea/stream-js/issues/101)
    // public let quantity: Int
    public let listingType: String?
    public let closingDate: Date
    public let transaction: StreamTransaction
    public let maker: StreamAccount
    public let taker: StreamAccount
    public let salePrice: String
    public let paymentToken: StreamPaymentToken
    public let isPrivate: Bool
    public let eventTimestamp: Date
  }
}

// MARK: CodingKeys
extension StreamEvent.ItemSold {
  enum CodingKeys: String, CodingKey {
    case collection
    case item
    case eventTimestamp = "event_timestamp"
    case closingDate = "closing_date"
    case isPrivate = "is_private"
    case listingType = "listing_type"
    case maker
    case paymentToken = "payment_token"
    //case quantity
    case salePrice = "sale_price"
    case taker
    case transaction
  }
}
