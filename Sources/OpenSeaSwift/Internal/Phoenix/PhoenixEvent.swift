// 
// 

import Foundation

protocol PhoenixEvent {
  associatedtype Kind
  
  var kind: Kind { get }
}

// MARK: Decodable
protocol PhoenixEventDecodable: PhoenixEvent where Kind: Decodable {
  init(from decoder: Decoder, kind: Kind) throws
}

extension PhoenixEventDecodable where Self: Decodable {
  init(from decoder: Decoder, kind: Kind) throws {
    try self.init(from: decoder)
  }
}

// MARK: Encodable
protocol PhoenixEventEncodable: Encodable, PhoenixEvent where Kind: Encodable { }

// MARK: Codable
typealias PhoenixEventCodable = PhoenixEventDecodable & PhoenixEventEncodable
