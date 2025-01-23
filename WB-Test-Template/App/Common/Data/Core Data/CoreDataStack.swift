import Foundation
import CoreData
import Factory

final class CoreDataStack: ObservableObject {
    private(set) lazy var persistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return container
    }()
}

extension Container {
    var coreDataStack: Factory<CoreDataStack> {
        self {
            CoreDataStack()
        }.singleton
    }

    var persistentContainer: Factory<NSPersistentContainer> {
        self {
            Container.shared.coreDataStack.resolve().persistentContainer
        }
    }

    var managedObjectContext: Factory<NSManagedObjectContext> {
        self {
            Container.shared.persistentContainer.resolve().viewContext
        }
    }
}
