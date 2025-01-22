import CoreData

@objc(AssetMO)
final class AssetMO: NSManagedObject {
    @NSManaged public var assetId: String?
    @NSManaged public var name: String?
    @NSManaged public var dataOrderbookEnd: Date?
    @NSManaged public var dataOrderbookStart: Date?
    @NSManaged public var dataQuoteEnd: Date?
    @NSManaged public var dataQuoteStart: Date?
    @NSManaged public var dataSymbolsCount: Int64
    @NSManaged public var dataTradeEnd: Date?
    @NSManaged public var dataTradeStart: Date?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var priceUsd: Double
    @NSManaged public var typeIsCrypto: Bool
    @NSManaged public var volume1DayUsd: Double
    @NSManaged public var volume1HrsUsd: Double
    @NSManaged public var volume1MthUsd: Double

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssetMO> {
        return NSFetchRequest<AssetMO>(entityName: "Asset")
    }
}

extension AssetMO: Identifiable { }
