//
//  TestCoreDataStack.swift
//  MoviesApp
//
//  Created by Mohamed abdelhamed on 02/01/2026.
//

import CoreData
@testable import MoviesApp

final class TestCoreDataStack {

    static let shared = TestCoreDataStack()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "MoviesApp")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }
}
