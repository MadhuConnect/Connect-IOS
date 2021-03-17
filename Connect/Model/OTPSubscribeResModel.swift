//
//  OTPSubscribeResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/03/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct OTPSubscribeResModel: Codable {
    let status: Bool
    let mobile: String?
    let message: String?
}


//    " { "status": true, "mobile": "+919502244622","message": "kyc Otp Is Sent To +919502244622 Mobile Number"
//    }"
