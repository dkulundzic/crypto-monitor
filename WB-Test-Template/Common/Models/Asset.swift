import Foundation

struct Asset: Codable, Identifiable, Hashable {
    let assetId: String
    let name: String?
    let typeIsCrypto: Int
    let dataQuoteStart: String?
    let dataQuoteEnd: String?
    let dataOrderbookStart: String?
    let dataOrderbookEnd: String?
    let dataTradeStart: String?
    let dataTradeEnd: String?
    let dataSymbolsCount: Int
    let volume1HrsUsd: Double?
    let volume1DayUsd: Double?
    let volume1MthUsd: Double?
    let priceUsd: Double?
    var isFavorite: Bool = false

    var id: String {
        assetId
    }

    var iconUrl: URL {
        "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
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
            asset.assetId.localizedCaseInsensitiveContains(searchText)

            let matchesFavorites = !favouritesExclusively || asset.isFavorite
            return matchesSearch && matchesFavorites
        }
    }
}
