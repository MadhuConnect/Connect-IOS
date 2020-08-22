//
//  NotificationReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 22/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct NotificationReqModel: Codable {
    let userId: Int
    let qrId: Int
    let status: String
}
