import SwiftUI
import Factory

struct AssetListView: ActionableView {
    @StateObject private var viewModel = AssetListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(
                    viewModel.filteredAssets
                ) { asset in
                    NavigationLink(
                        destination: AssetDetailView(asset: asset)
                    ) {
                        AssetRowView(
                            id: asset.id,
                            name: asset.name.emptyIfNil,
                            iconUrl: asset.iconUrl,
                            isFavorite: asset.isFavorite
                        )
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .searchable(
                text: $viewModel.searchText
            )
            .refreshable {
                await viewModel.onAction(.onPullToRefresh)
            }
            .navigationTitle("Crypto Monitor")
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button {
                        viewModel.showFavoritesOnly.toggle()
                    } label: {
                        Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                    }
                }
            }
        }
        .task {
            await viewModel.onAction(.onTask)
        }
    }

    enum Action {
        case onTask
        case onPullToRefresh
    }
}

#Preview {
    Container.shared.assetsNetworkService.register {
        MockAssetsNetworkService()
    }
    return AssetListView()
}
