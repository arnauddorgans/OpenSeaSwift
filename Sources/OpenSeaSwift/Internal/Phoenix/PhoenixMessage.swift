// 
// 

import Foundation

struct PhoenixMessage<Event> where Event: PhoenixEvent {
  var joinRef: String?
  var ref: String? = randomRef()
  var topic: String
  var event: Event
  
  var eventKind: Event.Kind { event.kind }
}

extension PhoenixMessage {
  static func randomRef() -> String {
    String(UInt64.random(in: 0..<UInt64.max))
  }
}

// MARK: PhoenixEventDecodable
extension PhoenixMessage: Decodable where Event: PhoenixEventDecodable {
  init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    guard container.count == 5 else {
      throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid message"))
    }
    var joinRef: String?
    var ref: String?
    var topic: String!
    var eventKind: Event.Kind!
    var event: Event!
    while !container.isAtEnd {
      let index = container.currentIndex
      switch index {
      case 0:   joinRef = try container.decode(String?.self)
      case 1:   ref = try container.decode(String?.self)
      case 2:   topic = try container.decode(String.self)
      case 3:   eventKind = try container.decode(Event.Kind.self)
      case 4:   event = try .init(from: container.superDecoder(), kind: eventKind)
      default:  break
      }
    }
    self.init(joinRef: joinRef,
              ref: ref,
              topic: topic,
              event: event)
  }
}

// MARK: Encodable
extension PhoenixMessage: Encodable where Event: PhoenixEventEncodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(joinRef)
    try container.encode(ref)
    try container.encode(topic)
    try container.encode(eventKind)
    try container.encode(event)
  }
}
