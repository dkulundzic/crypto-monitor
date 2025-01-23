import Foundation

struct Asset: Codable, Identifiable, Hashable {
    let assetId: String?
    let name: String?
    let typeIsCrypto: Int
    let dataQuoteStart: Date?
    let dataQuoteEnd: Date?
    let dataOrderbookStart: Date?
    let dataOrderbookEnd: Date?
    let dataTradeStart: Date?
    let dataTradeEnd: Date?
    let dataSymbolsCount: Int
    let volume1HrsUsd: Double
    let volume1DayUsd: Double
    let volume1MthUsd: Double
    let priceUsd: Double?
    let iconUrl: URL?
    var isFavorite: Bool = false

    var id: String {
        assetId ?? UUID().uuidString
    }

    func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(assetId)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.assetId == rhs.assetId
    }

    private enum CodingKeys: String, CodingKey {
        case assetId
        case name
        case typeIsCrypto
        case dataQuoteStart
        case dataQuoteEnd
        case dataOrderbookStart
        case dataOrderbookEnd
        case dataTradeStart
        case dataTradeEnd
        case dataSymbolsCount
        case volume1HrsUsd
        case volume1DayUsd
        case volume1MthUsd
        case priceUsd
        case iconUrl
    }
}

extension Collection where Element == Asset {
    func filter(
        searchText: String,
        favouritesExclusively: Bool
    ) -> [Element] {
        self.filter { asset in
            let matchesSearch = searchText.isEmpty ||
            asset.name.emptyIfNil.localizedCaseInsensitiveContains(searchText) ||
            asset.assetId.emptyIfNil.localizedCaseInsensitiveContains(searchText)

            let matchesFavorites = !favouritesExclusively || asset.isFavorite
            return matchesSearch && matchesFavorites
        }
    }
}
