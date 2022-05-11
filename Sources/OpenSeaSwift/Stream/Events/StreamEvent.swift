// 
// 

import Foundation

public struct StreamEvent {
  /// Timestamp that represents the time at which the message was sent to the client.
  public let sentAt: Date
  /// Event-specific set of data.
  public let payload: Payload
  
  /// Signifies the specific event that the message is representing.
  public var kind: StreamEventKind { payload.kind }
}

// MARK: Decodable
extension StreamEvent: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let kind = try container.decode(StreamEventKind.self, forKey: .kind)
    let sendAt = try container.decode(Date.self, forKey: .sentAt)
    let payload: Payload
    switch kind {
    case .itemMetadataUpdated:
      let itemMetadataUpdated = try container.decode(ItemMetadataUpdated.self, forKey: .payload)
      payload = .itemMetadataUpdated(itemMetadataUpdated)
    case .itemListed:
      let itemListed = try container.decode(ItemListed.self, forKey: .payload)
      payload = .itemListed(itemListed)
    case .itemSold:
      let itemSold = try container.decode(ItemSold.self, forKey: .payload)
      payload = .itemSold(itemSold)
    case .itemTransferred:
      let itemTransferred = try container.decode(ItemTransferred.self, forKey: .payload)
      payload = .itemTransferred(itemTransferred)
    case .itemCancelled:
      let itemCancelled = try container.decode(ItemCancelled.self, forKey: .payload)
      payload = .itemCancelled(itemCancelled)
    case .itemReceivedOffer:
      let itemReceivedOffer = try container.decode(ItemReceivedOffer.self, forKey: .payload)
      payload = .itemReceivedOffer(itemReceivedOffer)
    case .itemReceivedBid:
      let itemReceivedBid = try container.decode(ItemReceivedBid.self, forKey: .payload)
      payload = .itemReceivedBid(itemReceivedBid)
    }
    self.init(sentAt: sendAt, payload: payload)
  }
}

// MARK: PhoenixEventCodable
extension StreamEvent: PhoenixEventCodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(kind, forKey: .kind)
    try container.encode(sentAt, forKey: .sentAt)
    switch payload {
    case let .itemMetadataUpdated(itemMetadataUpdated):
      try container.encode(itemMetadataUpdated, forKey: .payload)
    case let .itemListed(itemListed):
      try container.encode(itemListed, forKey: .payload)
    case let .itemSold(itemSold):
      try container.encode(itemSold, forKey: .payload)
    case let .itemTransferred(itemTransferred):
      try container.encode(itemTransferred, forKey: .payload)
    case let .itemCancelled(itemCancelled):
      try container.encode(itemCancelled, forKey: .payload)
    case let .itemReceivedOffer(itemReceivedOffer):
      try container.encode(itemReceivedOffer, forKey: .payload)
    case let .itemReceivedBid(itemReceivedBid):
      try container.encode(itemReceivedBid, forKey: .payload)
    }
  }
}

// MARK: CodingKeys
extension StreamEvent {
  enum CodingKeys: String, CodingKey {
    case kind = "event_type"
    case sentAt = "sent_at"
    case payload
  }
}
