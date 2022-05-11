// 
// 

import Foundation

public extension StreamService {
  func onEvents(collectionSlug: String, handler: @escaping (StreamEvent) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: Set(StreamEventKind.allCases), handler: handler)
  }
  
  func onItemListed(collectionSlug: String, handler: @escaping (StreamEvent.ItemListed) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemListed], handler: { event in
      switch event.payload {
      case let .itemListed(itemListed):
        handler(itemListed)
      default:
        break
      }
    })
  }
  
  func onItemSold(collectionSlug: String, handler: @escaping (StreamEvent.ItemSold) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemSold], handler: { event in
      switch event.payload {
      case let .itemSold(itemSold):
        handler(itemSold)
      default:
        break
      }
    })
  }
  
  func onItemTransferred(collectionSlug: String, handler: @escaping (StreamEvent.ItemTransferred) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemTransferred], handler: { event in
      switch event.payload {
      case let .itemTransferred(itemTransferred):
        handler(itemTransferred)
      default:
        break
      }
    })
  }
  
  func onItemMetadataUpdated(collectionSlug: String, handler: @escaping (StreamEvent.ItemMetadataUpdated) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemMetadataUpdated], handler: { event in
      switch event.payload {
      case let .itemMetadataUpdated(itemMetadataUpdated):
        handler(itemMetadataUpdated)
      default:
        break
      }
    })
  }
  
  func onItemCancelled(collectionSlug: String, handler: @escaping (StreamEvent.ItemCancelled) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemCancelled], handler: { event in
      switch event.payload {
      case let .itemCancelled(itemCancelled):
        handler(itemCancelled)
      default:
        break
      }
    })
  }
  
  func onItemReceivedOffer(collectionSlug: String, handler: @escaping (StreamEvent.ItemReceivedOffer) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemReceivedOffer], handler: { event in
      switch event.payload {
      case let .itemReceivedOffer(itemReceivedOffer):
        handler(itemReceivedOffer)
      default:
        break
      }
    })
  }
  
  func onItemReceivedBid(collectionSlug: String, handler: @escaping (StreamEvent.ItemReceivedBid) -> Void) async throws -> String {
    try await onEvents(collectionSlug: collectionSlug, eventKinds: [.itemReceivedBid], handler: { event in
      switch event.payload {
      case let .itemReceivedBid(itemReceivedBid):
        handler(itemReceivedBid)
      default:
        break
      }
    })
  }
}
