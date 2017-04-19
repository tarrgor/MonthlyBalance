//
//  CoreDataManager.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import Foundation
import CoreData

// Entity Constants
let kAccountEntity = "Account"

class CoreDataManager {

  static var testMode: Bool = false

  fileprivate static var _sharedManager: CoreDataManager?
  
  fileprivate var _databaseFileName: String
  
  // MARK: - Initialization
  
  fileprivate init() {
    self._databaseFileName = CoreDataManager.testMode ? "MonthlyBalanceData_Test.sqlite" : "MonthlyBalanceData.sqlite"
  }
  
  // MARK: - Singleton methods
  
  static func sharedManager() -> CoreDataManager {
    if _sharedManager == nil {
      self._sharedManager = CoreDataManager()
    }
    return _sharedManager!
  }
  
  // MARK: - Core Data stack
  
  fileprivate lazy var applicationDocumentsDirectory: URL = {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.karrmarrsoftware.MonthlyBalance" in the application's documents Application Support directory.
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
    // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    let modelURL = Bundle.main.url(forResource: "MonthlyBalance", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    // Create the coordinator and store
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent(self._databaseFileName)
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Helper methods for tests
  
  func deleteDatabase() -> Bool {
    var result: Bool = true
    
    let url = self.applicationDocumentsDirectory.appendingPathComponent(self._databaseFileName)

    do {
      if FileManager.default.fileExists(atPath: url.path) {
        try FileManager.default.removeItem(atPath: url.path)
        try FileManager.default.removeItem(atPath: "\(url.path)-shm")
        try FileManager.default.removeItem(atPath: "\(url.path)-wal")
      }
      CoreDataManager._sharedManager = CoreDataManager()
    } catch {
      result = false
    }
    return result
  }
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
}
