import Foundation
import Combine
import Factory

@MainActor
class AssetListViewModel: ViewModel {
    typealias View = AssetListView
    @Published var filteredAssets: [Asset] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var showFavoritesOnly = false
    @Published var searchText = ""
    @Published private var assets: [Asset] = []
    @Published private var icons: [AssetIcon] = []
    @Injected(\.assetsNetworkService) var assetsNetworkService
    private var bag = Set<AnyCancellable>()

    init() {
        initializeObserving()
    }

    func onAction(
        _ action: AssetListView.Action
    ) async {
        switch action {
        case .onTask, .onPullToRefresh:
            await loadAssets()
        }
    }
}

private extension AssetListViewModel {
    func initializeObserving() {
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

    func loadAssets() async {
        isLoading = filteredAssets.isEmpty
        defer { isLoading = false }

        do {
            async let assetsTask = assetsNetworkService.fetchAssets(filterAssetIds: [])
            async let iconsTask = assetsNetworkService.fetchAssetIcons()
            let (assets, icons) = try await (assetsTask, iconsTask)
            self.assets = assets
            self.icons = icons
        } catch {
            self.error = error.localizedDescription
        }
    }
}
