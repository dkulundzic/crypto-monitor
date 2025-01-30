import Foundation
import Factory
import CryptoMonitorModel

protocol ExchangeRateNetworkService: NetworkService {
    func getAllRates(for assetId: String, filterAssetId: [String]) async throws -> ExchangeRatesResponse
    func get(for assetId: String, against assetIdQuote: String) async throws -> ExchangeRate
}

struct DefaultExchangeRateNetworkService: ExchangeRateNetworkService {
    func getAllRates(
        for assetId: String,
        filterAssetId: [String]
    ) async throws -> ExchangeRatesResponse {
        try await resolve(
            resource: ExchangeRateResource.allRates(
                assetId: assetId, filterAssetId: filterAssetId
            )
        )
    }

    func get(
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

extension Container {
    var exchangeRateNetworkService: Factory<ExchangeRateNetworkService> {
        self {
            DefaultExchangeRateNetworkService()
        }.unique
    }
}
