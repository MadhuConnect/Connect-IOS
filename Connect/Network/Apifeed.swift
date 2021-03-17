//
//  Apifeed.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 02/02/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

enum DynamicBaseUrl: String {
//    case baseUrl = "http://ios.connectyourneed.in" // DEV
    case baseUrl = "http://ipro.connectyourneed.in" //PROD
//        case baseUrl = "http://test.connectyourneed.in" // DEV
//    http://ipro.connectyourneed.in/api/QuickNeeds/userRegistration
//    http://test.connectyourneed.in/api/QuickNeeds/getBanners
}

enum Apifeed: String {
    case userRegistration = "/api/QuickNeeds/userRegistration"
    case checkOtp = "/api/QuickNeeds/checkOtp"
    case forgetPassword = "/api/QuickNeeds/forgetPassword"
    case userLogin = "/api/QuickNeeds/userLogin"
    case updateCoordinates = "/api/QuickNeeds/updateCoordinates"
    
    case resetPassword = "/api/QuickNeeds/resetPassword"
    case updateProfilePic = "/api/QuickNeeds/updateProfilePic"
    case updateProfileData = "/api/QuickNeeds/updateProfileData"
    
    case allProducts = "/api/QuickNeeds/allProducts"
    case generateQrcode = "/api/QuickNeeds/generateQrcode"
    
    case updateQRcode = "/api/QuickNeeds/updateQRcode"
    case removeImage = "/api/QuickNeeds/removeImage"
    
    case myOrders = "/api/QuickNeeds/myOrders"
    case deleteOrder = "/api/QuickNeeds/deleteOrder"
    
    case notifications = "/api/QuickNeeds/notifications"
    case notificationsStatus = "/api/QuickNeeds/notificationsStatus"
    case notificationsCounts = "/api/QuickNeeds/NotificationsCounts"
    case paidConnections = "/api/QuickNeeds/paidConnections"

    case connectCharges = "/api/QuickNeeds/connectCharges"
    case sendConnectedPersons = "/api/QuickNeeds/sendConnectedPersons"
    case lockUsers = "/api/QuickNeeds/lockUsers"
    case blockUsers = "/api/QuickNeeds/blockUsers"
    
    case blockUsersList = "/api/QuickNeeds/blockUsersList"

    case contactUsForm = "/api/QuickNeeds/contactUsForm"
    
    case emergencyTypes = "/api/Emergency/emergencyTypes"
    case emergencyRequest = "/api/Emergency/emergencyRequest"
    case emergencyNotificationsCount = "/api/Emergency/emergencyNotificationsCount"
    case emergencyNotifications = "/api/Emergency/emergencyNotifications"
    case emergencyLockStatus = "/api/Emergency/emergencyLockStatus"
    case emergencyPostUpdate = "/api/Emergency/emergencyPostUpdate"
    case emergencyRemovepost = "/api/Emergency/emergencyRemovepost"
    
    case autoUpdate = "/api/QuickNeeds/autoUpdate"
    
    case getBanners = "/api/QuickNeeds/getBanners"
    case kycSendOtp = "/api/QuickNeeds/kycSendOtp"
    case kycCheckOtp = "/api/QuickNeeds/kycCheckOtp"
    case getKycStatus = "/api/QuickNeeds/getKycStatus"
        
    func getApiEndpoint(queryItems: [URLQueryItem] = [], httpMethod: HTTPMethod, headers: [HTTPHeader], body: Data? = Data(), timeInterval: TimeInterval) -> Endpoint {
        return Endpoint(path: self.rawValue, httpMethod: httpMethod, headers: headers, body: body, queryItems: queryItems, timeOut: timeInterval)
    }
}

