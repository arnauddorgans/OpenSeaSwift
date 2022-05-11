// 
// 

import Foundation

public struct StreamItem: Codable {
  public let nftID: String
  public let permalink: URL
  public let chain: StreamChain
  public let metadata: StreamMetadata
}

// MARK: CodingKeys
extension StreamItem {
  enum CodingKeys: String, CodingKey {
    case nftID = "nft_id"
    case permalink
    case chain
    case metadata
  }
}
