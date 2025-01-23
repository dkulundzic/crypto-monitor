import Foundation

enum Statics {
    // swiftlint:disable:next line_length
    static let defaultAssetIconUrl: URL = "https://s3.eu-central-1.amazonaws.com/bbxt-static-icons/type-id/png_16/4958c92dbddd4936b1f655e5063dc782.png"
    static let popularExchangesRates = PopularExchangeRate.allCases

    enum PopularExchangeRate: String, CaseIterable {
        case usd = "USD"
        case eur = "EUR"
        case gbp = "GBP"
        case chf = "CHF"
        case btc = "BTC"
        case ethereum = "ETH"
        case solana = "SOL"

        static var textual: [String] {
            Self.allCases.map(\.rawValue)
        }
    }

}
