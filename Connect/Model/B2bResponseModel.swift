//
//  B2bResponseModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 21/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct B2bResponseModel: Codable {
    let status: Bool
    let message: String?
    let isUpdating: Bool
}
