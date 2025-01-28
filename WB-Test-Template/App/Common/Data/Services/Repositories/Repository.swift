import Foundation
import CoreData
import Factory

protocol Repository {
    associatedtype Model: ManagedObjectTransformable
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
