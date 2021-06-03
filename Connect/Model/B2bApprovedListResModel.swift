//
//  B2bApprovedListResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 21/05/21.
//  Copyright © 2021 Venkatesh Botla. All rights reserved.
//

import Foundation


struct B2bApprovedListResModel: Codable {
    let status: Bool
    let message: String?
    let isUpdating: Bool
    let data: [B2bApprovedModel]?
}

struct B2bApprovedModel: Codable {
    let requestId: Int?
    let banner: String?
    let name: String?
    let titleBanner: String?
    let description: String?
    let offer: String?
    let contactUs: String?
    let viewImages: [B2bViewImagesModel]?
}

struct B2bViewImagesModel: Codable {
    let image: String?
}

/*
 {
     "status": true,
     "message": "B2B Records",
     "data": [
         {
             "requestId": 2,
             "banner": "http://test.connectyourneed.in//uploads/business/b2b1.jpg",
             "name": "Laundry business",
             "titleBanner": "http://test.connectyourneed.in//uploads/business/b2b1.jpg",
             "description": "CONNECT YOUR NEED (CYN) ) information and technology solutions started operations in 2020 in the smart city of Visakhapatnam. We take all kind of IT services",
             "offer": "Get 20% off on overall billing. Use this coupon code : CYN0808",
             "contactUs": "Email: support@connectyourneed.in\r\nPhone No: +91 7013367849",
             "viewImages": [
                 {
                     "image": "http://test.connectyourneed.in//uploads/business/b2b1.jpg"
                 },
                 {
                     "image": "http://test.connectyourneed.in//uploads/business/b2b2.jpg"
                 }
             ]
         },
         {
             "requestId": 3,
             "banner": "http://test.connectyourneed.in//uploads/business/",
             "name": "Laundry business",
             "titleBanner": "http://test.connectyourneed.in//uploads/business/",
             "description": null,
             "offer": null,
             "contactUs": null,
             "viewImages": [
                 {
                     "image": "http://test.connectyourneed.in//uploads/business/b2b3.jpg"
                 },
                 {
                     "image": "http://test.connectyourneed.in//uploads/business/b2b4.jpg"
                 }
             ]
         }
     ],
     "isUpdating": false
 }
 */
