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

#Preview {
    let asset = try! DefaultJSONMock<[Asset]>(fileName: "Assets")
        .mock()
        .first!
    NavigationView {
        AssetDetailView(asset: asset)
    }
}
