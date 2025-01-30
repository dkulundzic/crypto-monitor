import Foundation
import CoreData
import CryptoMonitorModel

@objc(ExchangeRateMO)
public final class ExchangeRateMO: NSManagedObject {
    @NSManaged public var time: Date
    @NSManaged public var rate: Double
    @NSManaged public var assetIdQuote: String?

    @nonobjc public static func fetchRequest() -> NSFetchRequest<ExchangeRateMO> {
        NSFetchRequest(entityName: "ExchangeRate")
    }
}

extension ExchangeRateMO: Identifiable { }

extension ExchangeRateMO: DomainObjectTransformable {
    public func toDomain() -> ExchangeRate {
        .init(
            time: time,
            rate: rate,
            assetIdQuote: assetIdQuote
        )
    }
}
