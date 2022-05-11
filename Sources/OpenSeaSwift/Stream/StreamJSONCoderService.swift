// 
// 

import Foundation

struct StreamJSONCoderService: JSONCoderService {
  let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(.streamFormatter)
    return encoder
  }()
  
  let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.streamFormatter)
    return decoder
  }()
}

private extension DateFormatter {
  static var streamFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSzzzzzz"
    return dateFormatter
  }
}
