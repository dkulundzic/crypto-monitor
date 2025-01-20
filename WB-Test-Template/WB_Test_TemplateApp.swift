import SwiftUI
import Factory

@main
struct WB_Test_TemplateApp: App {
    @Injected(\.exchangeRateNetworkService) var exchangeRateNetworkService
    
    var body: some Scene {
        WindowGroup {
            AssetListView()
        }
    }
}

