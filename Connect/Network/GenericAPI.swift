//
//  GenericAPI.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 31/01/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

protocol GenericAPI {
    var session: URLSession { get }
    func makeRequest<T: Codable>(with request: URLRequest, codable: @escaping (Codable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
}

extension GenericAPI {
    typealias JSONTaskCompletionHandler = (Codable?, APIError?) -> Void
    
    //MARK: - URLSessionDataTask
    private func codableTask<T: Codable>(with request: URLRequest, codableType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
//            print("HttpResponse code: \(httpResponse.statusCode)")
            
            if (200...209).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        print(try JSONSerialization.jsonObject(with: data, options: []))
                        let results = try JSONDecoder().decode(codableType, from: data)
                        completion(results, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .responseUnsuccessful)
                }
            } else {
                completion(nil, .errorCode("Error code: \(httpResponse.statusCode)"))
            }
        }
        return task
    }
    
    func makeRequest<T: Codable>(with request: URLRequest, codable: @escaping (Codable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = codableTask(with: request, codableType: T.self) { (json, error) in
            //Change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                
                if let value = codable(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonConversionFailure))
                }
            }
        }
        task.resume()
    }
    
}
