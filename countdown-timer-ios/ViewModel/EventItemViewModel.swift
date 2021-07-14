//
//  EventItemViewModel.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import Foundation
import CoreData

protocol EventItemViewModelOutput {
    var objectId: NSManagedObjectID { get }
    var name: String { get }
    var date: Date { get }
    var remainingTime: String { get }
    var didUpdate: (() -> Void)? { get set }
    var didUpdateTimer: (() -> Void)? { get set }
    var didRemoveEvent: (() -> Void)? { get set }
}

protocol EventItemViewModelInput {
    func stopTimer()
    func removeItem()
}

final class EventItemViewModel: EventItemViewModelOutput {
    
    private var timer: Timer?
    private let service = StorageManager.shared
    
    var objectId: NSManagedObjectID
    var name: String
    var date: Date
    var remainingTime: String {
        self.date.calculateRemainingTime(to: Date())
    }
    
    var didUpdate: (() -> Void)?
    var didUpdateTimer: (() -> Void)?
    var didRemoveEvent: (() -> Void)?
    
    init(name: String, date: Date, id: NSManagedObjectID) {
        self.name = name
        self.date = date
        self.objectId = id
        
        initializeTimer()
    }
    
    private func initializeTimer() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.remainingTime == "00:00:00" {
                timer.invalidate()
            }
            self.didUpdateTimer?()
        })
        self.timer = timer
    }
    
}

extension EventItemViewModel: EventItemViewModelInput {

    func stopTimer() {
        guard let timer = self.timer else { return }
        timer.invalidate()
    }
    
    func removeItem() {
        self.didRemoveEvent?()
    }
    
}
