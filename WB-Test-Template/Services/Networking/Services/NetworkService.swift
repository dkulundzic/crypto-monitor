import Foundation
import Factory

let apiKey = "9A52912A-724F-493D-90A4-8E7066C15B2E"

protocol NetworkService { }

extension NetworkService {
    func resolve<T: Codable>(
        resource: any Resource
    ) async throws -> T {
        let url = Host.baseURL.appendingPathComponent(resource.endpoint)

        var request = URLRequest(url: url)
        let requestDecorator = Container.shared.requestDecorator.resolve()
        requestDecorator.decorate(request: &request)

        let (data, _) = try await URLSession.shared.data(for: request)

        do {
            return try JSONDecoder.default.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
