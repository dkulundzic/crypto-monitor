import Foundation
import Combine
import CryptoMonitorData
import CryptoMonitorModel
import CryptoMonitorNetworking
import CryptoMonitorCore

final class ExchangeRateDataSourceMock: ExchangeRateDataSource {
    var wasFetchCalled = false

    var rates: [ExchangeRate] = []

    var ratesPublisher: AnyPublisher<[CryptoMonitorModel.ExchangeRate], Never> {
        Just(rates).eraseToAnyPublisher()
    }

    func fetchAll(
        for assetId: String,
        policy: CryptoMonitorData.DataSourceFetchPolicy
    ) async throws {
        wasFetchCalled = true
        
        // swiftlint:disable:next force_try
        rates = try! DefaultJSONMock<ExchangeRatesResponse>(
            fileName: "ExchangeRates", bundle: Bundle(for: Self.self)
        ).mock().rates
    }
}
