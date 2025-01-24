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

extension Asset: ManagedObjectTransformable {
    func toManaged(
        using model: AssetMO
    ) -> AssetMO {
        model.assetId = assetId
        model.name = name
        model.dataQuoteStart = dataQuoteStart
        model.dataQuoteEnd = dataQuoteEnd
        model.dataOrderbookStart = dataOrderbookEnd
        model.dataTradeStart = dataTradeEnd
        model.typeIsCrypto = typeIsCrypto == 0 ? false : true
        model.dataSymbolsCount = Int64(dataSymbolsCount)
        model.volume1HrsUsd = volume1HrsUsd
        model.volume1DayUsd = volume1DayUsd
        model.volume1MthUsd = volume1MthUsd
        model.priceUsd = priceUsd ?? 0
        model.isFavorite = isFavorite
        model.iconUrl = iconUrl
        return model
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
            asset.id.localizedCaseInsensitiveContains(searchText)

            let matchesFavorites = !favouritesExclusively || asset.isFavorite
            return matchesSearch && matchesFavorites
        }
    }
}
