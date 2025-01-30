import Foundation

public struct Asset: Codable, Identifiable, Hashable {
    public let assetId: String?
    public let name: String?
    public let typeIsCrypto: Int
    public let dataQuoteStart: Date?
    public let dataQuoteEnd: Date?
    public let dataOrderbookStart: Date?
    public let dataOrderbookEnd: Date?
    public let dataTradeStart: Date?
    public let dataTradeEnd: Date?
    public let dataSymbolsCount: Int
    public let volume1HrsUsd: Double
    public let volume1DayUsd: Double
    public let volume1MthUsd: Double
    public let priceUsd: Double?
    public let iconUrl: URL?
    public var isFavorite: Bool = false

    public var id: String {
        assetId ?? UUID().uuidString
    }

    public init(
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
        volume1HrsUsd: Double,
        volume1DayUsd: Double,
        volume1MthUsd: Double,
        priceUsd: Double?,
        iconUrl: URL?,
        isFavorite: Bool = false
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
        self.iconUrl = iconUrl
        self.isFavorite = isFavorite
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

public extension Collection where Element == Asset {
    func filter(
        searchText: String,
        favouritesExclusively: Bool
    ) -> [Element] {
        self.filter { asset in
            let matchesSearch = searchText.isEmpty ||
            asset.name.emptyIfNil.localizedCaseInsensitiveContains(searchText) ||
            asset.id.localizedCaseInsensitiveContains(searchText)

            let matchesFavorites = !favouritesExclusively || asset.isFavorite
            return matchesSearch && matchesFavorites
        }
    }
}
