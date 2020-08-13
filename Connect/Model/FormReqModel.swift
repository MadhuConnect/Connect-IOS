//
//  FormReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 10/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct FormReqModel: Codable {
    let userId: Int
    let productId: Int
    let personType: String
    let productType: String
    let uploadImages: String?
    let description: String
    let minAmount: Int
    let maxAmount: Int
    let privacyStatus: String
    let connectRange: String
    let salesTypeId: Int
    let priceId: Int
}

//{"userId":1,"productId":1,"personType":"OFFEROR","productType":"NEW","uploadImages":"B3E681BC-712D-45E3-9709-72C812903F35.jpeg,859EC35F-64BB-49D1-BBE7-AC9161EFF77C.jpeg","description":"test1","minAmount":1000,"maxAmount":2000,"privacyStatus":"All","connectRange":"5km","salesTypeId":1,"priceId":0}
