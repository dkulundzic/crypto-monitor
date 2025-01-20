import Foundation

enum AssetsResource: Resource {
    case assets(filterAssetIds: Set<String> = [])
    case details(String)
    case icons(Int)

    var endpoint: String {
        switch self {
        case .assets:
            "/assets"
        case let .details(id):
            "/assets/\(id)"
        case let .icons(iconSize):
            "/assets/icons/\(iconSize)"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .assets(filterIds):
            let filterIds = filterIds.joined(separator: ";")
            return [
                .init(name: "filter_asset_id", value: filterIds)
            ]
        case .details, .icons:
            return nil
        }
    }
}
