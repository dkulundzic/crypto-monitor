import Foundation

struct Asset: Codable, Identifiable {
    let assetId: String
    let name: String
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

    // Local properties
    var iconUrl: String {
        "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
    }
} 
