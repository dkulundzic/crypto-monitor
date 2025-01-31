import Foundation

public protocol JSONMock {
    associatedtype Model: Codable
    func mock() throws -> Model
}

public struct DefaultJSONMock<T>: JSONMock where T: Codable {
    public let fileName: String
    public let bundle: Bundle

    public init(
        fileName: String,
        bundle: Bundle = .main
    ) {
        self.fileName = fileName
        self.bundle = bundle
    }

    public func mock() throws -> T {
        guard
            let url = bundle.url(forResource: fileName, withExtension: "json")
        else {
            throw Error.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder.default.decode(T.self, from: data)
    }

    public enum Error: Swift.Error {
        case fileNotFound
    }
}
