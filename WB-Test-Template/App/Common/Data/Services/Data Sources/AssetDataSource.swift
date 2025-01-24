import Foundation
import Combine
import Factory

#warning("TODO: Think about extracting into a reusable type")
protocol AssetsDataSource {
    var assets: AnyPublisher<[Asset], Never> { get }
    func fetchAll(policy: DataSourceFetchPolicy) async throws
    func setBookmark(_ bookmark: Bool, for asset: Asset) async throws
}

#warning("TODO: Think about error handling")
final class DefaultAssetsDataSource: AssetsDataSource {
    var assets: AnyPublisher<[Asset], Never> {
        assetsSubject.eraseToAnyPublisher()
    }
    
    @Injected(\.assetRepository) private var assetRepository
    @Injected(\.assetsNetworkService) private var assetsNetworkService
    private let assetsSubject = PassthroughSubject<[Asset], Never>()

    func fetchAll(
        policy: DataSourceFetchPolicy
    ) async throws {
        try await Task {
            func optionalLoadFromCache() async {
                if let localAssets = try? await assetRepository.fetchAll() {
                    assetsSubject.send(localAssets)
                }
            }

            func loadFromCache() async throws {
                let freshLocalAssets = try await assetRepository.fetchAll()
                assetsSubject.send(freshLocalAssets)
            }

            func loadFromRemote() async throws {
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
                        iconUrl: iconsMap[$0.assetId] ?? Statics.defaultAssetIconUrl
                    )
                }

                try await assetRepository.save(assets)
            }

            switch policy {
            case .cacheThenRemote:
                await optionalLoadFromCache()
                try await loadFromRemote()
                try await loadFromCache()
            case .remoteOnly:
                try await loadFromRemote()
                try await loadFromCache()
            case .cacheOnly:
                try await loadFromCache()
            }
        }.value
    }

    func setBookmark(
        _ bookmark: Bool,
        for asset: Asset
    ) async throws {
        let request = AssetMO.fetchRequest()
        request.predicate = NSPredicate(
            format: "assetId == %@", asset.id
        )

        if var asset = try await assetRepository.fetch(
            id: asset.id
        ) {
            asset.isFavorite = bookmark
            try await assetRepository.save(asset)
        }
    }
}

extension Container {
    var assetDataSource: Factory<AssetsDataSource> {
        self {
            DefaultAssetsDataSource()
        }.singleton
    }
}
