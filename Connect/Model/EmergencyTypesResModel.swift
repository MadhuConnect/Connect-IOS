//
//  EmergencyTypesResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 25/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct EmergencyTypesResModel: Codable {
    let status: Bool
    let message: String?
    let data: [EmergencyModel]?
}

struct EmergencyModel: Codable {
    let emergecnyTypeId: Int
    let emergencyType: String
    let image: String?
    let title: String
    let types: [EmergencyTypes]?
}

struct EmergencyTypes: Codable {
    let type: String
}

/*
{
    data =     (
                {
            emergecnyTypeId = 1;
            emergencyType = Blood;
            image = "<null>";
            title = "Reach The Public Around You";
            types =             (
                                {
                    type = "A+";
                },
                                {
                    type = "A-";
                },
                                {
                    type = "O+";
                },
                                {
                    type = "O-";
                }
            );
        },
                {
            emergecnyTypeId = 2;
            emergencyType = Plasma;
            image = "<null>";
            title = "Reach Your Public Around You";
            types =             (
                                {
                    type = "A+";
                },
                                {
                    type = "AB+";
                }
            );
        }
    );
    status = 1;
    userInterestsCount = 0;
    userPostsCount = 0;
}
*/
