//
//  Extensions.swift
//  Askify
//
//  Created by Katherine Reinhart on 2/20/18.
//  Copyright © 2018 reinhart.digital. All rights reserved.
//

import Foundation
import UIKit

// Hide keyboard when tap outside of it
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
