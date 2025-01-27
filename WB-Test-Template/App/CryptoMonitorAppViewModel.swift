import Foundation
import Combine
import Factory

final class CryptoMonitorAppViewModel: ViewModel {
    typealias View = CryptoMonitorAppView
    @Published private(set) var isOfflineIndicatorShown = false
    @Injected(\.connectivityObserver) private var connectivityObserver

    init() {
        initializeObserving()
    }

    func onAction(
        _ action: CryptoMonitorAppView.Action
    ) async { }
}

private extension CryptoMonitorAppViewModel {
    func initializeObserving() {
        connectivityObserver
            .isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .map { !$0 }
            .assign(to: &$isOfflineIndicatorShown)
    }
}
