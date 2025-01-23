import Foundation

enum ExchangeRateResource: Resource {
    case allRates(assetId: String, filterAssetId: [String])
    case get(assetId: String, quote: String)

    var endpoint: String {
        switch self {
        case let .allRates(assetId, _):
            "exchangerate/\(assetId)"
        case let .get(assetId, quote):
            "exchangerate/\(assetId)/\(quote)"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case let .allRates(_, filterIds):
            let filterIds = filterIds.joined(separator: ";")
            return [
                .init(name: "filter_asset_id", value: filterIds)
            ]
        case .get:
            return []
        }
    }
}
