import Foundation

public struct AssetIcon: Codable, Hashable {
    public let exchangeId: String?
    public let assetId: String?
    public let url: URL?

    public init(
        exchangeId: String?,
        assetId: String?,
        url: URL?
    ) {
        self.exchangeId = exchangeId
        self.assetId = assetId
        self.url = url
    }

    public func hash(
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
