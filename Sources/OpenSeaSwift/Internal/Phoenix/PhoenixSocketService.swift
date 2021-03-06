// 
// 

import Foundation

protocol PhoenixSocketService {
  func connect(url urlString: String, parameters: [String: String], onClose: @escaping () -> Void) async throws
  
  func hasJoined(topic: String) async -> Bool
  
  func join<Event>(topic: String, onReceive: @escaping (PhoenixMessage<Event>) -> Void) async throws where Event: PhoenixEventDecodable
  
  func leave(topic: String) async throws
  
  func disconnect() async throws
}

final actor PhoenixSocketServiceImpl: PhoenixSocketService {
  private let jsonCoderService: JSONCoderService
  private let webSocketService: WebSocketService
  private var heartbeatTask: Task<Void, Error>?
  private var topicSubscriptions: [String: PhoenixTopicSubscription] = [:]
  private var replySubscriptions: [PhoenixReplySubscriptionRef: PhoenixReplySubscription] = [:]
  
  /// Phoenix serializer version
  private let serializerVersion: String = "2.0.0"
  private let stringEncoding: String.Encoding = .utf8
  private let heartbeatInterval: TimeInterval = 30
  
  init(webSocketService: WebSocketService, jsonCoderService: JSONCoderService) {
    self.webSocketService = webSocketService
    self.jsonCoderService = jsonCoderService
  }
  
  func connect(url urlString: String, parameters: [String: String], onClose: @escaping () -> Void) async throws {
    clear()
    guard var urlComponents = URLComponents(string: urlString + "/websocket") else {
      throw PhoenixSocketError.invalidURL
    }
    urlComponents.queryItems = [
      .init(name: "vsn", value: serializerVersion)
    ] + parameters.map {
      .init(name: $0.key, value: $0.value)
    }
    guard let url = urlComponents.url else {
      throw PhoenixSocketError.invalidURL
    }
    try await webSocketService.connect(
      url: url,
      onReceive: { rawMessage in
        Task { [weak self] in await self?.handle(rawMessage: rawMessage) }
      },
      onClose: {
        Task { [weak self] in await self?.clear() }
        onClose()
      }
    )
    heartbeatTask = Task {
      try await heartbeat()
    }
  }
  
  func join<Event>(topic: String, onReceive: @escaping (PhoenixMessage<Event>) -> Void) async throws where Event: PhoenixEventDecodable {
    guard topicSubscription(forTopic: topic) == nil else { return /* Already joined */ }
    createTopicSubscription(forTopic: topic, handler: onReceive)
    do {
      try await send(message: .init(topic: topic, eventKind: .join))
    } catch {
      clearTopicSubscription(topic: topic)
      throw error
    }
  }
  
  func leave(topic: String) async throws {
    try await send(message: .init(topic: topic, eventKind: .leave))
    clearTopicSubscription(topic: topic)
  }
  
  func hasJoined(topic: String) async -> Bool {
    topicSubscription(forTopic: topic) != nil
  }
  
  func disconnect() async throws {
    webSocketService.close()
  }
}

private extension PhoenixSocketServiceImpl {
  func clear() {
    heartbeatTask?.cancel()
    heartbeatTask = nil
    topicSubscriptions.removeAll()
    replySubscriptions.removeAll()
  }
  
  func handle(rawMessage: String) {
    do {
      guard let data = rawMessage.data(using: stringEncoding) else {
        throw PhoenixSocketError.invalidMessage
      }
      do {
        try handlePhoenixMessage(messageData: data)
      } catch {
        try handleMessage(messageData: data)
      }
    } catch {
      print("Invalid message: \(rawMessage) (\(error))")
    }
  }
  
  private func handlePhoenixMessage(messageData data: Data) throws {
    let phoenixMessage = try jsonCoderService.decoder.decode(PhoenixMessage<PhoenixInternalEvent>.self, from: data)
    switch phoenixMessage.eventKind {
    case .reply:
      let ref = replySubscriptionRef(forMessage: phoenixMessage)
      guard let subscription = replySubscription(forRef: ref) else { return /* No subscription */ }
      subscription.resume(message: phoenixMessage)
    case .close:
      clearTopicSubscription(topic: phoenixMessage.topic)
    default:
      break
    }
  }
  
  private func handleMessage(messageData data: Data) throws {
    let emptyMessage = try jsonCoderService.decoder.decode(PhoenixMessage<PhoenixAnyEvent>.self, from: data)
    guard let topicSubscription = topicSubscription(forTopic: emptyMessage.topic) else { return }
    let message = try topicSubscription.decodeMessage(data)
    topicSubscription.send(message)
  }
  
  func send<Event>(message: PhoenixMessage<Event>) async throws where Event: PhoenixEventEncodable {
    let data = try jsonCoderService.encoder.encode(message)
    guard let string = String(data: data, encoding: stringEncoding) else {
      throw PhoenixSocketError.invalidMessage
    }
    // Create reply subscription
    let ref = replySubscriptionRef(forMessage: message)
    let subscription = createReplySubscription(forRef: ref)
    do {
      // Send message
      try await webSocketService.send(string: string)
      // Waiting reply
      try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
        subscription.sink { message in
          switch message.event.status {
          case .ok, .none:  continuation.resume()
          case .error:      continuation.resume(throwing: PhoenixSocketError.replyError)
          }
        }
      }
    } catch {
      // Clear subscription on error
      clearTopicSubscription(topic: ref.topic)
      throw error
    }
  }
}

// MARK: Subscription
private extension PhoenixSocketServiceImpl {
  func replySubscriptionRef<Event>(forMessage message: PhoenixMessage<Event>) -> PhoenixReplySubscriptionRef {
    .init(ref: message.ref, topic: message.topic)
  }
  
  func replySubscription(forRef ref: PhoenixReplySubscriptionRef) -> PhoenixReplySubscription? {
    replySubscriptions[ref]
  }
  
  @discardableResult
  func createReplySubscription(forRef ref: PhoenixReplySubscriptionRef) -> PhoenixReplySubscription {
    let subscription = PhoenixReplySubscription()
    replySubscriptions[ref] = subscription
    return subscription
  }
  
  @discardableResult
  func createTopicSubscription<Event>(forTopic topic: String, handler: @escaping (PhoenixMessage<Event>) -> Void) -> PhoenixTopicSubscription where Event: PhoenixEventDecodable {
    let subscription = PhoenixTopicSubscription(messageDecoder: { try self.jsonCoderService.decoder.decode(PhoenixMessage<Event>.self, from: $0) },
                                                handler: { handler($0 as! PhoenixMessage<Event>) })
    topicSubscriptions[topic] = subscription
    return subscription
  }
  
  func topicSubscription(forTopic topic: String) -> PhoenixTopicSubscription? {
    topicSubscriptions[topic]
  }
  
  func clearTopicSubscription(topic: String) {
    topicSubscriptions[topic] = nil
  }
}

// MARK: Heartbeat
private extension PhoenixSocketServiceImpl {
  func heartbeat() async throws {
    try await Task.sleep(nanoseconds: UInt64(heartbeatInterval * 1_000_000_000))
    try await send(message: .init(topic: "phoenix", eventKind: PhoenixInternalEventKind.heartbeat))
    try await heartbeat()
  }
}

// MARK: Error
private enum PhoenixSocketError: Error {
  case invalidURL
  case invalidMessage
  case replyError
}
