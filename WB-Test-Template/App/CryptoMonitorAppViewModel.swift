import Foundation
import Combine
import Factory

final class CryptoMonitorAppViewModel: ViewModel {
    typealias View = CryptoMonitorAppView
    @Injected(\.connectivityObserver) private var connectivityObserver
    private var bag = Set<AnyCancellable>()

    init() {
        initializeObserving()
    }

    func onAction(
        _ action: CryptoMonitorAppView.Action
    ) async {

    }
}

private extension CryptoMonitorAppViewModel {
    func initializeObserving() {
        connectivityObserver
            .isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { isConnected in
                print("Connectivity: \(isConnected)")
            }
            .store(in: &bag)
    }
}
