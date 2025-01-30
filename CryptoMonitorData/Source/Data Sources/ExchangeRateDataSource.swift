import Foundation
import Combine
import Factory
import CryptoMonitorModel
import CryptoMonitorNetworking
import CryptoMonitorPersistence

#warning("TODO: Think about extracting into a reusable type")
public protocol ExchangeRateDataSource {
    var rates: AnyPublisher<[ExchangeRate], Never> { get }
    func fetchAll(for assetId: String, policy: DataSourceFetchPolicy) async throws
}

#warning("TODO: Think about error handling")
public final class DefaultExchangeRateDataSource: ExchangeRateDataSource {
    public var rates: AnyPublisher<[ExchangeRate], Never> {
        ratesSubject.eraseToAnyPublisher()
    }

    @Injected(\.exchangeRateRepository) private var ratesRepository
    @Injected(\.exchangeRateNetworkService) private var exchangeRateNetworkService
    private let ratesSubject = PassthroughSubject<[ExchangeRate], Never>()

    public func fetchAll(
        for assetId: String,
        policy: DataSourceFetchPolicy
    ) async throws {
        try await Task {
            func optionalLoadFromCache() async {
                if let localExchangeRates = try? await ratesRepository.fetchAll(), !localExchangeRates.isEmpty {
                    ratesSubject.send(localExchangeRates)
                }
            }

            func loadFromCache() async throws {
                let freshLocalRates = try await ratesRepository.fetchAll()
                ratesSubject.send(freshLocalRates)
            }

            func loadFromRemote() async throws {
                let remoteRates = try await exchangeRateNetworkService.getAllRates(
                    for: assetId,
                    filterAssetId: Statics.popularExchangesRates.map(\.rawValue)
                )
                try await ratesRepository.save(remoteRates)
            }

            switch policy {
            case .cacheThenRemote:
                await optionalLoadFromCache()
                try await loadFromRemote()
                try await loadFromCache()
            case .remoteOnly:
                try await loadFromRemote()
                try await loadFromCache()
            case .cacheOnly:
                try await loadFromCache()
            }
        }.value
    }
}

public extension Container {
    var exchangeRatesDataSource: Factory<ExchangeRateDataSource> {
        self {
            DefaultExchangeRateDataSource()
        }.singleton
    }
}
