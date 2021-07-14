//
//  AddEventViewModel.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import Foundation
import CoreData

protocol AddEventViewModelInput {
    func save()
    func updateData(name: String?, date: Date?)
}

protocol AddEventViewModelOutput {
    var title: String { get }
    var name: String { get }
    var date: Date { get }
    var didFinish: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
}

final class AddEventViewModel: AddEventViewModelOutput {
    
    private let service = StorageManager.shared
    
    var title: String = "Add event"
    var name: String = ""
    var date: Date = Date()
    
    var didFinish: (() -> Void)?
    var showError: ((String) -> Void)?
    
}

extension AddEventViewModel: AddEventViewModelInput {
    
    func save() {
        if name.isEmpty {
            self.showError?("Don't forget to set a name for your event!")
            return
        }
        guard let difference = self.date.differenceBetweenInSeconds(from: Date()) else {
            self.showError?("Something went wrong")
            return
        }
        if difference <= 0 {
            self.showError?("Your event cannot take place in the past")
            return
        }
        service.save(id: 0, name: self.name, date: self.date, completion: { result in
            self.didFinish?()
        })
    }
    
    func updateData(name: String? = nil, date: Date? = nil) {
        if let name = name {
            self.name = name
            print(self.name)
        }
        if let date = date {
            self.date = date
            print(self.date)
        }
    }
    
}
