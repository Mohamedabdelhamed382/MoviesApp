//
//  CoreDataStack.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 02/01/2026.
//

import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesApp")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
