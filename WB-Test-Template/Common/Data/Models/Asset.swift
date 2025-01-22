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
    let volume1HrsUsd: Double?
    let volume1DayUsd: Double?
    let volume1MthUsd: Double?
    let priceUsd: Double?
    let iconUrl: URL
    var isFavorite: Bool = false

    var id: String {
        assetId ?? UUID().uuidString
    }

    init(
        assetId: String?,
        name: String?,
        typeIsCrypto: Int,
        dataQuoteStart: Date?,
        dataQuoteEnd: Date?,
        dataOrderbookStart: Date?,
        dataOrderbookEnd: Date?,
        dataTradeStart: Date?,
        dataTradeEnd: Date?,
        dataSymbolsCount: Int,
        volume1HrsUsd: Double?,
        volume1DayUsd: Double?,
        volume1MthUsd: Double?,
        priceUsd: Double?,
        iconUrl: URL?
    ) {
        self.assetId = assetId
        self.name = name
        self.typeIsCrypto = typeIsCrypto
        self.dataQuoteStart = dataQuoteStart
        self.dataQuoteEnd = dataQuoteEnd
        self.dataOrderbookStart = dataOrderbookStart
        self.dataOrderbookEnd = dataOrderbookEnd
        self.dataTradeStart = dataTradeStart
        self.dataTradeEnd = dataTradeEnd
        self.dataSymbolsCount = dataSymbolsCount
        self.volume1HrsUsd = volume1HrsUsd
        self.volume1DayUsd = volume1DayUsd
        self.volume1MthUsd = volume1MthUsd
        self.priceUsd = priceUsd
        self.iconUrl = iconUrl ?? "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
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
