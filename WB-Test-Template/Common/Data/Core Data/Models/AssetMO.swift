import CoreData

@objc(AssetMO)
final class AssetMO: NSManagedObject {
    @NSManaged var assetId: String?
    @NSManaged var name: String?
    @NSManaged var dataOrderbookEnd: Date?
    @NSManaged var dataOrderbookStart: Date?
    @NSManaged var dataQuoteEnd: Date?
    @NSManaged var dataQuoteStart: Date?
    @NSManaged var dataSymbolsCount: Int64
    @NSManaged var dataTradeEnd: Date?
    @NSManaged var dataTradeStart: Date?
    @NSManaged var isFavorite: Bool
    @NSManaged var priceUsd: Double
    @NSManaged var typeIsCrypto: Bool
    @NSManaged var volume1DayUsd: Double
    @NSManaged var volume1HrsUsd: Double
    @NSManaged var volume1MthUsd: Double
    @NSManaged var iconUrl: URL?

    @nonobjc class func fetchRequest() -> NSFetchRequest<AssetMO> {
        NSFetchRequest(entityName: "Asset")
    }
}

extension AssetMO: Identifiable { }
