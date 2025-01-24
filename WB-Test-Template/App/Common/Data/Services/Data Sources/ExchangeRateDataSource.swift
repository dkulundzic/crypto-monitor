import Foundation
import Combine
import Factory

#warning("TODO: Think about extracting into a reusable type")
protocol ExchangeRateDataSource {
    var rates: AnyPublisher<[ExchangeRate], Never> { get }
    func fetchAll(for assetId: String, policy: DataSourceFetchPolicy) async throws
}

#warning("TODO: Think about error handling")
final class DefaultExchangeRateDataSource: ExchangeRateDataSource {
    var rates: AnyPublisher<[ExchangeRate], Never> {
        ratesSubject.eraseToAnyPublisher()
    }

    @Injected(\.exchangeRateRepository) private var ratesRepository
    @Injected(\.exchangeRateNetworkService) private var exchangeRateNetworkService
    private let ratesSubject = PassthroughSubject<[ExchangeRate], Never>()

    func fetchAll(
        for assetId: String,
        policy: DataSourceFetchPolicy
    ) async throws {
        try await Task {
            func optionalLoadFromCache() async {
                if let localExchangeRate = try? await ratesRepository.fetchAll() {
                    ratesSubject.send(localExchangeRate)
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
                ).rates
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

extension Container {
    var exchangeRatesDataSource: Factory<ExchangeRateDataSource> {
        self {
            DefaultExchangeRateDataSource()
        }.singleton
    }
}
