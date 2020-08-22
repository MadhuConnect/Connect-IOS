//
//  APIClient.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 02/02/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

class APIClient: GenericAPI {
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
}

//MARL: - ALL API Requests
extension APIClient {
    
    //Post user for login
    func post_loginUser(from endpoint: Endpoint, completion: @escaping (Result<LoginResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> LoginResModel? in
            guard let result = json as? LoginResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Post user details for registration
    func post_registerUser(from endpoint: Endpoint, completion: @escaping (Result<RegistrationResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> RegistrationResModel? in
            guard let result = json as? RegistrationResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Check user's received otp
    func post_checkReceivedOTP(from endpoint: Endpoint, completion: @escaping (Result<OTPResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> OTPResModel? in
            guard let result = json as? OTPResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    //Get All Catregories
    func getAllCategories(from endpoint: Endpoint, completion: @escaping (Result<CategoryModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> CategoryModel? in
            guard let result = json as? CategoryModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Subscription charges
    func post_getSubscriptionCharges(from endpoint: Endpoint, completion: @escaping (Result<SubcriptionResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> SubcriptionResModel? in
            guard let result = json as? SubcriptionResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Upload images
    func post_uploadImage(from endpoint: Endpoint, completion: @escaping (Result<ImageResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> ImageResModel? in
            guard let result = json as? ImageResModel else { return nil }
             return result
        }, completion: completion)
    }

    // Remove images
    func post_removeImage(from endpoint: Endpoint, completion: @escaping (Result<ImageResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> ImageResModel? in
            guard let result = json as? ImageResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Post form data
    func post_getFormFillingData(from endpoint: Endpoint, completion: @escaping (Result<FormResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> FormResModel? in
            guard let result = json as? FormResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Post and get my orders
    func post_getMyOrders(from endpoint: Endpoint, completion: @escaping (Result<OrdersResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> OrdersResModel? in
            guard let result = json as? OrdersResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Post and get my orders
    func post_getOrderNotifications(from endpoint: Endpoint, completion: @escaping (Result<NotificationResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> NotificationResModel? in
            guard let result = json as? NotificationResModel else { return nil }
             return result
        }, completion: completion)
    }
    
    // Post lock/unlock/block/unblock user
    func post_lockUnLockUserNotifications(from endpoint: Endpoint, completion: @escaping (Result<LockUnLockResModel?, APIError>) -> Void) {
        let request = endpoint.request

        makeRequest(with: request, codable: { (json) -> LockUnLockResModel? in
            guard let result = json as? LockUnLockResModel else { return nil }
             return result
        }, completion: completion)
    }
}





















