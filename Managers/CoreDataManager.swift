//
//  CoreDataManager.swift
//  ridetec
//
//  Created by jose juan alcantara rincon on 28/11/21.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Ridetec")
        persistentContainer.loadPersistentStores{ (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func saveUser(id: String, email: String) {
        let user = User(context: persistentContainer.viewContext)
        user.id = id
        user.email = email
        
        do {
           try persistentContainer.viewContext.save()
            print("Session started successfully")
        } catch {
            print("Failed to save user \(error.localizedDescription)")
        }
    }
    
    func getUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            return User()
        }
    }
    
    func deleteUser(user: User) {
        persistentContainer.viewContext.delete(user)
        
        do {
            try persistentContainer.viewContext.save()
            print("Session ended successfully")
        } catch {
            persistentContainer.viewContext.rollback()
            print("Can't ended session")
        }
    }
    
    func deleteAllUsers() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print ("There is an error in deleting records")
        }
    }
}
