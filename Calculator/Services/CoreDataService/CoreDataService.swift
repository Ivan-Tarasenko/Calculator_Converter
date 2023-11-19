//
//  CoreDataService.swift
//  Calculator
//
//  Created by Иван Тарасенко on 11.11.2023.
//

import Foundation
import CoreData
import UIKit
import CryptoKit

struct DataEntity {
    static let entityName = "CurrencyData"
    static let keyAtribut = "data"
}

final class CoreDataService {
    
    static let shared = CoreDataService()
    var data: NSManagedObject?
    
    private var managedContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            return managedContext
        }
        return nil
    }
    
    private init() {}
    
    func save(data: Data) {
        guard let managedContext = managedContext else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: DataEntity.entityName, in: managedContext) else { return }
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        managedObject.setValue(data, forKey: DataEntity.keyAtribut)
        
        clearDatabase()
        
        do {
            try managedContext.save()
            self.data = managedObject
        } catch let error as NSError {
            print("Coud not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getFetchData() {
        guard let managedContext = managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataEntity.entityName)
        
        do {
            data = try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Coud not fetch \(error), \(error.userInfo)")
        }
    }
    
    private func clearDatabase() {
        guard let managedContext = managedContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DataEntity.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Coud not fetch \(error), \(error.userInfo)")
        }
    }
    
    func isDatabaseEmpty() -> Bool {
        guard let managedContext = managedContext else { return true }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataEntity.entityName)
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count == 0 ? true : false
        } catch {
            print("Error checking database: \(error.localizedDescription)")
            return true
        }
    }

    func compareDataFromDatabase(and fetch: Data) -> Bool {
        getFetchData()
        guard let data = data?.value(forKey: DataEntity.keyAtribut) as? Data else { return false}
        return checkHash(lhs: data, rhs: fetch)
    }
    
    private func checkHash(lhs: Data, rhs: Data) -> Bool {
         let lhsHash = SHA256.hash(data: lhs)
         let rhsHash = SHA256.hash(data: rhs)
        print("///////////////////////")
        print(lhsHash.description)
        print(rhsHash.description)
        
         return lhsHash == rhsHash ? true : false
     }
}
