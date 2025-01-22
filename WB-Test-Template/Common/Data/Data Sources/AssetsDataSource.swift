import Foundation
import Combine
import Factory

enum DataSourceFetchPolicy {
    case loadLocalThenRemote
    case loadRemoteOnly

    var shouldLoadCachedData: Bool {
        switch self {
        case .loadLocalThenRemote:
            return true
        case .loadRemoteOnly:
            return false
        }
    }
}

protocol AssetsDataSource {
    var assets: AnyPublisher<[Asset], Never> { get }
    func fetchAll(policy: DataSourceFetchPolicy) async throws
}

#warning("TODO: Think about error handling")
final class DefaultAssetDataSource: AssetsDataSource {
    var assets: AnyPublisher<[Asset], Never> {
        assetsSubject.eraseToAnyPublisher()
    }

    @Injected(\.assetsNetworkService) private var assetsNetworkService
    @Injected(\.assetRepository) private var assetRepository
    private let assetsSubject = PassthroughSubject<[Asset], Never>()

    func fetchAll(
        policy: DataSourceFetchPolicy
    ) async throws {
        try await Task {
            if policy.shouldLoadCachedData, let localAssets = try? await assetRepository.fetchAll() {
                assetsSubject.send(localAssets)
            }

            let remoteAssets = try await assetsNetworkService.fetchAssets(
                filterAssetIds: []
            )
            try await assetRepository.insert(remoteAssets)

            let freshLocalAssets = try await assetRepository.fetchAll()
            assetsSubject.send(freshLocalAssets)
        }.value
    }
}

private extension DefaultAssetDataSource {
    func cache(
        assets: [Asset]
    ) async throws {
        do {
            try await assetRepository.insert(assets)
            print("Successfully cached \(assets.count) assets.")
        } catch {
            print("Failed caching \(assets.count) assets with error: ", error)
            throw error
        }
    }
}

extension Container {
    var assetsDataSource: Factory<AssetsDataSource> {
        self {
            DefaultAssetDataSource()
        }
    }
}
