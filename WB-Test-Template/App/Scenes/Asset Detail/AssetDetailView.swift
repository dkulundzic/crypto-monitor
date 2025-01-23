import SwiftUI
import NukeUI
import Factory

struct AssetDetailView: ActionableView {
    let asset: Asset

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 32
        ) {
            List {
                Section("Exchange rates") {
                    Text("Test")
                }

                Section("Exchange rates") {

                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle(asset.name.emptyIfNil)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .automatic
            ) {
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
                .frame(width: 16, height: 16)
            }
        }
    }

    enum Action { }
}

#Preview {
    let asset = try? DefaultJSONMock<[Asset]>(fileName: "Assets").mock()[0]
    NavigationView {
        AssetDetailView(asset: asset!)
    }
}
