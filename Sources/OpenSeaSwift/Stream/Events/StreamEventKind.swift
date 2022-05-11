// 
// 

import Foundation

public enum StreamEventKind: String, Codable, CaseIterable {
  case itemListed = "item_listed"
  case itemSold = "item_sold"
  case itemTransferred = "item_transferred"
  case itemMetadataUpdated = "item_metadata_updated"
  case itemCancelled = "item_cancelled"
  case itemReceivedOffer = "item_received_offer"
  case itemReceivedBid = "item_received_bid"
}
