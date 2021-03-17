//
//  BlockUserReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct BlockUserReqModel: Codable {
    let connectedUserId: Int
    let status: String
}
