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
final class DefaultAssetsDataSource: AssetsDataSource {
    var assets: AnyPublisher<[Asset], Never> {
        assetsSubject.eraseToAnyPublisher()
    }

    @Injected(\.compoundAssetRepository) private var compoundAssetRepository
    @Injected(\.assetsNetworkService) private var assetsNetworkService
    private let assetsSubject = PassthroughSubject<[Asset], Never>()

    func fetchAll(
        policy: DataSourceFetchPolicy
    ) async throws {
        try await Task {
            if policy.shouldLoadCachedData, let localAssets = try? await compoundAssetRepository.fetchAll() {
                assetsSubject.send(localAssets)
            }

            let icons = try await assetsNetworkService.fetchAssetIcons()
            let iconsMap = Dictionary(grouping: icons, by: { $0.assetId })
                .compactMapValues { $0.first?.url }
            let remoteAssets = try await assetsNetworkService.fetchAssets(
                filterAssetIds: []
            )
            let assets: [Asset] = remoteAssets.map {
                .init(
                    assetId: $0.assetId,
                    name: $0.name,
                    typeIsCrypto: $0.typeIsCrypto,
                    dataQuoteStart: $0.dataQuoteStart,
                    dataQuoteEnd: $0.dataQuoteEnd,
                    dataOrderbookStart: $0.dataOrderbookStart,
                    dataOrderbookEnd: $0.dataOrderbookEnd,
                    dataTradeStart: $0.dataTradeStart,
                    dataTradeEnd: $0.dataTradeEnd,
                    dataSymbolsCount: $0.dataSymbolsCount,
                    volume1HrsUsd: $0.volume1HrsUsd,
                    volume1DayUsd: $0.volume1DayUsd,
                    volume1MthUsd: $0.volume1MthUsd,
                    priceUsd: $0.priceUsd,
                    iconUrl: iconsMap[$0.assetId] ?? "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
                )
            }

            try await compoundAssetRepository.save(assets)

            let freshLocalAssets = try await compoundAssetRepository.fetchAll()
            assetsSubject.send(freshLocalAssets)
        }.value
    }
}

extension Container {
    var compoundAssetsDataSource: Factory<AssetsDataSource> {
        self {
            DefaultAssetsDataSource()
        }
    }
}
