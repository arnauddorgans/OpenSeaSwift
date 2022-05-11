// 
// 

import Foundation

public extension StreamEvent {
  struct ItemReceivedOffer: Codable, StreamEventPayload {
    public let collection: StreamCollection
    public let item: StreamItem
    // Waiting for matic quantity issue resolved (https://github.com/ProjectOpenSea/stream-js/issues/101)
    // public let quantity: Int
    public let createdDate: Date
    public let expirationDate: Date
    public let maker: StreamAccount
    public let taker: StreamAccount?
    public let basePrice: String
    public let paymentToken: StreamPaymentToken
    public let eventTimestamp: Date
  }
}

// MARK: CodingKeys
extension StreamEvent.ItemReceivedOffer {
  enum CodingKeys: String, CodingKey {
    case collection
    case item
    //case quantity
    case createdDate = "created_date"
    case expirationDate = "expiration_date"
    case maker
    case taker
    case basePrice = "base_price"
    case paymentToken = "payment_token"
    case eventTimestamp = "event_timestamp"
  }
}
