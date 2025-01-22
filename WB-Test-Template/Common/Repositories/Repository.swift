import Foundation
import CoreData

protocol Repository {
    associatedtype Model
    func fetchAll() async throws -> [Model]
    func insert(_ model: Model) async throws
    func insert(_ models: [Model]) async throws
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
