import Foundation

enum ExchangeRateResource: Resource {
    case allRates(assetId: String)
    case get(assetId: String, quote: String)

    var endpoint: String {
        switch self {
        case let .allRates(assetId):
            "exchangerate/\(assetId)"
        case let .get(assetId, quote):
            "exchangerate/\(assetId)/\(quote)"
        }
    }
}
