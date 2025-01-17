import Foundation

enum ExchangeRateResource: Resource {
    case get(assetId: String, quote: String)

    var endpoint: String {
        switch self {
        case .get(let assetId, let quote):
            "exchangerate/\(assetId)/\(quote)"
        }
    }
}
