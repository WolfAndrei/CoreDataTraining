//
//  CoreDataStack.swift
//  CoreDataTraining
//
//  Created by Andrei Volkau on 13.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let model = "CoreDataModels"
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let persistentContainer = NSPersistentContainer(name: self.model)
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error)")
            }
        }
        return persistentContainer
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func saveContext() {
        if self.managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Unresolved error \(error)")
            }
        }
        
        
    }
    
    
}
