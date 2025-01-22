import Foundation

protocol Resource {
    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Resource {
    var queryItems: [URLQueryItem] {
        []
    }
}
