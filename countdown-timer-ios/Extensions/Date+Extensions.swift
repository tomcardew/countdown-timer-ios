//
//  Date+Extensions.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import Foundation

extension Date {
    
    func toString(with format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func differenceBetweenInSeconds(from date: Date) -> Int? {
        let diffComponents = Calendar.current.dateComponents([.second], from: date, to: self)
        return diffComponents.second
    }
    
    func calculateRemainingTime(to date: Date) -> String {
        let seconds = differenceBetweenInSeconds(from: date)!
        
        if seconds <= 0 {
            return "00:00:00"
        }
        
        var hours = "\(seconds / 3600)"
        if hours.count < 2 {
            hours = hours.padding(rightTo: 2, withPad: "0", startingAt: 0)
        }
        let minutes = "\((seconds % 3600) / 60)".padding(leftTo: 2, withPad: "0", startingAt: 0)
        let secs = "\(((seconds % 3600) % 60))".padding(leftTo: 2, withPad: "0", startingAt: 0)
        return "\(hours):\(minutes):\(secs)"
    }
    
}
