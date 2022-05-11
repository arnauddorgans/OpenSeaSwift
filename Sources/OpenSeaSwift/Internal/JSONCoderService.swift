// 
// 

import Foundation

protocol JSONCoderService {
  var decoder: JSONDecoder { get }
  var encoder: JSONEncoder { get }
}
