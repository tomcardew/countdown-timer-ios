//
//  StorageManager.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import UIKit
import CoreData

final class StorageManager {
    
    enum StorageErrors: Error {
        case appDelegateNotFound
        case savingError
        case objectNotFound(NSManagedObjectID)
    }
    
    static let shared = StorageManager()
    
    var appDelegate: AppDelegate?
    
    func save(id: Int, name: String, date: Date, completion: @escaping ((Result<NSManagedObject, Error>) -> Void)) {
        if appDelegate == nil {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                completion(.failure(StorageErrors.appDelegateNotFound))
                return
            }
            self.appDelegate = delegate
        }
        let managedContext = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Events", in: managedContext)!
        let newEvent = NSManagedObject(entity: entity, insertInto: managedContext)
        newEvent.setValue(id, forKey: "id")
        newEvent.setValue(name, forKey: "name")
        newEvent.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
            completion(.success(newEvent))
        } catch {
            print("Could not save. \(error)")
            completion(.failure(error))
        }
    }
    
    func fetchAll(completion: ((Result<[NSManagedObject], Error>) -> Void)?) {
        if appDelegate == nil {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                completion?(.failure(StorageErrors.appDelegateNotFound))
                return
            }
            self.appDelegate = delegate
        }
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Events")
        
        do {
            let events = try managedContext.fetch(fetchRequest)
            completion?(.success(events))
        } catch {
            completion?(.failure(error))
        }
    }
    
    func fetchUpcomingEvents(completion: ((Result<[NSManagedObject], Error>) -> Void)?) {
        if appDelegate == nil {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                completion?(.failure(StorageErrors.appDelegateNotFound))
                return
            }
            self.appDelegate = delegate
        }
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Events")
        fetchRequest.predicate = NSPredicate(format: "date > %@", NSDate())
        
        do {
            let events = try managedContext.fetch(fetchRequest)
            completion?(.success(events))
        } catch {
            completion?(.failure(error))
        }
    }
    
    func deleteEvent(with id: NSManagedObjectID, completion: ((Result<NSManagedObjectID, Error>) -> Void)?) {
        if appDelegate == nil {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                completion?(.failure(StorageErrors.appDelegateNotFound))
                return
            }
            self.appDelegate = delegate
        }
        let managedContext = appDelegate!.persistentContainer.viewContext
        do {
            let object = try managedContext.existingObject(with: id)
            managedContext.delete(object)
            do {
                try managedContext.save()
                completion?(.success(id))
            } catch {
                completion?(.failure(error))
            }
        } catch {
            completion?(.failure(StorageErrors.objectNotFound(id)))
        }
    }
    
}
