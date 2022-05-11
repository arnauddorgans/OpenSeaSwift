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

protocol StreamEventPayload {
  var item: StreamItem { get }
  var collection: StreamCollection { get }
}
