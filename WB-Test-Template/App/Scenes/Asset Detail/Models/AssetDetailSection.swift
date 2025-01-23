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

    struct Item: Identifiable, Hashable {
        let title: String
        let detail: String

        var id: String {
            title
        }
    }
}
