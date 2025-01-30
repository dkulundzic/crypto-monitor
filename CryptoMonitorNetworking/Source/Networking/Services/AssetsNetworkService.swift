import Foundation
import Factory
import CryptoMonitorCore
import CryptoMonitorModel

public protocol AssetsNetworkService: NetworkService {
    func fetchAssets(filterAssetIds: Set<String>) async throws -> [Asset]
    func fetchAssetIcons() async throws -> [AssetIcon]
}

public struct DefaultAssetNetworkService: AssetsNetworkService {
    public func fetchAssets(
        filterAssetIds: Set<String> = []
    ) async throws -> [Asset] {
        return try await resolve(
            resource: AssetsResource.assets(filterAssetIds: filterAssetIds)
        )
    }

    public func fetchAssetIcons() async throws -> [AssetIcon] {
        try await resolve(resource: AssetsResource.icons(128))
    }
}

public struct MockAssetsNetworkService: AssetsNetworkService {
    public init() { }

    public func fetchAssets(
        filterAssetIds: Set<String>
    ) async throws -> [Asset] {
        try DefaultJSONMock<[Asset]>(fileName: "Assets")
            .mock()
            .filter {
                filterAssetIds.contains($0.assetId.emptyIfNil)
            }
    }

    public func fetchAssetIcons() async throws -> [AssetIcon] {
        try DefaultJSONMock<[AssetIcon]>(fileName: "AssetsIcons")
            .mock()
    }
}

public extension Container {
    var assetsNetworkService: Factory<AssetsNetworkService> {
        self {
            DefaultAssetNetworkService()
        }.unique
    }
}
