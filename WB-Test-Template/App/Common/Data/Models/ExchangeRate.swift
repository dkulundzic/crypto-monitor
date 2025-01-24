import Foundation

struct ExchangeRate: Decodable, Identifiable, Hashable {
    let time: Date
    let rate: Double
    let assetIdQuote: String?

    var id: String? {
        assetIdQuote
    }
}

extension ExchangeRate: ManagedObjectTransformable {
    func toManaged(
        using object: ExchangeRateMO
    ) -> ExchangeRateMO {
        object.time = time
        object.rate = rate
        object.assetIdQuote = assetIdQuote
        return object
    }
}
