import SwiftUI
import NukeUI

struct AssetRowView: View {
    let id: String
    let name: String
    let iconUrl: URL
    let isFavorite: Bool

    var body: some View {
        HStack {
            LazyImage(
                url: iconUrl
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
                Text(name)
                    .font(.headline)
                Text(id)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}
