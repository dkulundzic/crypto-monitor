import Foundation

protocol JSONMock {
    associatedtype Model: Codable
    func mock() throws -> Model
}

struct DefaultJSONMock<T>: JSONMock where T: Codable {
    let fileName: String

    func mock() throws -> T {
        guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        else {
            throw Error.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder.default.decode(T.self, from: data)
    }

    enum Error: Swift.Error {
        case fileNotFound
    }
}
