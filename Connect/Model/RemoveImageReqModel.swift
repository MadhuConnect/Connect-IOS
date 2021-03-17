//
//  RemoveImageReqModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 01/01/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct RemoveImageReqModel: Codable {
    let imageId: Int?
    let image: String?
    let status: String?
}
