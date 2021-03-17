//
//  EmergencyNotificationsResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/11/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct EmergencyNotificationsResModel: Codable {
    let status: Bool
    let message: String?
    let data: [EmergencyNotifications]?
}

struct EmergencyNotifications: Codable {
    let connectedUserId: Int
    let emergencyTypeId: Int
    let name: String
    let mobile: String
    let type: String
    let requestGeneratedDate: String
    let message: String
    let connectedLocation: String
    let distance: Double
    let connectedDate: String
    let connectedTime: String
    let emergencyType: String
}
