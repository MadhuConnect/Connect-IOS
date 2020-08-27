//
//  FormResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 10/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct FormResModel: Codable {
    let status: Bool
    let message: String?
    let data: QRInfoModel?
}

struct QRInfoModel: Codable {
    let qrId: Int
    let qrCode: String
    let personType: String
    let productName: String
    let productImage: String
    let productType: String
    let description: String
    let minAmount: Int
    let maxAmount: Int
    let privacyStatus: String
    let connectRange: String
    let activeCount: Int
    let lockCount: Int
    let chatCount: Int
    let qrStatus: String
    let qrGeneratedDate: String
    let expireDate: String
    let turnOn: Bool
    let images: [QRImageModel]?
}

struct QRImageModel: Codable {
    let name: String
    let productImage: String
}

/*
 
 {
     "status": true,
     "data": {
         "qrId": 11,
         "qrCode": "MUBORVdAQFFyY29kZS1jb25uZWN0",
         "personType": "OFFEROR",
         "productName": "All brands",
         "productImage": "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/mobile.png",
         "productType": "NEW",
         "description": "test",
         "minAmount": 0,
         "maxAmount": 2000,
         "privacyStatus": "All",
         "connectRange": "8 Km",
         "activeCount": 0,
         "lockCount": 0,
         "chatCount": 0,
         "qrStatus": "Active",
         "qrGeneratedDate": "2020-08-21",
         "expireDate": "2020-09-20",
         "turnOn": true,
         "images": [
             {
                 "name": "54c5ee7bc85fbc744dd39885d4485d2a1597766936",
                 "productImage": "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/product_images/54c5ee7bc85fbc744dd39885d4485d2a1597766936"
             },
             {
                 "name": "54c5ee7bc85fbc744dd39885d4485d2a1597765744",
                 "productImage": "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/product_images/54c5ee7bc85fbc744dd39885d4485d2a1597765744"
             }
         ]
     }
 }
 
 */
