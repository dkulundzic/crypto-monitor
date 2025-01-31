import CryptoMonitorData
import CryptoMonitorModel
import CryptoMonitorCore
import Combine

final class AssetDataSourceThrowingMock: AssetsDataSource {
    var assets: [CryptoMonitorModel.Asset] {
        []
    }

    var assetsPublisher: AnyPublisher<[CryptoMonitorModel.Asset], Never> {
        Just([]).eraseToAnyPublisher()
    }

    func fetchAll(
        policy: CryptoMonitorData.DataSourceFetchPolicy
    ) async throws {
        throw PlaceholderError.error
    }

    func setBookmark(
        _ bookmark: Bool,
        for asset: CryptoMonitorModel.Asset
    ) async throws { }

    enum PlaceholderError: Error {
        case error
    }
}
