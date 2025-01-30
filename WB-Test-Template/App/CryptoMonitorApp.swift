import SwiftUI
import Factory
import CryptoMonitorCore
import CryptoMonitorLocalization

@main
struct CryptoMonitorApp: App {
    init() {
        boostrap()
    }

    var body: some Scene {
        WindowGroup {
            CryptoMonitorAppView()
        }
    }
}

private extension CryptoMonitorApp {
    func boostrap() {
        StartupProcessService()
            .execute(AppearanceStartupProcess())
    }
}
