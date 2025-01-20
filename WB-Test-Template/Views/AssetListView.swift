import SwiftUI
import Factory

struct AssetListView: View {
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
                        AssetRowView(asset: asset)
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .searchable(text: $viewModel.searchText)
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
            await viewModel.loadAssets()
        }
    }
}

#Preview {
    Container.shared.assetsNetworkService.register {
        MockAssetsNetworkService()
    }
    return AssetListView()
}
