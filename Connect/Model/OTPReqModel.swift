//
//  OTPReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct OTPReqModel: Codable {
    let mobile: String
    let otp: String
    let token: String
    let type: String
}

//{"mobile":"+919502244622","otp":737705,"token":"TYEU7585","type":"Registration"}
