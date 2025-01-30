import Foundation

public extension JSONDecoder {
    static let `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            guard
                let date = ISO8601DateFormatter.expandedISO8601.date(from: dateString)
            else {
                throw DecodingError.dataCorruptedError(
                    in: container, debugDescription: "Cannot decode date string \(dateString)"
                )
            }

            return date
        }
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
