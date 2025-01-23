import Foundation
import CoreData
import Factory

protocol AssetRepository: Repository where Model == Asset, Model: ManagedObjectTransformable { }

final class DefaultAssetRepository: AssetRepository {
    @Injected(\.persistentContainer) private var persistentContainer

    func fetchAll() async throws -> [Asset] {
        let request = AssetMO.fetchRequest()
        return try persistentContainer.viewContext.fetch(request)
            .map { $0.toDomain() }
    }

    func save(
        _ model: Asset
    ) async throws {
        let transient = AssetMO(context: persistentContainer.viewContext)
        _ = model.toManaged(using: transient)
        try persistentContainer.viewContext.saveIfNeeded()
    }

    func save(
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

        try persistentContainer.viewContext.execute(batchInsertRequest)
        try persistentContainer.viewContext.saveIfNeeded()
    }

    func delete(
        _ assetId: String
    ) async throws {
        let fetchRequest = AssetMO.fetchRequest()
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

extension Asset: ManagedObjectTransformable {
    func toManaged(
        using model: AssetMO
    ) -> AssetMO {
        model.assetId = assetId
        model.name = name
        model.dataQuoteStart = dataQuoteStart
        model.dataQuoteEnd = dataQuoteEnd
        model.dataOrderbookStart = dataOrderbookEnd
        model.dataTradeStart = dataTradeEnd
        model.typeIsCrypto = typeIsCrypto == 0 ? false : true
        model.dataSymbolsCount = Int64(dataSymbolsCount)
        model.volume1HrsUsd = volume1HrsUsd ?? 0
        model.volume1DayUsd = volume1DayUsd ?? 0
        model.volume1MthUsd = volume1MthUsd ?? 0
        model.priceUsd = priceUsd ?? 0
        model.isFavorite = isFavorite
        return model
    }
}

extension AssetMO: DomainObjectTransformable {
    func toDomain() -> Asset {
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
            iconUrl: iconUrl ?? Statics.defaultAssetIconUrl
        )
    }
}

extension Container {
    var compoundAssetRepository: Factory<any AssetRepository> {
        self {
            DefaultAssetRepository()
        }
    }
}
