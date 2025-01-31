import Foundation
import Combine
import CryptoMonitorData
import CryptoMonitorModel

final class ExchangeRateDataSourceMock: ExchangeRateDataSource {
    var wasFetchCalled = false

    var rates: AnyPublisher<[CryptoMonitorModel.ExchangeRate], Never> {
        Just([]).eraseToAnyPublisher()
    }

    func fetchAll(
        for assetId: String,
        policy: CryptoMonitorData.DataSourceFetchPolicy
    ) async throws {
        wasFetchCalled = true
    }
}
