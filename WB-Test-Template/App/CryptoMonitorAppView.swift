import SwiftUI

struct CryptoMonitorAppView: ActionableView {
    @StateObject private var viewModel = CryptoMonitorAppViewModel()

    var body: some View {
        AssetListView()
            .safeAreaInset(
                edge: .bottom
            ) {
                if viewModel.isOfflineIndicatorShown {
                    VStack {
                        Divider()

#warning("TODO: Localize")
                        Text("You're currently offline")
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                    .background()
                    .ignoresSafeArea(.keyboard)
                    .transition(
                        .slide.combined(with: .opacity)
                    )
                }
            }
            .animation(
                .default, value: viewModel.isOfflineIndicatorShown
            )
    }

    enum Action {
        case test
    }
}

#Preview {
    CryptoMonitorAppView()
}
