//
//  PersistentController.swift
//  My AppDB
//
//  Created by Marquis Kurt on 8/2/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let persistentContainer: NSPersistentContainer

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "AppDB Cart")
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    func doInContext(shouldSave: Bool = true, action: @escaping (NSManagedObjectContext) -> Void) {
        let ctx = persistentContainer.viewContext
        action(ctx)
        guard shouldSave, ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            print(error)
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if !context.hasChanges { return }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
