// 
// 

import Foundation

public protocol StreamService {
  func connect(onClose: @escaping () -> Void) async throws
  
  @discardableResult
  func onEvents(collectionSlug: String, eventKinds: Set<StreamEventKind>, handler: @escaping (StreamEvent) -> Void) async throws -> String
  
  func leave(_ ref: String) async throws
}

final actor StreamServiceImpl: StreamService {
  typealias TopicEventSubscription = ((ref: String, eventKinds: Set<StreamEventKind>, handler: (StreamEvent) -> Void))
  
  private let phoenixSocketService: PhoenixSocketService
  private let environmentService: EnvironmentService
  /// The topic event subscriptions keyed by topic
  private var topicEventSubscriptions: [String: [TopicEventSubscription]] = [:]
  /// Reverse mapping between ref and topic
  private var refTopic: [String: String] = [:]
  
  init(phoenixSocketService: PhoenixSocketService, environmentService: EnvironmentService) {
    self.phoenixSocketService = phoenixSocketService
    self.environmentService = environmentService
  }
  
  func connect(onClose: @escaping () -> Void) async throws {
    try await phoenixSocketService.connect(url: environmentService.network.rawValue,
                                           parameters: ["token": environmentService.apiKey],
                                           onClose: onClose)
  }
  
  func onEvents(collectionSlug: String, eventKinds: Set<StreamEventKind>, handler: @escaping (StreamEvent) -> Void) async throws -> String {
    let topic = collectionTopic(slug: collectionSlug)
    let ref = addSubscription(topic: topic, eventKinds: eventKinds, handler: handler)
    if await !phoenixSocketService.hasJoined(topic) {
      try await phoenixSocketService.join(topic, onReceive: { message in
        Task { [weak self] in await self?.handle(message: message, forTopic: topic) }
      })
    }
    return ref
  }
  
  func leave(_ ref: String) async throws {
    guard let topic = refTopic[ref] else { return }
    guard let leftSubscription = leaveTopic(topic: topic, ref: ref) else { return }
    guard topicEventSubscriptions[topic]?.isEmpty == true else { return }
    do {
      try await phoenixSocketService.leave(topic)
    } catch {
      // Re-add subscription in case of error
      addSubscription(topic: topic,
                      ref: leftSubscription.ref,
                      eventKinds: leftSubscription.eventKinds,
                      handler: leftSubscription.handler)
      throw error
    }
  }
}

private extension StreamServiceImpl {
  func collectionTopic(slug: String) -> String {
    "collection:\(slug)"
  }
  
  @discardableResult
  func addSubscription(topic: String, ref: String = UUID().uuidString, eventKinds: Set<StreamEventKind>, handler: @escaping (StreamEvent) -> Void) -> String {
    if topicEventSubscriptions[topic] == nil {
      topicEventSubscriptions[topic] = []
    }
    refTopic[ref] = topic
    topicEventSubscriptions[topic]!.append((ref, eventKinds, handler))
    return ref
  }
  
  func handle(message: PhoenixMessage<StreamEvent>, forTopic topic: String) {
    for subscription in topicEventSubscriptions[topic] ?? [] where subscription.1.contains(message.eventKind) {
      subscription.2(message.event)
    }
  }
  
  func leaveTopic(topic: String, ref: String) -> TopicEventSubscription? {
    guard let subscriptions = topicEventSubscriptions[topic],
          let index = subscriptions.firstIndex(where: { $0.ref == ref })
    else { return nil }
    let subscription = topicEventSubscriptions[topic]!.remove(at: index)
    refTopic[ref] = nil
    return subscription
  }
}
