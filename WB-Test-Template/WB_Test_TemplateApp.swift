import SwiftUI
import Factory

@main
struct WB_Test_TemplateApp: App {
    @Injected(\.exchangeRateNetworkService) private var exchangeRateNetworkService
    @InjectedObject(\.coreDataStack) private var coreDataStack

    init() {
        boostrap()
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
            .execute(CoreDataStackStartupProcess())
    }
}
