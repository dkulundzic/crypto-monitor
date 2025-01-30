import SwiftUI
import NukeUI
import Factory
import CryptoMonitorModel

struct AssetDetailView: ActionableView {
    @StateObject private var viewModel: AssetDetailViewModel

    init(
        asset: Asset
    ) {
        _viewModel = StateObject(
            wrappedValue: .init(asset: asset)
        )
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 32
        ) {
            List {
                AssetBookmarkButton(
                    isBookmarked: $viewModel.isBookmarked
                )

                ForEach(
                    viewModel.sections
                ) { section in
                    Section(
                        section.title
                    ) {
                        ForEach(section.items) { item in
                            DataPointView(
                                title: item.title,
                                detail: item.detail
                            )
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .animation(
            .spring, value: viewModel.sections
        )
        .refreshable {
            await viewModel.onAction(.onPullToRefresh)
        }
        .navigationTitle(
            viewModel.assetName
        )
        .navigationBarTitleDisplayMode(
            .inline
        )
        .toolbar {
            ToolbarItem(
                placement: .automatic
            ) {
                LazyImage(
                    url: viewModel.assetIconUrl
                ) { state in
                    if let image = state.image {
                        image.resizable()
                    } else if state.error != nil {
                        Color.red
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 20, height: 20)
            }
        }
        .alert(
            state: $viewModel.alertState
        )
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
    let asset = try? DefaultJSONMock<[Asset]>(fileName: "Assets").mock()[0]
    NavigationView {
        AssetDetailView(asset: asset!)
    }
}
