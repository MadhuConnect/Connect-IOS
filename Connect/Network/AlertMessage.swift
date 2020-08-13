//
//  AlertMessage.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

enum AlertMessage: String {
    case appTitle = "Alert"
    case errTitle = "Error"
    case successTitle = "Success"
    case emptyMobileNumber = "Please enter mobile number"
    case emptyPassword = "Please enter password"
    case validMobileNumber = "Please enter valid mobile number"
    case validPassword = "Please enter valid password"
    case emptyName = "Please enter your name"
    case emptyAddress = "Please enter your address"
    case emptyEmail = "Please enter your email id"
    case validName = "Please enter valid name"
    case validAddress = "Please enter valid address"
    case validEmail = "Please enter valid email id"
    case loginSuccess = "Login Success"
    case loginFail = "Login Fail"
    case signupSuccess = "Registration Success"
    case signupFail = "Registration Fail"
    case underDevelopment = "Coming Soon 🙏"
    
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
