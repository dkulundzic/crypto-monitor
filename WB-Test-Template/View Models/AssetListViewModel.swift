import Foundation
import Combine
import Factory

@MainActor
class AssetListViewModel: ObservableObject {
    @Published var filteredAssets: [Asset] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var showFavoritesOnly = false
    @Published var searchText = ""
    @Published private var assets: [Asset] = []
    @Injected(\.assetsNetworkService) var assetsNetworkService
    private var bag = Set<AnyCancellable>()

    init() {
        initializeObserving()
    }

    func loadAssets() async {
        isLoading = true
        defer { isLoading = false }

        do {
            assets = try await assetsNetworkService.fetchAssets(
                filterAssetIds: []
            )
        } catch {
            self.error = error.localizedDescription
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
}

private extension Collection where Element == Asset {
    func filter(
        searchText: String,
        favouritesExclusively: Bool
    ) -> [Element] {
        self.filter { asset in
            let matchesSearch = searchText.isEmpty ||
                asset.name.emptyIfNil.localizedCaseInsensitiveContains(searchText) ||
                asset.assetId.localizedCaseInsensitiveContains(searchText)

            let matchesFavorites = !favouritesExclusively || asset.isFavorite
            return matchesSearch && matchesFavorites
        }
    }
}
