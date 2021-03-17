//
//  KYCResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/02/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct KYCResModel: Codable {
    let status: Bool
    let message: String?
    let data: KYCStatus?
}

struct KYCStatus: Codable {
    let kyc: Bool
}
