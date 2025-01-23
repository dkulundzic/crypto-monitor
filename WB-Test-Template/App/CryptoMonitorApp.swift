import SwiftUI
import Factory

@main
struct CryptoMonitorApp: App {
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

private extension CryptoMonitorApp {
    func boostrap() { }
}
