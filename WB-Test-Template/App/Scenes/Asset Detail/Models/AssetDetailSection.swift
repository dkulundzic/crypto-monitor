import Foundation

enum AssetDetailSection: Identifiable, Hashable {
    case exchangeRates([Item])
    case volumes([Item])

    var id: String {
        switch self {
        case .exchangeRates:
            "exchange-rates-section"
        case .volumes:
            "volumes-rates-section"
        }
    }

    var title: String {
        switch self {
        case .exchangeRates:
            "Popular exchange rates"
        case .volumes:
            "Volumes (in USD)"
        }
    }

    var items: [Item] {
        switch self {
        case let .exchangeRates(items), let .volumes(items):
            items
        }
    }

    var isExchangesRatesSection: Bool {
        switch self {
        case .exchangeRates:
            true
        case .volumes:
            false
        }
    }

    var isVolumesSection: Bool {
        switch self {
        case .exchangeRates:
            false
        case .volumes:
            true
        }
    }

    struct Item: Identifiable, Hashable {
        let title: String
        let detail: String

        var id: String {
            title
        }
    }
}
