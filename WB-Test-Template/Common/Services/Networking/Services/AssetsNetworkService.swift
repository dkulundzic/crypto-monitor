import Foundation
import Factory

protocol AssetsNetworkService: NetworkService {
    func fetchAssets() async throws -> [Asset]
    func fetchAssetIcons() async throws -> [AssetIcon]
}

struct DefaultAssetNetworkService: AssetsNetworkService {
    func fetchAssets() async throws -> [Asset] {
        return try await resolve(resource: AssetsResource.assets)
    }

    func fetchAssetIcons() async throws -> [AssetIcon] {
        try await resolve(resource: AssetsResource.icons(64))
    }
}

struct MockAssetsNetworkService: AssetsNetworkService {
    func fetchAssets() async throws -> [Asset] {
        try DefaultJSONMock<[Asset]>(fileName: "Assets")
            .mock()
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
