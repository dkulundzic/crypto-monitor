import SwiftUI

struct AssetListView: View {
    @StateObject private var viewModel = AssetListViewModel()
    @State private var searchText = ""
    @State private var showFavoritesOnly = false

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
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                viewModel.filterAssets(searchText: searchText)
            }
            .navigationTitle("Crypto Monitor")
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarTrailing
                ) {
                    Button {
                        showFavoritesOnly.toggle()
                        viewModel.toggleFavoritesFilter(showFavoritesOnly)
                    } label: {
                        Image(systemName: showFavoritesOnly ? "star.fill" : "star")
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
            AsyncImage(
                url: URL(string: asset.iconUrl)
            ) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
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
