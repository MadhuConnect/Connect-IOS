//
//  NotificationResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 22/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct NotificationResModel: Codable {
    let status: Bool
    let message: String?
    let data: [NotificationModel]?
}

struct NotificationModel: Codable {
    let personType: String
    let connectedUserId: Int
    let name: String
    let mobile: String
    let product: String
    let description: String
    let minAmount: Int
    let maxAmount: Int
    let connectedLocation: String
    let distance: Double
    let date: String
    let time: String
}


/*
 {
     "status": true,
     "data": [
         {
             "personType": "SEEKER",
             "connectedUserId": 3,
             "name": "Naga",
             "mobile": "+91986609050",
             "product": "All brands",
             "description": "test",
             "minAmount": 0,
             "maxAmount": 2000,
             "connectedLocation": "Marripalem ",
             "distance": 0.65953981918206,
             "date": "2020-08-21",
             "time": "03:59 PM"
         },
         {
             "personType": "SEEKER",
             "connectedUserId": 2,
             "name": "Sasi",
             "mobile": "+91994948766",
             "product": "All brands",
             "description": "test",
             "minAmount": 0,
             "maxAmount": 2000,
             "connectedLocation": "Gopalapatnam",
             "distance": 1.7833734683799,
             "date": "2020-08-21",
             "time": "03:59 PM"
         },
         {
             "personType": "SEEKER",
             "connectedUserId": 4,
             "name": "Deepu",
             "mobile": "+91800811",
             "product": "All brands",
             "description": "test",
             "minAmount": 0,
             "maxAmount": 2000,
             "connectedLocation": "Gurudwar",
             "distance": 6.8267263381166,
             "date": "2020-08-21",
             "time": "03:59 PM"
         }
     ]
 }
 */
