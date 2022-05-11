// 
// 

import Foundation

public final class OpenSea {
  private let streamService: StreamService
  
  init(streamService: StreamService) {
    self.streamService = streamService
  }
}

public extension OpenSea {
  var stream: StreamService { streamService }
  
  convenience init(apiKey: String, network: StreamNetwork = .mainnet) {
    let webSocketService = WebSocketServiceImpl()
    let streamJSONCoderService = StreamJSONCoderService()
    let phoenixSocketService = PhoenixSocketServiceImpl(webSocketService: webSocketService,
                                                        jsonCoderService: streamJSONCoderService)
    let environmentService = EnvironmentServiceImpl(apiKey: apiKey, network: network)
    let streamService = StreamServiceImpl(phoenixSocketService: phoenixSocketService,
                                          environmentService: environmentService)
    self.init(streamService: streamService)
  }
}
