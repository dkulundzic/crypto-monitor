import Foundation

public protocol Resource {
    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
}

public extension Resource {
    var queryItems: [URLQueryItem] {
        []
    }
}
