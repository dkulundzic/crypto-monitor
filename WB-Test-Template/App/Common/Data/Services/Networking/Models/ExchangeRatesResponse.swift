import Foundation

struct ExchangeRatesResponse: Decodable {
    let assetIdBase: String
    let rates: [ExchangeRate]
}
