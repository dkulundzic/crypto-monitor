import Foundation
import CoreData
import Factory
import CryptoMonitorModel

public protocol ExchangeRateRepository: Repository where Model == ExchangeRate, Model: ManagedObjectTransformable { }

public final class DefaultExchangeRateRepository: ExchangeRateRepository {
    @Injected(\.viewContext) private var viewContext
    @Injected(\.backgroundContext) private var backgroundContext

    public func fetch(
        id: String
    ) async throws -> ExchangeRate? {
        let request = ExchangeRateMO.fetchRequest()
        request.predicate = NSPredicate(format: "assetId == %@", id)
        return try await viewContext.perform { [viewContext] in
            try viewContext.fetch(request)
                .first?
                .toDomain()
        }
    }

    public func fetchAll() async throws -> [ExchangeRate] {
        let request = ExchangeRateMO.fetchRequest()
        return try await viewContext.perform { [viewContext] in
            try viewContext.fetch(request)
                .map { $0.toDomain() }
        }
    }

    public func save(
        _ model: ExchangeRate
    ) async throws {
        try await viewContext.perform { [viewContext] in
            let transient = ExchangeRateMO(context: viewContext)
            _ = model.toManaged(using: transient)
            try viewContext.saveIfNeeded()
        }
    }

    public func save(
        _ models: [ExchangeRate]
    ) async throws {
        var iterator = models.makeIterator()
        let batchInsertRequest = NSBatchInsertRequest(
            entity: ExchangeRateMO.entity()
        ) { (object: NSManagedObject) in
            guard
                let model = iterator.next()
            else {
                return true
            }

            if let modelMO = object as? ExchangeRateMO {
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
        let fetchRequest = ExchangeRateMO.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "assetId == %@", assetId)

        try await backgroundContext.perform { [backgroundContext] in
            guard
                let relevantExchangeRate = try backgroundContext
                    .fetch(fetchRequest)
                    .first
            else {
                fatalError()
            }

            backgroundContext.delete(relevantExchangeRate)
            try backgroundContext.saveIfNeeded()
        }
    }
}

public extension Container {
    var exchangeRateRepository: Factory<any ExchangeRateRepository> {
        self {
            DefaultExchangeRateRepository()
        }
    }
}
