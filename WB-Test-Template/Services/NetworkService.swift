import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkService {
    private let apiKey = "9A52912A-724F-493D-90A4-8E7066C15B2E"
    private let baseURL = "https://rest.coinapi.io/v1"

    func fetchAssets() async throws -> [Asset] {
        guard
            let url = URL(string: "\(baseURL)/assets")
        else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)

        do {
            return try JSONDecoder.default.decode([Asset].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
