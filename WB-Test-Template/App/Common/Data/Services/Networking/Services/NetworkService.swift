import Foundation
import Factory

#warning("TODO: Move to an appropriate place ")
let apiKey = "9A52912A-724F-493D-90A4-8E7066C15B2E"

protocol NetworkService { }

extension NetworkService {
    func resolve<T: Decodable>(
        resource: any Resource,
        retry: NetworkServiceRetryPolicy = .default
    ) async throws -> T where T: Sendable {
        let url = Host.baseURL
            .appendingPathComponent(resource.endpoint)
            .appending(queryItems: resource.queryItems)
        print("🌐: ", url)

        var request = URLRequest(url: url)
        let requestDecorator = Container.shared.requestDecorator.resolve()
        requestDecorator.decorate(request: &request)

        return try await Task
            .retrying(
                maxRetryCount: retry.maxRetryCount,
                retryDelay: retry.retryDelay
            ) { [request] in
            let (data, response) = try await URLSession.shared.data(for: request)

            guard
                let httpResponse = response as? HTTPURLResponse
            else {
                throw NetworkError.serverError("Yo! There was an error.")
            }

            guard
                (200...299).contains(httpResponse.statusCode)
            else {
                throw NetworkError.serverError("Yo! There was an error.")
            }

            do {
                return try JSONDecoder.default.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error.localizedDescription)
            }
        }.value
    }
}
