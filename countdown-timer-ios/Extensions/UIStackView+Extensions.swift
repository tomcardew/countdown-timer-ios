//
//  UIStackView+Extensions.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import UIKit

extension UIStackView {
    
    func removeAll() {
        for item in self.arrangedSubviews {
            item.removeFromSuperview()
        }
    }
    
}
