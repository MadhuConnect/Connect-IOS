//
//  DeleteOrderReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 03/11/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct DeleteOrderReqModel: Codable {
    let requestId: Int
    let status: String //status = Quickneeds/Emergency
}
