import Foundation
import CoreData
import Factory

public final class CoreDataStack: ObservableObject {
    public private(set) lazy var persistentContainer = {
        let modelName = "Model"

        guard
            let modelDir = Bundle(for: type(of: self))
                .url(forResource: modelName, withExtension: "momd")
        else {
            fatalError("Could not find model directory.")
        }

        guard
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelDir)
        else {
            fatalError("Could not find managed object model.")
        }

        let container = NSPersistentContainer(
            name: modelName,
            managedObjectModel: managedObjectModel
        )
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return container
    }()
}

public extension Container {
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

    var viewContext: Factory<NSManagedObjectContext> {
        self {
            Container.shared.persistentContainer.resolve().viewContext
        }
    }

    var backgroundContext: Factory<NSManagedObjectContext> {
        self {
            Container.shared.persistentContainer.resolve().newBackgroundContext()
        }.singleton
    }
}
