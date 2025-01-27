import Foundation
import Network
import Combine
import Factory

protocol ConnectivityObserving {
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

final class DefaultConnectivityObserving: ConnectivityObserving {
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private lazy var isConnectedSubject = CurrentValueSubject<Bool, Never>(
        monitor.currentPath.status == .satisfied
    )
    private let monitor = NWPathMonitor(requiredInterfaceType: .wifi)
    private let queue = DispatchQueue(label: "connectivity-observing-queue")

    init() {
        initializeObserving()
    }
}

private extension DefaultConnectivityObserving {
    func initializeObserving() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectedSubject.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}

extension Container {
    var connectivityObserver: Factory<ConnectivityObserving> {
        self {
            DefaultConnectivityObserving()
        }
        .singleton
    }
}
