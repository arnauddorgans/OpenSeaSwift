// 
// 

import Foundation

public struct StreamMetadata: Codable {
  public let name: String?
  public let description: String?
  public let imageURL: URL?
  public let animationURL: URL?
  public let metadataURL: DataURL?
  public let backgroundColor: String?
  public let traits: [StreamTrait]?
}

// MARK: CodingKeys
extension StreamMetadata {
  enum CodingKeys: String, CodingKey {
    case name
    case description
    case imageURL = "image_url"
    case animationURL = "animation_url"
    case metadataURL = "metadata_url"
    case backgroundColor = "background_color"
    case traits
  }
}
