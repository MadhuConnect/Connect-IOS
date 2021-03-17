//
//  EmergencyLockStatusReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/11/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct EmergencyLockStatusReqModel: Codable {
    let connectedUserId: Int
    let emergencyTypeId: Int
    let status: String
}
