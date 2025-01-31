import Foundation
import Combine
import Factory
import CryptoMonitorModel
import CryptoMonitorData
import CryptoMonitorLocalization

final class AssetDetailViewModel: ViewModel {
    typealias View = AssetDetailView
    @Published var isBookmarked = false
    @Published var alertState: AlertState?
    @Published private(set) var sections = [AssetDetailSection]()
    @Published private var exchangeRates = [ExchangeRate]()
    @Injected(\.exchangeRatesDataSource) private var exchangeRatesDataSource
    @Injected(\.assetDataSource) private var assetDataSource
    private var bag = Set<AnyCancellable>()
    private let asset: Asset

    init(
        asset: Asset
    ) {
        self.asset = asset
        self.isBookmarked = asset.isFavorite
        initializeObserving()
    }

    func onAction(
        _ action: View.Action
    ) async {
        switch action {
        case .onTask, .onPullToRefresh:
            await loadExchangeRates()
        }
    }
}

extension AssetDetailViewModel {
    var assetName: String {
        asset.name ?? "Unknown Asset"
    }

    var assetIconUrl: URL? {
        asset.iconUrl
    }
}

private extension AssetDetailViewModel {
    func initializeObserving() {
        $exchangeRates
            .compactMap { [asset] rates in
                AssetDetailSectionBuilder(
                    asset: asset,
                    rates: rates.sorted(
                        by: { $0.assetIdQuote.emptyIfNil < $1.assetIdQuote.emptyIfNil }
                    )
                )
                .build()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$sections)

        $isBookmarked
            .dropFirst()
            .removeDuplicates()
            .sink { [asset, assetDataSource] isBookmarked in
                Task {
                    try await assetDataSource.setBookmark(isBookmarked, for: asset)
                    try await assetDataSource.fetchAll(policy: .cacheOnly)
                }
            }
            .store(in: &bag)

        exchangeRatesDataSource.ratesPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$exchangeRates)
    }

    @MainActor
    func loadExchangeRates() async {
        do {
            try await exchangeRatesDataSource
                .fetchAll(
                    for: asset.id,
                    policy: .cacheThenRemote
                )
        } catch {
            alertState =
                .error(
                    L10n.exchangeRatesLoadingError,
                    retry: { [weak self] in
                        Task { await self?.loadExchangeRates() }
                    }
                )
        }
    }
}
