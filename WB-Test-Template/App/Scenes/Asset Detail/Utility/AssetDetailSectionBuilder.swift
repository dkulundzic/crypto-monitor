import Foundation
import CryptoMonitorModel

struct AssetDetailSectionBuilder {
    let asset: Asset
    let rates: [ExchangeRate]

    func build() -> [AssetDetailSection] {
        [
            buildExchangeRatesSection(), buildVolumesSection()
        ].compactMap { $0 }
    }
}

private extension AssetDetailSectionBuilder {
    func buildExchangeRatesSection() -> AssetDetailSection? {
        guard
            !rates.isEmpty
        else {
            return .exchangeRates(
                [
                    .init(title: "No available data", detail: "")
                ]
            )
        }
        let items: [AssetDetailSection.Item] = rates
            .map { rate in
                    .init(
                        title: rate.assetIdQuote.emptyIfNil,
                        detail: rate.rate
                            .formatted(
                                .currency(code: "")
                                .precision(.fractionLength(8))
                            )
                    )
            }
        return .exchangeRates(items)
    }

    func buildVolumesSection() -> AssetDetailSection {
        .volumes(
            [
                .init(
                    title: "Last Hour",
                    detail: asset.volume1HrsUsd.shortCurrencyFormatted
                ),
                .init(
                    title: "Last Day",
                    detail: asset.volume1DayUsd.shortCurrencyFormatted
                ),
                .init(
                    title: "Last Month",
                    detail: asset.volume1MthUsd.shortCurrencyFormatted
                )
            ]
        )
    }
}

private extension Double {
    var currencyFormatted: String {
        formatted(.number.precision(.fractionLength(8)))
    }

    var shortCurrencyFormatted: String {
        formatted(.number.precision(.fractionLength(2)))
    }
}
