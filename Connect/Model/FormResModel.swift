//
//  FormResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 10/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct FormResModel: Codable {
    let status: Bool
    let message: String?
    let data: [QRInfoModel]?
}

struct QRInfoModel: Codable {
    let qrId: Int
    let qrCode: String
    let personType: String
    let productName: String
    let productImage: String
    let productType: String
    let description: String
    let minAmount: Int
    let maxAmount: Int
    let privacyStatus: String
    let connectRange: String
    let activeCount: Int
    let lockCount: Int
    let chatCount: Int
    let qrStatus: String
    let qrGeneratedDate: String
    let expireDate: String
    let turnOn: Bool
    let images: [QRImageModel]?
}

struct QRImageModel: Codable {
    let name: String
    let productImage: String
}

//{
//    data =     {
//        activeCount = 0;
//        chatCount = 0;
//        connectRange = "6 Km";
//        description = "Test desc";
//        expireDate = "2020-11-08";
//        images =         (
//                        {
//                name = "7B578949-DE43-43CF-BD24-04A74B9F802F.jpeg";
//                productImage = "http://connectyourneed.in/uploads/product_images/7B578949-DE43-43CF-BD24-04A74B9F802F.jpeg";
//            },
//                        {
//                name = "9A8111D9-26F6-4410-ADFE-BE49F706A3DA.jpeg";
//                productImage = "http://connectyourneed.in/uploads/product_images/9A8111D9-26F6-4410-ADFE-BE49F706A3DA.jpeg";
//            }
//        );
//        lockCount = 0;
//        maxAmount = 1500;
//        minAmount = 100;
//        personType = SEEKER;
//        privacyStatus = All;
//        productImage = "http://connectyourneed.in/uploads/products/3-mobiles-apple.png";
//        productName = Apple;
//        productType = New;
//        qrCode = "ODVATmV3QEBRcmNvZGUtY29ubmVjdA==";
//        qrGeneratedDate = "2020-08-10";
//        qrId = 34;
//        qrStatus = Active;
//        turnOn = 1;
//    };
//    status = 1;
//}

//{"status":true,"data":{"qrId":21,"qrCode":"M0BORVdAQFFyY29kZS1jb25uZWN0","personType":"OFFEROR","productName":"AC Repair","productImage":"http:\/\/connectyourneed.in\/uploads\/products\/air-conditioner.png","productType":"NEW","description":"test1","minAmount":0,"maxAmount":2000,"privacyStatus":"All","connectRange":"5 Km","activeCount":0,"lockCount":0,"chatCount":0,"qrStatus":"Active","qrGeneratedDate":"2020-08-08","expireDate":"2020-09-07","turnOn":true,"images":[{"name":"B3E681BC-712D-45E3-9709-72C812903F35.jpeg","productImage":"http:\/\/connectyourneed.in\/uploads\/product_images\/B3E681BC-712D-45E3-9709-72C812903F35.jpeg"},{"name":"859EC35F-64BB-49D1-BBE7-AC9161EFF77C.jpeg","productImage":"http:\/\/connectyourneed.in\/uploads\/product_images\/859EC35F-64BB-49D1-BBE7-AC9161EFF77C.jpeg"}]}}
