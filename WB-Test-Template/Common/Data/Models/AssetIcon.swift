import Foundation

struct AssetIcon: Codable, Hashable {
    let exchangeId: String?
    let assetId: String?
    let url: URL?

    func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(assetId)
    }
}



extension Collection where Element == AssetIcon {
    func icon(
        for assetId: String
    ) -> AssetIcon? {
        first(where: { $0.assetId == assetId })
    }
}
