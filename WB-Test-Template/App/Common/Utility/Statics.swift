import Foundation

enum Statics {
    // swiftlint:disable:next line_length
    static let defaultAssetIconUrl: URL = "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
    static let popularExchangesRates = PopularExchangeRate.allCases

    enum PopularExchangeRate: String, CaseIterable {
        case usd = "USD"
        case cad = "CAD"
        case aud = "AUD"
        case nzd = "NZD"
        case eur = "EUR"
        case gbp = "GBP"
        case zloty = "PLN"
        case chf = "CHF"
        case sek = "SEK"
        case krone = "DKK"
        case ruble = "RUB"
        case btc = "BTC"
        case ethereum = "ETH"
        case solana = "SOL"

        static var textual: [String] {
            Self.allCases.map(\.rawValue)
        }
    }

}
