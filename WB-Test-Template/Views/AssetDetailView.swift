import SwiftUI

struct AssetDetailView: View {
    let asset: Asset

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
        }
        .navigationTitle(asset.name.emptyIfNil)
    }
}
