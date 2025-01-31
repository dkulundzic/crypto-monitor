import Foundation
import CryptoMonitorModel

public struct ExchangeRatesResponse: Codable {
    public let assetIdBase: String
    public let rates: [ExchangeRate]
}
