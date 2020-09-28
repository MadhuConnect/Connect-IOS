//
//  ContactUsReqFormModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct ContactUsReqFormModel: Codable {
    let form: String
    let formRequest: FormRequestModel?
}

struct FormRequestModel: Codable {
    let product: String?
    let category: String?
    let description: String?
    let images: String?
}

/*
{
    "form":"Request",
    "formRequest":
        {
            "product":"apple",
            "category":"Mobiles",
            "description":"Apple Need",
            "images":"67bde149659ed83e541877917c37be0f1600085407,67bde149659ed83e541877917c37be0f1600085407"
    }
}
*/
