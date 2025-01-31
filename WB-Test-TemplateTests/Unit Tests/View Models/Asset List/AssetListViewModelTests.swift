import XCTest
import Combine
import Factory
import ConcurrencyExtras
@testable import WB_Test_Template

final class AssetListViewModelTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()
        Container.shared.manager.push()
    }

    override func tearDown() async throws {
        try await super.tearDown()
        Container.shared.manager.pop()
    }

    func test_fetch_called_when_view_appears() async throws {
        let dataSource = AssetDataSourceMock()
        Container.shared.assetDataSource.register { dataSource }
        let viewModel = AssetListViewModel()

        await viewModel.onAction(.onTask)

        XCTAssertTrue(dataSource.wasFetchCalled)
    }

    func test_fetch_called_when_pull_to_refresh() async throws {
        let dataSource = AssetDataSourceMock()
        Container.shared.assetDataSource.register { dataSource }
        let viewModel = AssetListViewModel()

        await viewModel.onAction(.onPullToRefresh)

        XCTAssertTrue(dataSource.wasFetchCalled)
    }

    func test_loading_state_when_fetching() async throws {
        Container.shared.assetDataSource.register {
            AssetDataSourceMock()
        }

        await withMainSerialExecutor {
            let viewModel = AssetListViewModel()
            let task = Task { await viewModel.onAction(.onTask) }
            await Task.yield()

            XCTAssertTrue(viewModel.isLoading)
            await task.value
            XCTAssertFalse(viewModel.isLoading)
        }
    }

    func test_alert_state_when_data_source_throws_an_error() async throws {
        Container.shared.assetDataSource.register {
            AssetDataSourceThrowingMock()
        }
        let viewModel = AssetListViewModel()

        await viewModel.onAction(.onTask)

        XCTAssertNotNil(viewModel.error)
    }

    // WARNING: Might be flaky due to different Locales
    func test_last_updated_date_formatting() async throws {
        Container.shared.localAppStorage.register {
            LocalAppStorageMock()
        }
        let expectedFormattedDate = "01.01.2020., 00:00"
        let viewModel = AssetListViewModel()

        await viewModel.onAction(.onTask)

        XCTAssertNotNil(viewModel.formattedLastUpdateDate)
        XCTAssertEqual(expectedFormattedDate, viewModel.formattedLastUpdateDate)
    }
}
