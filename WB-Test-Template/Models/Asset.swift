import Foundation

struct Asset: Codable, Identifiable {
    let id = UUID()
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
    
    // Local properties
    var iconUrl: String {
        "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
    }
    
    enum CodingKeys: String, CodingKey {
        case assetId = "asset_id"
        case name = "name"
        case typeIsCrypto = "type_is_crypto"
        case dataQuoteStart = "data_quote_start"
        case dataQuoteEnd = "data_quote_end"
        case dataOrderbookStart = "data_orderbook_start"
        case dataOrderbookEnd = "data_orderbook_end"
        case dataTradeStart = "data_trade_start"
        case dataTradeEnd = "data_trade_end"
        case dataSymbolsCount = "data_symbols_count"
        case volume1HrsUsd = "volume_1hrs_usd"
        case volume1DayUsd = "volume_1day_usd"
        case volume1MthUsd = "volume_1mth_usd"
        case priceUsd = "price_usd"
    }
} 
