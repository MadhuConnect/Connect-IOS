//
//  ConnectChargesResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 08/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct ConnectChargesResModel: Codable {
    let status: Bool
    let message: String?
    let data: [Charges]?
}

struct Charges: Codable {
    let id: Int?
    let connects: Int?
    let percentage: Int?
    let price: Int?
    let status: String?
}


/*
 
 
 {
 "status":true,
 "data":[
        {
            "id":1,
            "connects":1,
            "percentage":0,
            "price":20,
            "status":"Active"
        },{
            "id":2,
            "connects":5,
            "percentage":10,
            "price":20,
            "status":"Active"
        }
    ]

 }
 
 */
