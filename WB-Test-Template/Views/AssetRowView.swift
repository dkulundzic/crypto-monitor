import SwiftUI
import NukeUI

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
