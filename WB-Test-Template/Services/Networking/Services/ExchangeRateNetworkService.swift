import Foundation
import Factory

protocol ExchangeRateNetworkService {
    func get(for assetId: String, assetIdQuote: String) async throws -> Any
}

struct DefaultExchangeRateNetworkService: ExchangeRateNetworkService {
    func get(
        for assetId: String,
        assetIdQuote: String
    ) async throws -> Any {
        fatalError()
    }
}

extension Container {
    var exchangeRateNetworkService: Factory<ExchangeRateNetworkService> {
        self {
            DefaultExchangeRateNetworkService()
        }.unique
    }
}
