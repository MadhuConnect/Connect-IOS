//
//  ImageResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct ImageResModel: Codable {
    let status: Bool
    let message: String?
    let userId: Int?
    let imageId: Int?
    let name: String?
    let imageUrl: String?
}

//{"status":true,"userId":1,"imageId":4,"name":"a814f2c44b811341f6e8ce4dc2ca8aa3.jpg","imageUrl":"http://connectyourneed.in/uploads/product_images/a814f2c44b811341f6e8ce4dc2ca8aa3.jpg"}
