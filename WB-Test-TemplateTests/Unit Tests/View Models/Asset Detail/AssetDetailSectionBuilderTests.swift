import XCTest
@testable import WB_Test_Template
import CryptoMonitorModel
import CryptoMonitorCore
import Factory
import ConcurrencyExtras

final class AssetDetailSectionBuilderTests: XCTestCase {
    private var asset: Asset {
        // swiftlint:disable:next force_try
        try! DefaultJSONMock<[Asset]>(
            fileName: "Assets", bundle: Bundle(for: Self.self)
        ).mock().first!
    }

    func test_section_creation() async throws {
        let dataSource = ExchangeRateDataSourceMock()
        try await dataSource.fetchAll(for: "", policy: .cacheOnly)
        let rates = dataSource.rates
        let sections = AssetDetailSectionBuilder(
            asset: asset, rates: rates
        ).build()

        let exchangeRatesSection = try XCTUnwrap(
            sections.first(where: { $0.isExchangesRatesSection })
        )
        XCTAssertTrue(exchangeRatesSection.items.count == rates.count)

        let volumesSection = try XCTUnwrap(
            sections.first(where: { $0.isVolumesSection })
        )
        XCTAssertTrue(volumesSection.items.count == 3)
    }

    func test_section_creation_without_rates() async throws {
        let sections = AssetDetailSectionBuilder(
            asset: asset, rates: []
        ).build()

        let exchangeRatesSection = try XCTUnwrap(
            sections.first(where: { $0.isExchangesRatesSection })
        )
        XCTAssertTrue(exchangeRatesSection.items.count == 1)
    }
}
