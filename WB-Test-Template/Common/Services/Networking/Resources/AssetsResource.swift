import Foundation

enum AssetsResource: Resource {
    case assets
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
}
