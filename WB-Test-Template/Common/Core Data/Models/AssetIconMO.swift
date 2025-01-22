import CoreData

@objc(AssetIconMO)
final class AssetIconMO: NSManagedObject {
    @NSManaged var assetId: String?
    @NSManaged var exchangeId: String?
    @NSManaged var url: URL?

    @nonobjc class func fetchRequest() -> NSFetchRequest<AssetIconMO> {
        NSFetchRequest(entityName: "AssetIcon")
    }
}

extension AssetIconMO: Identifiable { }
