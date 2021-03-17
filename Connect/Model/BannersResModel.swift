//
//  BannersResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/02/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation

struct BannersResModel: Codable {
    let status: Bool
    let message: String?
    let data: [Banners]?
    let isUpdating: Bool
}

struct Banners: Codable {
    let id: Int?
    let isVisible: Bool?
    let description: String?
    let title: String?
    let videoId: String?
    let image: String?
}

/*
 
 {
     data =     (
                 {
             description = description1;
             id = 1;
             image = "https://connectyourneed.s3.ap-south-1.amazonaws.com/production/uploads/banners/homeScreen.png";
             isVisible = 1;
             title = title1;
             videoId = "<null>";
         },
                 {
             description = "youtube.com/watch?v=_xHK5r4gqPI";
             id = 2;
             image = "https://connectyourneed.s3.ap-south-1.amazonaws.com/production/uploads/banners/demoScreen.png";
             isVisible = 1;
             title = title2;
             videoId = "_xHK5r4gqPI";
         }
     );
     isUpdating = 0;
     message = "Banners List";
     status = 1;
 }
 
 */
