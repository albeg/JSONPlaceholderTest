//
//  UIViewController+Extension.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 23/02/2020.
//

import UIKit

extension UIViewController {
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
