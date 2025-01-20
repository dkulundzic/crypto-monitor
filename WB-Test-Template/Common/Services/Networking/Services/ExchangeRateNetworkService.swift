import Foundation
import Factory

protocol ExchangeRateNetworkService: NetworkService {
    func get(for assetId: String, against assetIdQuote: String) async throws -> [ExchangeRate]
    func getAllRates(for assetId: String) async throws -> [ExchangeRate]
}

struct DefaultExchangeRateNetworkService: ExchangeRateNetworkService {
    func getAllRates(
        for assetId: String
    ) async throws -> [ExchangeRate] {
        try await resolve(
            resource: ExchangeRateResource.allRates(
                assetId: assetId
            )
        )
    }
    
    func get(
        for assetId: String,
        against assetIdQuote: String
    ) async throws -> [ExchangeRate] {
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
