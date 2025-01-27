import SwiftUI
import Factory

struct AssetListView: ActionableView {
    @StateObject private var viewModel = AssetListViewModel()

    var body: some View {
        NavigationView {
            List {
                if let formattedLastUpdateDate = viewModel.formattedLastUpdateDate {
                    Group {
#warning("TODO: Localize")
                        Text("Last updated: ")
                            .font(.caption) +
                        Text(formattedLastUpdateDate)
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    .transition(.opacity)
                }

                ForEach(
                    viewModel.filteredAssets
                ) { asset in
                    NavigationLink(
                        destination: AssetDetailView(asset: asset)
                    ) {
                        AssetListRowView(
                            id: asset.id,
                            name: asset.name.emptyIfNil,
                            iconUrl: asset.iconUrl ?? "https://www.google.com",
                            isFavorite: asset.isFavorite
                        )
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText
            )
            .refreshable {
                await viewModel.onAction(.onPullToRefresh)
            }
            .animation(
                .default, value: viewModel.formattedLastUpdateDate
            )
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle(
                "Crypto Monitor"
            )
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
            .animation(
                .default, value: viewModel.filteredAssets
            )
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
