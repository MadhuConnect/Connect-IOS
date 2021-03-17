//
//  SendConnectedUsers.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct SendConnectedUsersReqModel: Codable {
    let qrId: Int?
    let connectedUserId: String?
    let amount: Int?
}

//{
//    "qrId": 12,
//    "connectedUserId": "12",
//    "amount": 1
//}

struct SendConnectedUsersResModel: Codable {
    let status: Bool
    let message: String?
    let url: String?
}

//{"status": true,"url": "http://test.connectyourneed.in/QR-Payment/4/12/3/1"}
