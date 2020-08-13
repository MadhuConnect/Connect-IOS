//
//  Apifeed.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 02/02/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

enum Apifeed: String {
    case allProducts = "/api/QuickNeeds/allProducts"
    case userLogin = "/api/QuickNeeds/userLogin"
    case userRegistration = "/api/QuickNeeds/userRegistration"
    case checkOtp = "/api/QuickNeeds/checkOtp"
    case uploadImage = "/api/Images_api/uploadImage"
    case subscriptionCharges = "/api/QuickNeeds/subscriptionCharges"
    case generateQrcode = "/api/QuickNeeds/generateQrcode"
    
    func getApiEndpoint(queryItems: [URLQueryItem] = [], httpMethod: HTTPMethod, headers: [HTTPHeader], body: Data? = Data(), timeInterval: TimeInterval) -> Endpoint {
        return Endpoint(path: self.rawValue, httpMethod: httpMethod, headers: headers, body: body, queryItems: queryItems, timeOut: timeInterval)
    }
}

