// 
// 

import Foundation

public extension StreamEvent {
  enum Payload {
    case itemMetadataUpdated(ItemMetadataUpdated)
    case itemListed(ItemListed)
    case itemSold(ItemSold)
    case itemTransferred(ItemTransferred)
    case itemCancelled(ItemCancelled)
    case itemReceivedOffer(ItemReceivedOffer)
    case itemReceivedBid(ItemReceivedBid)
    
    public var kind: StreamEventKind {
      switch self {
      case .itemMetadataUpdated: return .itemMetadataUpdated
      case .itemListed: return .itemListed
      case .itemSold: return .itemSold
      case .itemTransferred: return .itemTransferred
      case .itemCancelled: return .itemCancelled
      case .itemReceivedOffer: return .itemReceivedOffer
      case .itemReceivedBid: return .itemReceivedBid
      }
    }
  }
}

extension StreamEvent.Payload: StreamEventPayload {
  public var item: StreamItem { subPayload.item }
  public var collection: StreamCollection { subPayload.collection }
  
  private var subPayload: StreamEventPayload {
    switch self {
    case let .itemMetadataUpdated(itemMetadataUpdated):
      return itemMetadataUpdated
    case let .itemListed(itemListed):
      return itemListed
    case let .itemSold(itemSold):
      return itemSold
    case let .itemTransferred(itemTransferred):
      return itemTransferred
    case let .itemCancelled(itemCancelled):
      return itemCancelled
    case let .itemReceivedOffer(itemReceivedOffer):
      return itemReceivedOffer
    case let .itemReceivedBid(itemReceivedBid):
      return itemReceivedBid
    }
  }
}

public protocol StreamEventPayload {
  var item: StreamItem { get }
  var collection: StreamCollection { get }
}
