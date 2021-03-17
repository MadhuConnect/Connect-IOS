//
//  QRPaymentResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 10/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation


struct QRPaymentResModel: Codable {
    let status: Bool
    let message: String?
    let url: String?
}


//        {
//            "status": true,
//            "url": "http://test.connectyourneed.in/QR-Payment/4/12/5/1"
//        }
