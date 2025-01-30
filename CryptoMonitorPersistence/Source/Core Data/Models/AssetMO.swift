import CoreData
import CryptoMonitorModel

@objc(AssetMO)
public final class AssetMO: NSManagedObject {
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
    @NSManaged public var iconUrl: URL?

    @nonobjc public static func fetchRequest() -> NSFetchRequest<AssetMO> {
        NSFetchRequest(entityName: "Asset")
    }
}

extension AssetMO: Identifiable { }

extension AssetMO: DomainObjectTransformable {
    public func toDomain() -> Asset {
        .init(
            assetId: assetId,
            name: name,
            typeIsCrypto: typeIsCrypto ? 1 : 0,
            dataQuoteStart: dataQuoteStart,
            dataQuoteEnd: dataQuoteEnd,
            dataOrderbookStart: dataOrderbookStart,
            dataOrderbookEnd: dataOrderbookEnd,
            dataTradeStart: dataTradeStart,
            dataTradeEnd: dataTradeEnd,
            dataSymbolsCount: Int(dataSymbolsCount),
            volume1HrsUsd: volume1HrsUsd,
            volume1DayUsd: volume1DayUsd,
            volume1MthUsd: volume1MthUsd,
            priceUsd: priceUsd,
            iconUrl: iconUrl ?? Statics.defaultAssetIconUrl,
            isFavorite: isFavorite
        )
    }
}
