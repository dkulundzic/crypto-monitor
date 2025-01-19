import SwiftUI
import NukeUI

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

struct AssetRowView: View {
    let asset: Asset

    var body: some View {
        HStack {
            LazyImage(
                url: asset.iconUrl
            ) { state in
                if let image = state.image {
                    image.resizable()
                } else if state.error != nil {
                    Color.red
                } else {
                    ProgressView()
                }
            }
            .frame(width: 32, height: 32)

            VStack(
                alignment: .leading
            ) {
                Text(asset.name.emptyIfNil)
                    .font(.headline)
                Text(asset.assetId)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if asset.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    AssetListView()
}
