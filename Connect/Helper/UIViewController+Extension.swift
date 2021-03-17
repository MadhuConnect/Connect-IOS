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

extension UITableViewCell {
    func getDateSpecificFormat(_ date: String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let genDate = dateFormatter.date(from: date) ?? Date()
         dateFormatter.dateFormat = "dd-MMM-yyyy"
         
         var daystr = dateFormatter.string(from: genDate)
         if daystr.count == 10 {
             daystr = "0"+daystr
         }
         
         return daystr
     }
    
    func getDateSpecificFormatForEmergency(_ date: String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let genDate = dateFormatter.date(from: date) ?? Date()
         dateFormatter.dateFormat = "dd MMM yy"
         
         var daystr = dateFormatter.string(from: genDate)
         if daystr.count == 10 {
             daystr = "0"+daystr
         }
         
         return daystr
     }
     
     func getDay(_ date: String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let genDate = dateFormatter.date(from: date) ?? Date()
         
         let components = Calendar.current.dateComponents([.day], from: genDate)
         var daystr = "\(components.day ?? 0)"
         if daystr.count == 1 {
             daystr = "0"+daystr
         }
         return daystr
     }
     
     func getMonthYear(_ date: String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         
         let genDate = dateFormatter.date(from: date) ?? Date()
         dateFormatter.dateFormat = "MMM-yyyy"
         
         return dateFormatter.string(from: genDate)
     }
    
    func getMonth_Year(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let genDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM yy"
        
        return dateFormatter.string(from: genDate)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func getLast4DigitFromPhoneNumber(_ phone: String) -> String {
        let last4 = (phone as NSString).substring(from: max(phone.count-4,0))
        let res = String(format: "xxxxxx%@",last4 as CVarArg)
        return res
    }
    
}
