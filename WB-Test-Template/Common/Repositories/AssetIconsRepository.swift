import Foundation
import CoreData
import Factory

protocol AssetIconsRepository: Repository where Model == AssetIcon, Model: ManagedObjectTransformable { }

final class DefaultAssetIconsRepository: AssetIconsRepository {
    @Injected(\.persistentContainer) private var persistentContainer

    func fetchAll() async throws -> [AssetIcon] {
        let request = AssetIconMO.fetchRequest()
        return try persistentContainer.viewContext.fetch(request)
            .map { $0.toDomain() }
    }

    func insert(
        _ model: AssetIcon
    ) async throws {
        let transient = AssetIconMO(context: persistentContainer.viewContext)
        _ = model.toManaged(using: transient)
        try persistentContainer.viewContext.saveIfNeeded()
    }

    func insert(
        _ models: [AssetIcon]
    ) async throws {
        var iterator = models.makeIterator()
        let batchInsertRequest = NSBatchInsertRequest(
            entity: AssetIconMO.entity()
        ) { (object: NSManagedObject) in
            guard
                let model = iterator.next()
            else {
                return true
            }

            if let modelMO = object as? AssetIconMO {
                _ = model.toManaged(using: modelMO)
            }

            return false
        }

        try persistentContainer.viewContext.execute(batchInsertRequest)
        try persistentContainer.viewContext.saveIfNeeded()
    }

    func delete(
        _ assetId: String
    ) async throws {
        let fetchRequest = AssetIconMO.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "assetId == %@", assetId)

        guard
            let relevantAsset = try persistentContainer.viewContext
                .fetch(fetchRequest)
                .first
        else {
            fatalError()
        }

        persistentContainer.viewContext.delete(relevantAsset)
        try persistentContainer.viewContext.saveIfNeeded()
    }
}

extension AssetIcon: ManagedObjectTransformable {
    func toManaged(
        using object: AssetIconMO
    ) -> AssetIconMO {
        object.assetId = assetId
        object.exchangeId = exchangeId
        object.url = url
        return object
    }
}

extension AssetIconMO: DomainObjectTransformable {
    func toDomain() -> AssetIcon {
        .init(
            exchangeId: exchangeId,
            assetId: assetId,
            url: url
        )
    }
}

extension Container {
    var assetIconsRepository: Factory<any AssetIconsRepository> {
        self {
            DefaultAssetIconsRepository()
        }
    }
}
