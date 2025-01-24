import Foundation
import Combine
import Factory

@MainActor
class AssetListViewModel: ViewModel {
    typealias View = AssetListView
    @Published var searchText = ""
    @Published var showFavoritesOnly = false
    @Published private(set) var filteredAssets: [Asset] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    @Published private var assets: [Asset] = []
    @Injected(\.assetDataSource) var assetsDataSource
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
                includeCachedData: action == .onTask
            )
        }
    }
}

private extension AssetListViewModel {
    func initializeObserving() {
        assetsDataSource.assets
            .receive(on: DispatchQueue.main)
            .assign(to: &$assets)

        let searchTextPublisher = $searchText
            .removeDuplicates()
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        let favouritesPublisher = $showFavoritesOnly
            .removeDuplicates()
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        Publishers.CombineLatest3(
            $assets.removeDuplicates(), searchTextPublisher, favouritesPublisher
        )
        .map { assets, searchText, showFavoritesOnly in
            assets.filter(searchText: searchText, favouritesExclusively: showFavoritesOnly)
        }
        .assign(to: &$filteredAssets)
    }

    func loadAssets(
        includeCachedData: Bool
    ) async {
        isLoading = filteredAssets.isEmpty
        defer { isLoading = false }

        do {
            try await assetsDataSource.fetchAll(
                policy: includeCachedData ? .cacheThenRemote : .remoteOnly
            )
        } catch {
            self.error = error.localizedDescription
        }
    }
}
