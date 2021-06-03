//
//  AdPremiumPlanResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 20/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct AdPremiumPlanResModel: Codable {
    let status: Bool
    let message: String?
    let b2bImg: String?
    let isUpdating: Bool
    let data: [PremiumPlan]?
}

struct PremiumPlan: Codable {
    let subscriptionId: Int
    let subscriptionPrice: String
    let subscriptionDiscount: String
    let validity: String
}

/*
 {
     "status": true,
     "message": "subscription plans",
     "b2bImg": "http://test.connectyourneed.in//uploads/logo/cyn.png",
     "data": [
         {
             "subscriptionId": 1,
             "subscriptionPrice": "Rs 99/-",
             "subscriptionDiscount": "Rs 500/-",
             "validity": "7 Days Validity"
         },
         {
             "subscriptionId": 2,
             "subscriptionPrice": "Rs 349/-",
             "subscriptionDiscount": "Rs 500/-",
             "validity": "1 Month Validity"
         },
         {
             "subscriptionId": 3,
             "subscriptionPrice": "Rs 899/-",
             "subscriptionDiscount": "Rs 1000/-",
             "validity": "3 Months Validity"
         },
         {
             "subscriptionId": 4,
             "subscriptionPrice": "Rs 1499/-",
             "subscriptionDiscount": "Rs 1800/-",
             "validity": "6 Months Validity"
         },
         {
             "subscriptionId": 5,
             "subscriptionPrice": "Rs 2499/-",
             "subscriptionDiscount": "Rs 3000/-",
             "validity": "12 Months Validity"
         }
     ],
     "isUpdating": false
 }
 */
