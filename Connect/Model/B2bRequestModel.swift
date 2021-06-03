//
//  B2bRequestModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 21/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct B2bRequestModel: Codable {
    let qrId: Int?
    let requirement: String?
    let mobile: String?
    let email: String?
    let subscriptionId: Int?
    
}

//Request
/*
 {
    "qrId":60,
    "requirement":"Oppo Mobiles",
    "mobile":9121089404,
    "email":"botlavenkatesh@gmail.com",
    "subscriptionId":1}
 */

//Response
/*
 {
     "status": true,
     "message": "success",
     "isUpdating": false
 }
 */
