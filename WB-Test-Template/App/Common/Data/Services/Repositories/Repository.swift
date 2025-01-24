import Foundation
import CoreData

@globalActor actor RepositoryActor: GlobalActor {
    static var shared = RepositoryActor()
}

protocol Repository {
    associatedtype Model
    @RepositoryActor func fetch(id: String) async throws -> Model?
    @RepositoryActor func fetchAll() async throws -> [Model]
    @RepositoryActor func save(_ model: Model) async throws
    @RepositoryActor func save(_ models: [Model]) async throws
    @RepositoryActor func delete(_ id: String) async throws
}

protocol DomainObjectTransformable {
    associatedtype DomainModel
    func toDomain() -> DomainModel
}

protocol ManagedObjectTransformable {
    associatedtype ManagedModel: NSManagedObject
    func toManaged(using object: ManagedModel) -> ManagedModel
}
