import Foundation

public struct ExchangeRate: Codable, Identifiable, Hashable {
    public let time: Date
    public let rate: Double
    public let assetIdQuote: String?

    public var id: String? {
        assetIdQuote
    }

    public init(
        time: Date,
        rate: Double,
        assetIdQuote: String?
    ) {
        self.time = time
        self.rate = rate
        self.assetIdQuote = assetIdQuote
    }
}
