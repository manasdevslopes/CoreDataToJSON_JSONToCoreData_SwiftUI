//
//  Persistence.swift
//  CoreDataToJSON
//
//  Created by MANAS VIJAYWARGIYA on 06/03/23.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "CoreDataToJSON")
    guard let path = container.persistentStoreDescriptions.first?.url?.path else  {
      fatalError("Could not find persistence container")
    }
    print("Core Data Path ---->", path)
    
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print("Error loading core data: \(error), \(error.userInfo), \(error.localizedDescription) 🔴")
        return
      } else {
        print("Successfully loaded Core Data! ✅")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = true
  }
}
