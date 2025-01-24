import Foundation
import CoreData

@globalActor actor RepositoryActor: GlobalActor {
    static var shared = RepositoryActor()
}

@RepositoryActor
protocol Repository {
    associatedtype Model
    nonisolated init()
    func fetch(id: String) async throws -> Model?
    func fetchAll() async throws -> [Model]
    func save(_ model: Model) async throws
    func save(_ models: [Model]) async throws
    func delete(_ id: String) async throws
}

protocol DomainObjectTransformable {
    associatedtype DomainModel
    func toDomain() -> DomainModel
}

protocol ManagedObjectTransformable {
    associatedtype ManagedModel: NSManagedObject
    func toManaged(using object: ManagedModel) -> ManagedModel
}
