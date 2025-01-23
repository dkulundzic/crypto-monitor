import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(String)
    case serverError(String)
}
