//
//  SubcriptionResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 10/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct SubcriptionResModel: Codable {
    let status: Bool
    let message: String?
    let FreeOfCost: Bool?
    let data: [SubscriptionType]?
}

struct SubscriptionType: Codable {
    let salesTypeId: Int
    let salesType: String
    let prices: [Prices]?
}

struct Prices: Codable {
    let priceId: Int
    let price: Int
    let days: Int
}

//{
//    "status": true,
//    "FreeOfCost": true,
//    "data": [
//        {
//            "salesTypeId": 1,
//            "salesType": "Monthly Sales",
//            "prices": [
//                {
//                    "priceId": 1,
//                    "price": 1500,
//                    "days": 30
//                },
//                {
//                    "priceId": 2,
//                    "price": 2500,
//                    "days": 90
//                },
//                {
//                    "priceId": 3,
//                    "price": 3500,
//                    "days": 180
//                }
//            ]
//        }
//    ]
//}
