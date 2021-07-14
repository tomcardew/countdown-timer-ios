//
//  MainViewModel.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import Foundation
import CoreData

protocol MainViewModelInput {
    func viewDidLoad()
    func addEvent(id: Int, name: String, date: Date)
    func reorderEvents()
    func deleteEvent(id: NSManagedObjectID)
}

protocol MainViewModelOutput {
    var title: String { get }
    var loading: Bool { get }
    var events: [NSManagedObject] { get }
    var error: String { get }
    var eventsDidChange: (() -> Void)? { get set }
    var loadingDidChange: (() -> Void)? { get set }
    var errorDidChange: (() -> Void)? { get set }
    var deletionDidSucceed: (() -> Void)? { get set }
}

final class MainViewModel: MainViewModelOutput {
    
    let storage = StorageManager.shared
    
    var title: String = "My events"
    var loading: Bool = false {
        didSet {
            self.loadingDidChange?()
        }
    }
    var events: [NSManagedObject] = [] {
        didSet {
            self.eventsDidChange?()
        }
    }
    var error: String = "" {
        didSet {
            self.errorDidChange?()
        }
    }
    
    // binding handlers
    var eventsDidChange: (() -> Void)?
    var loadingDidChange: (() -> Void)?
    var errorDidChange: (() -> Void)?
    var deletionDidSucceed: (() -> Void)?
    
}

extension MainViewModel: MainViewModelInput {
    
    func viewDidLoad() {
        // should fetch all events
        storage.fetchAll(completion: { result in
            switch result {
            case .success(let data):
                self.events = data
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func addEvent(id: Int, name: String, date: Date) {
        self.loading = true
        storage.save(id: id, name: name, date: date, completion: { result in
            switch result {
            case .success(_):
                self.loading = false
                break
            case .failure(let error):
                self.error = error.localizedDescription
                self.loading = false
            }
        })
    }
    
    func reorderEvents() {
        var newEvents: [NSManagedObject] = []
        for event in self.events {
            if let date = event.value(forKey: "date") as? Date {
                if date.differenceBetweenInSeconds(from: Date())! >= 0 {
                    newEvents.append(event)
                }
            }
        }
        self.events = newEvents
    }
    
    func deleteEvent(id: NSManagedObjectID) {
        storage.deleteEvent(with: id, completion: { result in
            switch(result) {
            case .success(_):
                self.viewDidLoad()
            case .failure(let error):
                self.error = "Couldn't delete item with id: \(error)"
            }
        })
    }
    
    
}
