//
//  EmergencyResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct EmergencyResModel: Codable {
    let status: Bool
    let message: String?
    let data: EmergencyInfo?
}

struct EmergencyInfo: Codable {
    let emergencyType: String
    let type: String?
}

/*
{
    data =     {
        emergencyType = Blood;
        type = "O+";
    };
    message = "Your Emergency Request Posted Successfully";
    status = 1;
}
*/
