import Foundation

enum AssetsResource: Resource {
    case assets
    case details(String)
    case icons(Int)

    var endpoint: String {
        switch self {
        case .assets:
            "/assets"
        case .details(let id):
            "/assets/\(id)"
        case .icons(let iconSize):
            "/assets/icons/\(iconSize)"
        }
    }
}
