//
//  OTPResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct OTPResModel: Codable {
    let status: Bool
    let message: String?
    let data: LoginInfo?
}

struct OTPInfo: Codable {
    let userId: Int
    let name: String
    let mobile: String
}

//{"status":true,"message":"Login Success","data":{"userId":1,"name":"Gana","mobile":"+919502244622"}}
