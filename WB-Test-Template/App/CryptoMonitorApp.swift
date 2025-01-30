import SwiftUI
import Factory
import CryptoMonitorCore

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
