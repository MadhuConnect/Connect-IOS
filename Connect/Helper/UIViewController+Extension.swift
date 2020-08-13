//
//  UIViewController+Extension.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

/*
Examples: you can use any ViewController class:

Normat function for alert
-------------------------
self.showAlertMini(title: "VIPvisitor", message: "Enter country code to proceed.", actionTitle: "Ok")

All functions for alert
----------------------
self.showMyAlert(title: "VIPvisitor", message: "Enter country code to proceed.", actionTitles: ["Ok", "Cancel"], actionStyle: [.default, .cancel], action: [
{ ok in
print("Ok selected.")
}, { cacel in
print("Cancel selected")
}
])



*/

extension UIViewController {
    // This alert function contains only one alert action style i.e. "OK" function.
    /// Default Alert
    /// - Display a simple alert
    func showAlertMini(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
            print("you have got a alert message")
        }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // This alert function include all alert actions styles.
    /// Handle user actions
    /// - Diplay alert actions like user may 'Cancel' or 'Agree'
    func showAlertMax(title: String, message: String, actionTitles: [String], actionStyle:[UIAlertAction.Style], action:[((UIAlertAction) -> Void)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: action[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hiding the keyboad when user clicks outside the textfeild
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
