import Foundation
import Combine
import CryptoMonitorData
import CryptoMonitorModel

final class ExchangeRateDataSourceThrowingMock: ExchangeRateDataSource {
    var rates: [CryptoMonitorModel.ExchangeRate] {
        []
    }

    var ratesPublisher: AnyPublisher<[CryptoMonitorModel.ExchangeRate], Never> {
        Just([]).eraseToAnyPublisher()
    }

    func fetchAll(
        for assetId: String,
        policy: CryptoMonitorData.DataSourceFetchPolicy
    ) async throws {
        throw PlaceholderError.error
    }

    enum PlaceholderError: Error {
        case error
    }
}
