//
//  LockUnLockReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 22/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct LockUnLockReqModel: Codable {
    let userId: Int
    let qrId: Int
    let connectedUserId: Int
    let status: String
}
