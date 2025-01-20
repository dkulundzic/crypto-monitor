import Foundation

struct ExchangeRate: Decodable {
    let time: Date
    let rate: Double
    let assetIdQuote: String?
}
