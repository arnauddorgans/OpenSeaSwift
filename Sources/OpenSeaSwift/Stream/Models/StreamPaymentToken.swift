// 
// 

import Foundation

public struct StreamPaymentToken: Codable {
  public let address: String
  public let decimals: Int
  public let ethPrice: String
  public let name: String
  public let symbol: String
  public let usdPrice: String
}

// MARK: CodingKeys
extension StreamPaymentToken {
  enum CodingKeys: String, CodingKey {
    case address
    case decimals
    case ethPrice = "eth_price"
    case name
    case symbol
    case usdPrice = "usd_price"
  }
}
