//
//  CoreDataStack.swift
//  NasaPic
//
//  Created by Das,KomalNutan on 22/11/22.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modalName: String = "NasaPic"
    static let shared = CoreDataStack()
    
    private init() {}
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modalName)
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
        }
        // Merge the changes from other contexts automatically.
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        return container
    }()
    
    func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        DispatchQueue.main.async {[weak self] in
            if let strongSelf = self {
                block(strongSelf.persistentContainer.viewContext)
            }
        }
    }
}

extension CoreDataStack {
    
    /// Save Context
    /// - Parameters:
    ///   - context: Context
    ///   - completion: Completion Handler
    func save(context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint("Error: \(error)\nCould not save Core Data context.")
                completion(false)
                return
            }
            // Reset the taskContext to free the cache and lower the memory footprint.
            context.reset()
            completion(true)
        } else {
            completion(true)
        }
    }
}

