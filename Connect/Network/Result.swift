//
//  Result.swift
//  GlobalNetworkService
//
//  Created by Venkatesh Botla on 02/02/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

enum Result<T, E> where E: Error {
    case success(T)
    case failure(E)
}
