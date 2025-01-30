import Foundation
import CoreData
import CryptoMonitorModel

@objc(ExchangeRateMO)
final class ExchangeRateMO: NSManagedObject {
    @NSManaged var time: Date
    @NSManaged var rate: Double
    @NSManaged var assetIdQuote: String?

    @nonobjc static func fetchRequest() -> NSFetchRequest<ExchangeRateMO> {
        NSFetchRequest(entityName: "ExchangeRate")
    }
}

extension ExchangeRateMO: Identifiable { }

extension ExchangeRateMO: DomainObjectTransformable {
    func toDomain() -> ExchangeRate {
        .init(
            time: time,
            rate: rate,
            assetIdQuote: assetIdQuote
        )
    }
}
