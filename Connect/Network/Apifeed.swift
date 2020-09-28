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
    case myOrders = "/api/QuickNeeds/myOrders"
    case updateProfile = "/api/QuickNeeds/updateProfile"
    case notifications = "/api/QuickNeeds/notifications"
    case lockUsers = "/api/QuickNeeds/lockUsers"
    case blockUsers = "/api/QuickNeeds/blockUsers"
    case blockUsersList = "/api/QuickNeeds/blockUsersList"
    case updateCoordinates = "/api/QuickNeeds/updateCoordinates"
    case resetPassword = "/api/QuickNeeds/resetPassword"
    case forgetPassword = "/api/QuickNeeds/forgetPassword"
    case emergencyTypes = "/api/Emergency/emergencyTypes"
    case emergencyRequest = "/api/Emergency/emergencyRequest"
    case updateProfilePic = "/api/QuickNeeds/updateProfilePic"
    case updateProfileData = "/api/QuickNeeds/updateProfileData"
        
    func getApiEndpoint(queryItems: [URLQueryItem] = [], httpMethod: HTTPMethod, headers: [HTTPHeader], body: Data? = Data(), timeInterval: TimeInterval) -> Endpoint {
        return Endpoint(path: self.rawValue, httpMethod: httpMethod, headers: headers, body: body, queryItems: queryItems, timeOut: timeInterval)
    }
}

