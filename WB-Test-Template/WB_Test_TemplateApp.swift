import SwiftUI
import Factory

@main
struct WB_Test_TemplateApp: App {
    @Injected(\.exchangeRateNetworkService) var exchangeRateNetworkService

    init() {

    }

    var body: some Scene {
        WindowGroup {
            AssetListView()
        }
    }
}

private extension WB_Test_TemplateApp {
    func boostrap() {
        StartupProcessService()
    }
}
