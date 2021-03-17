//
//  CheckOtpReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/03/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct CheckOtpReqModel: Codable {
    let mobile: String
    let otp: String
}
