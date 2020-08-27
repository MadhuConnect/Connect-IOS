//
//  BlockedUsersResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct BlockedUsersResModel: Codable {
    let status: Bool
    let message: String?
    let data: [BlockedUsers]?
}

struct BlockedUsers: Codable {
    let blockedUserId: Int
    let name: String
    let mobile: String
}


//{
//    "status": true,
//    "data": [
//        {
//            "blockedUserId": 4,
//            "name": "Deepu",
//            "mobile": "+91800811"
//        }
//    ]
//}
