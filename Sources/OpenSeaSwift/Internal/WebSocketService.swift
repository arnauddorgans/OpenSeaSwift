// 
// 

import Foundation

protocol WebSocketService {
  func connect(url: URL, onReceive: @escaping (String) -> Void, onClose: @escaping () -> Void) async throws
  
  func send(string: String) async throws
  
  func close()
}

final class WebSocketServiceImpl: NSObject, WebSocketService {
  private var socket: URLSessionWebSocketTask?
  private var handleConnect: ((Result<Void, Error>) -> Void)?
  private var onClose: (() -> Void)?
  private var readTask: Task<Void, Never>?
  private lazy var queue = OperationQueue()
  private lazy var urlSession: URLSession = .init(configuration: .default,
                                                  delegate: self,
                                                  delegateQueue: queue)
  
  func connect(url: URL, onReceive: @escaping (String) -> Void, onClose: @escaping () -> Void) async throws {
    socket = urlSession.webSocketTask(with: url)
    try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in
      self?.handleConnect = continuation.resume(with:)
      self?.socket?.resume()
    }
    self.onClose = onClose
    readTask = Task { [weak self] in
      await self?.read(onReceive: onReceive)
    }
  }
  
  func send(string: String) async throws {
    try await socket?.send(.string(string))
  }
  
  func close() {
    handleConnect = nil
    onClose?()
    onClose = nil
    socket?.cancel()
    socket = nil
    readTask?.cancel()
    readTask = nil
  }
}

private extension WebSocketServiceImpl {
  func read(onReceive: @escaping (String) -> Void) async {
    guard let socket = socket else { return }
    do {
      switch try await socket.receive() {
      case let .string(string):
        onReceive(string)
      case .data:
        break
      @unknown default:
        fatalError()
      }
      await read(onReceive: onReceive)
    } catch {
      print(error)
      close()
    }
  }
}

// MARK: URLSessionDelegate
extension WebSocketServiceImpl: URLSessionWebSocketDelegate {
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
    handleConnect(result: .success(()))
  }
  
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    close()
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let error = error else { return }
    handleConnect(result: .failure(error))
  }
  
  private func handleConnect(result: Result<Void, Error>) {
    guard let handleConnect = handleConnect else { return }
    self.handleConnect = nil
    handleConnect(result)
    if case .failure = result {
      close()
    }
  }
}
