// 
// 

import Foundation

protocol EnvironmentService {
  var apiKey: String { get }
  var network: StreamNetwork { get }
}

struct EnvironmentServiceImpl: EnvironmentService {
  let apiKey: String
  let network: StreamNetwork
}
