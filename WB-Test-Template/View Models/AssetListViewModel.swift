import Foundation
import Factory

@MainActor
class AssetListViewModel: ObservableObject {
    @Published var assets: [Asset] = []
    @Published var filteredAssets: [Asset] = []
    @Published var isLoading = false
    @Published var error: String?
    private var showFavoritesOnly = false
    private var searchText = ""
    @Injected(\.assetsNetworkService) var assetsNetworkService

    func loadAssets() async {
        isLoading = true
        defer { isLoading = false }

        do {
            assets = try await assetsNetworkService.fetchAssets()
            filterAssets(searchText: searchText)
        } catch {
            self.error = error.localizedDescription
        }
    }

    func filterAssets(searchText: String) {
        self.searchText = searchText
        applyFilters()
    }

    func toggleFavoritesFilter(_ showFavorites: Bool) {
        showFavoritesOnly = showFavorites
        applyFilters()
    }

    private func applyFilters() {
        filteredAssets = assets.filter { asset in
            let matchesSearch = searchText.isEmpty ||
                asset.name.emptyIfNil.localizedCaseInsensitiveContains(searchText) ||
                asset.assetId.localizedCaseInsensitiveContains(searchText)

            let matchesFavorites = !showFavoritesOnly || asset.isFavorite
            return matchesSearch && matchesFavorites
        }
    }
}
