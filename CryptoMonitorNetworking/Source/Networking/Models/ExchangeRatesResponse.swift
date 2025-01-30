import Foundation
import CryptoMonitorModel

struct ExchangeRatesResponse: Decodable {
    let assetIdBase: String
    let rates: [ExchangeRate]
}
