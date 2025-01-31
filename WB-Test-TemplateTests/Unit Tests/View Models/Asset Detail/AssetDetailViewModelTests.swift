import XCTest
import CryptoMonitorModel
import CryptoMonitorCore
import Factory
import ConcurrencyExtras
@testable import WB_Test_Template

final class AssetDetailViewModelTests: XCTestCase {
    private var asset: Asset {
        // swiftlint:disable:next force_try
        try! DefaultJSONMock<[Asset]>(
            fileName: "Assets", bundle: Bundle(for: Self.self)
        ).mock().first!
    }

    override func setUp() async throws {
        try await super.setUp()
        Container.shared.manager.push()
    }

    override func tearDown() async throws {
        try await super.tearDown()
        Container.shared.manager.pop()
    }

    func test_fetch_called_when_view_appears() async throws {
        let dataSource = ExchangeRateDataSourceMock()
        Container.shared.exchangeRatesDataSource.register { dataSource }
        let viewModel = AssetDetailViewModel(asset: asset)

        await viewModel.onAction(.onTask)

        XCTAssertTrue(dataSource.wasFetchCalled)
    }

    func test_fetch_called_when_pull_to_refresh() async throws {
        let dataSource = ExchangeRateDataSourceMock()
        Container.shared.exchangeRatesDataSource.register { dataSource }
        let viewModel = AssetDetailViewModel(asset: asset)

        await viewModel.onAction(.onPullToRefresh)

        XCTAssertTrue(dataSource.wasFetchCalled)
    }

    func test_alert_state_when_data_source_throws_an_error() async throws {
        Container.shared.exchangeRatesDataSource.register {
            ExchangeRateDataSourceThrowingMock()
        }
        let viewModel = AssetDetailViewModel(asset: asset)

        await viewModel.onAction(.onTask)

        XCTAssertNotNil(viewModel.alertState)
    }
}
