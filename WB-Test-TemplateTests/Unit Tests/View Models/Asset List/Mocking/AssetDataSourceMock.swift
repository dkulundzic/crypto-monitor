import CryptoMonitorData
import CryptoMonitorModel
import CryptoMonitorCore
import Combine

final class AssetDataSourceMock: AssetsDataSource {
    var assets: [Asset] { assetsSubject.value }
    var assetsPublisher: AnyPublisher<[CryptoMonitorModel.Asset], Never> {
        assetsSubject.eraseToAnyPublisher()
    }

    var wasFetchCalled = false
    var wasBookmarkingCalled = false
    private let assetsSubject: CurrentValueSubject<[Asset], Never>

    init() {
        guard
            var assets: [Asset] = try? DefaultJSONMock(
                fileName: "Assets",
                bundle: .init(for: Self.self)
            ).mock()
        else {
            fatalError("Couldn't load the asset mock.")
        }

        assets = assets
            .enumerated()
            .map { offset, element in
                if offset > 0 {
                    var element = element
                    element.isFavorite = true
                    return element
                } else {
                    return element
                }
            }

        assetsSubject = .init(assets)
    }

    func fetchAll(
        policy: CryptoMonitorData.DataSourceFetchPolicy
    ) async throws {
        wasFetchCalled = true
        let oneSecond = 1_000_000_000
        try await Task.sleep(nanoseconds: UInt64(1 * oneSecond))
    }

    func setBookmark(
        _ bookmark: Bool,
        for asset: CryptoMonitorModel.Asset
    ) async throws {
        wasBookmarkingCalled = true
    }
}

final class AssetDataSourceErrorMock: AssetsDataSource {
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
    ) async throws {

    }

    enum PlaceholderError: Error {
        case error
    }
}
