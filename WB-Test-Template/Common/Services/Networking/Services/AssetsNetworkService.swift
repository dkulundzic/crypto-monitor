import Foundation
import Factory

protocol AssetsNetworkService: NetworkService {
    func fetchAssets() async throws -> [Asset]
    func fetchAssetIcon() async throws -> Data
}

struct DefaultAssetsetNetworkService: AssetsNetworkService {
    func fetchAssets() async throws -> [Asset] {
        try await resolve(resource: AssetsResource.assets)
    }

    func fetchAssetIcon() async throws -> Data {
        fatalError()
    }
}

struct MockAssetsNetworkService: AssetsNetworkService {
    func fetchAssets() async throws -> [Asset] {
        try DefaultJSONMock<[Asset]>(fileName: "Assets")
            .mock()
    }

    func fetchAssetIcon() async throws -> Data {
        fatalError()
    }
}

extension Container {
    var assetsNetworkService: Factory<AssetsNetworkService> {
        self {
            DefaultAssetsetNetworkService()
        }.unique
    }
}
