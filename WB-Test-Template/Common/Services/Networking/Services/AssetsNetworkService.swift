import Foundation
import Factory

protocol AssetsNetworkService: NetworkService {
    func fetchAssets(filterAssetIds: Set<String>) async throws -> [Asset]
    func fetchAssetIcons() async throws -> [AssetIcon]
}

struct DefaultAssetNetworkService: AssetsNetworkService {
    func fetchAssets(
        filterAssetIds: Set<String> = []
    ) async throws -> [Asset] {
        return try await resolve(
            resource: AssetsResource.assets(filterAssetIds: filterAssetIds)
        )
    }

    func fetchAssetIcons() async throws -> [AssetIcon] {
        try await resolve(resource: AssetsResource.icons(64))
    }
}

struct MockAssetsNetworkService: AssetsNetworkService {
    func fetchAssets(
        filterAssetIds: Set<String>
    ) async throws -> [Asset] {
        try DefaultJSONMock<[Asset]>(fileName: "Assets")
            .mock()
            .filter {
                filterAssetIds.contains($0.assetId.emptyIfNil)
            }
    }

    func fetchAssetIcons() async throws -> [AssetIcon] {
        try DefaultJSONMock<[AssetIcon]>(fileName: "AssetsIcons")
            .mock()
    }
}

extension Container {
    var assetsNetworkService: Factory<AssetsNetworkService> {
        self {
            DefaultAssetNetworkService()
        }.unique
    }
}
