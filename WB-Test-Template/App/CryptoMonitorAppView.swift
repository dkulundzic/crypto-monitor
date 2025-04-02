import SwiftUI

struct CryptoMonitorAppView: ActionableView {
    @StateObject private var viewModel = CryptoMonitorAppViewModel()

    var body: some View {
        KnowledgeAndExperienceView()
    }

    enum Action {
        case test
    }
}

#Preview {
    CryptoMonitorAppView()
}
