import Foundation
import CoreData
import Factory
import CryptoMonitorModel

public protocol AssetRepository: Repository where Model == Asset, Model: ManagedObjectTransformable { }

public final class DefaultAssetRepository: AssetRepository {
    @Injected(\.viewContext) private var viewContext
    @Injected(\.backgroundContext) private var backgroundContext

    public func fetch(
        id: String
    ) async throws -> Asset? {
        let request = AssetMO.fetchRequest()
        request.predicate = NSPredicate(format: "assetId == %@", id)
        return try await viewContext.perform { [viewContext] in
            try viewContext.fetch(request)
                .first?
                .toDomain()
        }
    }

    public func fetchAll() async throws -> [Asset] {
        let request = AssetMO.fetchRequest()
        return try await viewContext.perform { [viewContext] in
            try viewContext.fetch(request)
                .map { $0.toDomain() }
        }
    }

    public func save(
        _ model: Asset
    ) async throws {
        return try await viewContext.perform { [viewContext] in
            let transient = AssetMO(context: viewContext)
            _ = model.toManaged(using: transient)
            try viewContext.saveIfNeeded()
        }
    }

    public func save(
        _ models: [Asset]
    ) async throws {
        var iterator = models.makeIterator()
        let batchInsertRequest = NSBatchInsertRequest(
            entity: AssetMO.entity()
        ) { (object: NSManagedObject) in
            guard
                let model = iterator.next()
            else {
                return true
            }

            if let modelMO = object as? AssetMO {
                _ = model.toManaged(using: modelMO)
            }

            return false
        }

        try await backgroundContext.perform { [backgroundContext] in
            try backgroundContext.execute(batchInsertRequest)
            try backgroundContext.saveIfNeeded()
        }
    }

    public func delete(
        _ assetId: String
    ) async throws {
        let fetchRequest = AssetMO.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "assetId == %@", assetId)

        try await backgroundContext.perform { [backgroundContext] in
            guard
                let relevantAsset = try backgroundContext
                    .fetch(fetchRequest)
                    .first
            else {
                fatalError()
            }

            backgroundContext.delete(relevantAsset)
            try backgroundContext.saveIfNeeded()
        }
    }
}

public extension Container {
    var assetRepository: Factory<any AssetRepository> {
        self {
            DefaultAssetRepository()
        }
    }
}
