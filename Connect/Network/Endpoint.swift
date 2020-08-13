//
//  Endpoint.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 02/02/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

//public typealias HTTPHeaders = [String: String]

public struct Endpoint {
    var path: String
    var httpMethod: HTTPMethod
    var headers: [HTTPHeader]
    var body: Data?
    var queryItems: [URLQueryItem]?
    var timeOut: TimeInterval
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        let base: String = "http://connectyourneed.in"
        var component = URLComponents(string: base)!
        component.path = path
        component.queryItems = queryItems
        return component
    }
    
    var request: URLRequest {
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        request.timeoutInterval = timeOut
        
        headers.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field)}
        
        request.httpShouldHandleCookies = true
        return request
    }
}





























