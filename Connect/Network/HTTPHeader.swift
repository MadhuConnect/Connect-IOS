//
//  HTTPHeader.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 02/02/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

enum HTTPHeader {
    case contentType(String)
    case accept(String)
    case authorization(String)
//    case userIdentification(String)
    
    var header: (field: String, value: String) {
        switch self {
        case .contentType(let value): return (field: "Content-Type", value: value)
        case .accept(let value): return (field: "Accept", value: value)
        case .authorization(let value): return (field: "Authorization", value: value)
//        case .userIdentification(let value): return (field: "userId", value: value)
        }
    }
}
