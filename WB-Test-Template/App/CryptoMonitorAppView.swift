import SwiftUI

struct CryptoMonitorAppView: ActionableView {
    @StateObject private var viewModel = CryptoMonitorAppViewModel()

    var body: some View {
        AssetListView()
    }

    enum Action {
        case test
    }
}

#Preview {
    CryptoMonitorAppView()
}
