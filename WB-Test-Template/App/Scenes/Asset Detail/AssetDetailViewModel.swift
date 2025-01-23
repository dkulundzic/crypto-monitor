import Foundation
import Factory

import Combine

@MainActor
final class AssetDetailViewModel: ViewModel {
    typealias View = AssetDetailView
    @Published private(set) var sections = [AssetDetailSection]()
    @Published private var exchangeRates = [ExchangeRate]()
    @Injected(\.exchangeRateNetworkService) private var exchangeRateNetworkService
    private var bag = Set<AnyCancellable>()
    private let asset: Asset

    init(
        asset: Asset
    ) {
        self.asset = asset
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
    }

    func loadExchangeRates() async {
        exchangeRates = (try? await exchangeRateNetworkService.getAllRates(
            for: asset.assetId.emptyIfNil,
            filterAssetId: Statics.PopularExchangeRate.textual
        ).rates) ?? []
    }
}
