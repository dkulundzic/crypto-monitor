import Foundation
import Factory
import CryptoMonitorModel

public protocol ExchangeRateNetworkService: NetworkService {
    func getAllRates(for assetId: String, filterAssetId: [String]) async throws -> [ExchangeRate]
    func get(for assetId: String, against assetIdQuote: String) async throws -> ExchangeRate
}

public struct DefaultExchangeRateNetworkService: ExchangeRateNetworkService {
    public func getAllRates(
        for assetId: String,
        filterAssetId: [String]
    ) async throws -> [ExchangeRate] {
        let response: ExchangeRatesResponse = try await resolve(
            resource: ExchangeRateResource.allRates(
                assetId: assetId, filterAssetId: filterAssetId
            )
        )
        return response.rates
    }

    public func get(
        for assetId: String,
        against assetIdQuote: String
    ) async throws -> ExchangeRate {
        try await resolve(
            resource: ExchangeRateResource.get(
                assetId: assetId,
                quote: assetIdQuote
            )
        )
    }
}

public extension Container {
    var exchangeRateNetworkService: Factory<ExchangeRateNetworkService> {
        self {
            DefaultExchangeRateNetworkService()
        }.unique
    }
}
