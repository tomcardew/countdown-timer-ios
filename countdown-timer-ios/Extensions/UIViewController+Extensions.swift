//
//  UIViewController+Extensions.swift
//  countdown-timer-ios
//
//  Created by Admin on 14/07/21.
//

import UIKit

extension UIViewController {
    
    func showSystemAlert(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions == nil {
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        } else {
            for action in actions! {
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}
