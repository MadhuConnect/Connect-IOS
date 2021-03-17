//
//  NotificationsCountResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct NotificationsCountResModel: Codable {
    let status: Bool
    let message: String?
    let quickNeedsCount: Int?
    let emergencyCounts: Int?
    
}


/*
{
    "status": true,
    "quickNeedsCount": 0,
    "emergencyCounts": 10
}
*/
