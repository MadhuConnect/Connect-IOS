//
//  OrdersResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 13/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct OrdersResModel: Codable {
    let status: Bool
    let message: String?
    let data: [QRInfoModel]?
}


/*
{
"status": true,
"data": [
    {
        "qrId": 33,
        "qrCode": "MUBOZXdAQFFyY29kZS1jb25uZWN0",
        "personType": "OFFEROR",
        "productName": "All brands",
        "productImage": "http://connectyourneed.in/uploads/products/mobile.png",
        "productType": "New",
        "description": "Test desc",
        "minAmount": 100,
        "maxAmount": 1000,
        "privacyStatus": "All",
        "connectRange": "8 Km",
        "activeCount": 0,
        "lockCount": 0,
        "chatCount": 0,
        "qrStatus": "Active",
        "qrGeneratedDate": "2020-08-10",
        "expireDate": "2020-09-09",
        "turnOn": true,
        "images": [
            {
                "name": "006070ED-CD26-43D3-8DAF-289CF1EBB713.jpeg",
                "productImage": "http://connectyourneed.in/uploads/product_images/006070ED-CD26-43D3-8DAF-289CF1EBB713.jpeg"
            },
            {
                "name": "526FE694-7FD0-4C9D-AB26-C80A246A177F.jpeg",
                "productImage": "http://connectyourneed.in/uploads/product_images/526FE694-7FD0-4C9D-AB26-C80A246A177F.jpeg"
            },
            {
                "name": "6EA78BE2-78D9-45C6-A0D0-1D5468F78819.jpeg",
                "productImage": "http://connectyourneed.in/uploads/product_images/6EA78BE2-78D9-45C6-A0D0-1D5468F78819.jpeg"
            }
        ]
    }
]
 */
