import SwiftUI

struct CryptoMonitorAppView: ActionableView {
    @StateObject private var viewModel = CryptoMonitorAppViewModel()

    var body: some View {
        AssetListView()
            .animation(
                .default, value: viewModel.isOfflineIndicatorShown
            )
            .safeAreaInset(
                edge: .bottom
            ) {
                if viewModel.isOfflineIndicatorShown {
                    OfflineBannerView()
                        .transition(
                            .slide.combined(with: .opacity)
                        )
                }
            }
    }

    enum Action {
        case test
    }
}

#Preview {
    CryptoMonitorAppView()
}
