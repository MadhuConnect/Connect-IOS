//
//  VBValidatiors.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

public class VBValidatiors {
    public static func validateMobile(_ text: String) -> Bool {
        let regex = "[0-9+]{10,14}" // PhoneNo 10-14 Digits
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format:"SELF MATCHES %@", regex)
        return validate.evaluate(with: trimmedText)
    }
    
    public static func validatePassword(_ text: String) -> Bool {
        let regex = "^.{6,30}$" // Password length 4-30
        //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
//        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,20}"
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format:"SELF MATCHES %@", regex)
        return validate.evaluate(with: trimmedText)
    }
    
    public static func validateName(_ text: String) -> Bool {
        let regex = "^[A-Za-z ]{4,50}" // Password length 4-50
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format:"SELF MATCHES %@", regex)
        return validate.evaluate(with: trimmedText)
    }
    
    public static func validateOTP(_ text: String) -> Bool {
        let regex = "[0-9]" // Password length 4-15
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        let validate = NSPredicate(format:"SELF MATCHES %@", regex)
        return validate.evaluate(with: trimmedText)
    }
}
//
