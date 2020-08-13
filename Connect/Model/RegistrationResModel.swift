//
//  RegistrationResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct RegistrationResModel: Codable {
    let status: Bool
    let message: String?
    let mobile: String?
}


//{"status":true,"mobile":"+919502244622","message":"Registration Otp Is Sent To +919502244622 Mobile Number "}
