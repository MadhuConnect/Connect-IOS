//
//  LockedUsersResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/01/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct LockedUsersResModel: Codable {
    let status: Bool
    let message: String?
    let data: [LockedUserModel]?
}

struct LockedUserModel: Codable {
    let connectedUserId: Int?
    let name: String?
    let mobile: String?
    let kyc: Int?
    let personType: String?
    let product: String?
    let title: String?
    let description: String?
    let minAmount: Double?
    let maxAmount: Double?
    let connectedLocation: String?
    let distance: Double?
    let date: String?
    let time: String?
    let paymentStatus: Int?
    let paymentId: String?
}
