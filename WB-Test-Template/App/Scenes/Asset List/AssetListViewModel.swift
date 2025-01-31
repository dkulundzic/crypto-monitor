import Foundation
import Combine
import Factory
import CryptoMonitorModel
import CryptoMonitorData

class AssetListViewModel: ViewModel {
    typealias View = AssetListView
    @Published var searchText = ""
    @Published var showFavoritesOnly = false
    @Published var error: AlertState?
    @Published private(set) var formattedLastUpdateDate: String?
    @Published private(set) var filteredAssets: [Asset] = []
    @Published private(set) var isLoading = false
    @Published private var assets: [Asset] = []
    @Injected(\.assetDataSource) private var assetsDataSource
    @Injected(\.localAppStorage) private var localAppStorage
    private var bag = Set<AnyCancellable>()

    init() {
        initializeObserving()
    }

    func onAction(
        _ action: AssetListView.Action
    ) async {
        switch action {
        case .onTask, .onPullToRefresh:
            await loadAssets(
                policy: .cacheThenRemote
            )
        }
    }
}

private extension AssetListViewModel {
    func initializeObserving() {
        let assetsPublisher = assetsDataSource
            .assetsPublisher
            .removeDuplicates()
            .receive(on: DispatchQueue.main)

        let searchTextPublisher = $searchText
            .removeDuplicates()
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        let favouritesPublisher = $showFavoritesOnly
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        Publishers.CombineLatest3(
            assetsPublisher,
            searchTextPublisher,
            favouritesPublisher
        )
        .map { assets, searchText, showFavoritesOnly in
            assets.filter(searchText: searchText, favouritesExclusively: showFavoritesOnly)
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$filteredAssets)

        localAppStorage.lastAssetCacheUpdateDatePublisher
            .map { date in
                if let date {
                    return DateFormatter.defaultDateAndTime.string(from: date)
                } else {
                    return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$formattedLastUpdateDate)
    }

    @MainActor
    func loadAssets(
        policy: DataSourceFetchPolicy
    ) async {
        isLoading = filteredAssets.isEmpty
        defer { isLoading = false }

        do {
            try await assetsDataSource.fetchAll(policy: policy)
        } catch {
            self.error = .error(
                error.localizedDescription,
                retry: { [weak self, policy] in
                    Task {
                        await self?.loadAssets(policy: policy)
                    }
                }
            )
        }
    }
}
