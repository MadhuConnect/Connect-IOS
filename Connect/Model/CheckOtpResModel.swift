//
//  CheckOtpResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/03/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct CheckOtpResModel: Codable {
    let status: Bool
    let isUpdating: Bool
    let message: String?
    let url: String?
}

//{"status": true,"message": "success","url": "http://test.connectyourneed.in/KYC-Payment/28/99","isUpdating": false}
