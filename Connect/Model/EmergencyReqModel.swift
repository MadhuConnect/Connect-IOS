//
//  EmergencyReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct EmergencyReqModel: Codable {
    let emergecnyTypeId: Int
    let type: String?
    let message: String
}

//{"emergecnyTypeId":2,"type":"O-","message":"Need O- Blood"}
