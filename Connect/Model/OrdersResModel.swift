//
//  OrdersResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 13/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct OrdersResModel: Codable {
    let status: Bool
    let message: String?
    let qrCodeData: [QrCodeData]?
    let emergenctData: [EmergenctData]?
}

struct QrCodeData: Codable {
    let qrId: Int?
    let qrCode: String?
    let personType: String?
    let productName: String?
    let productImage: String?
    let productType: String?
    let title: String?
    let description: String?
    let minAmount: Int?
    let maxAmount: Int?
    let privacyStatus: String?
    let connectRange: String?
    let activeCount: Int?
    let lockCount: Int?
    let paidCount: Int?
    let chatCount: Int?
    let qrStatus: String?
    let qrGeneratedDate: String?
    let turnOn: Bool?
    let paidConnections: [PaidConnection]?
    let images: [QRCodeImageModel]?
}

struct QRCodeImageModel: Codable {
    let imageId: Int?
    let productImage: String?
}

struct EmergenctData: Codable {
    let postInterestsCount: Int?
    let emergencyRequestId: Int?
    let name: String?
    let mobile: String?
    let emergency: String?
    let type: String?
    let message: String?
    let requestGeneratedDate: String?
    let requestGeneratedTime: String?
    let interests: [Interests]?
}

struct Interests: Codable {
    let userId: Int
    let name: String
    let mobile: String
    let userLocation: String
    let distance: Double
}

struct PaidConnection: Codable {
    let connectedUserId: Int?
    let name: String?
    let mobile: String?
    let kyc: Int?
    let personType: String?
    let product: String?
    let title: String?
    let description: String?
    let minAmount: String?
    let maxAmount: String?
    let connectedLocation: String?
    let distance: Double?
    let date: String?
    let time: String?
    let paymentStatus: Int?
    let paymentId: String?
}

/*
 "paidConnections": [
     {
         "connectedUserId": 8,
         "name": "Aadhya Botla",
         "mobile": "+919951451156",
         "kyc": 0,
         "personType": "SEEKER",
         "product": "Chilli",
         "title": "Chilli",
         "description": "test seeker",
         "minAmount": "0",
         "maxAmount": "1000",
         "connectedLocation": "Fertilizer Corporation of India Srinagar Colony Godavarikhani",
         "distance": 0.0083629322493481,
         "date": "2020-12-02",
         "time": "07:23 PM",
         "paymentStatus": 1,
         "paymentId": null
     }
 ]
*/


/*
 
 {
     emergenctData =     (
     );
     qrCodeData =     (
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "10 Km";
             description = " Fjaldfal;f adlfkald fal;Gia;ldfjk";
             images =             (
             );
             lockCount = 0;
             maxAmount = 1000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = OFFEROR;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/mini_categories/1-mobiles-aandk.png";
             productName = "A&K";
             productType = New;
             qrCode = "NTE5QE5ld0BAUXJjb2RlLWNvbm5lY3Q=";
             qrGeneratedDate = "2020-11-24";
             qrId = 10;
             qrStatus = Active;
             title = "test title";
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "25 Km";
             description = "Gaga add af do df";
             images =             (
             );
             lockCount = 0;
             maxAmount = 1000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = OFFEROR;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/50-mobiles-samsung.png";
             productName = Samsung;
             productType = New;
             qrCode = "ODhATmV3QEBRcmNvZGUtY29ubmVjdA==";
             qrGeneratedDate = "2020-11-24";
             qrId = 9;
             qrStatus = Active;
             title = "dfdfdfdf ";
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "15 Km";
             description = "Jgjh high gj";
             images =             (
             );
             lockCount = 0;
             maxAmount = 1000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = SEEKER;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/44-mobiles-oppo.png";
             productName = Oppo;
             productType = Used;
             qrCode = "ODdAVXNlZEBAUXJjb2RlLWNvbm5lY3Q=";
             qrGeneratedDate = "2020-11-24";
             qrId = 8;
             qrStatus = Active;
             title = Oppo;
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "15 Km";
             description = "Jhkjjj Kuhn";
             images =             (
             );
             lockCount = 0;
             maxAmount = 100;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = OFFEROR;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/44-mobiles-oppo.png";
             productName = Oppo;
             productType = New;
             qrCode = "ODdATmV3QEBRcmNvZGUtY29ubmVjdA==";
             qrGeneratedDate = "2020-11-24";
             qrId = 7;
             qrStatus = Active;
             title = vivo;
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "25 Km";
             description = Fede;
             images =             (
             );
             lockCount = 0;
             maxAmount = 1000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = OFFEROR;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/60-mobiles-vivo.png";
             productName = Vivo;
             productType = New;
             qrCode = "ODZATmV3QEBRcmNvZGUtY29ubmVjdA==";
             qrGeneratedDate = "2020-11-24";
             qrId = 6;
             qrStatus = Active;
             title = Title;
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "25 Km";
             description = "Sell 2 iPhones";
             images =             (
             );
             lockCount = 0;
             maxAmount = 1000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = OFFEROR;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/3-mobiles-apple.png";
             productName = Apple;
             productType = New;
             qrCode = "ODVATmV3QEBRcmNvZGUtY29ubmVjdA==";
             qrGeneratedDate = "2020-11-24";
             qrId = 5;
             qrStatus = Active;
             title = Title;
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "25 Km";
             description = "Needed iPhone ";
             images =             (
             );
             lockCount = 0;
             maxAmount = 10000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = SEEKER;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/3-mobiles-apple.png";
             productName = Apple;
             productType = Used;
             qrCode = "ODVAVXNlZEBAUXJjb2RlLWNvbm5lY3Q=";
             qrGeneratedDate = "2020-11-23";
             qrId = 4;
             qrStatus = Active;
             title = Title;
             turnOn = 1;
         },
                 {
             activeCount = 0;
             chatCount = 0;
             connectRange = "10 Km";
             description = "Needed 2 iPhones";
             images =             (
                                 {
                     imageId = 27;
                     productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/product_images/9920f75a534d5688eb9c0391929f11551606155135";
                 },
                                 {
                     imageId = 28;
                     productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/product_images/dad454d78585fd1d7b6454866ce3b79a1606155135";
                 }
             );
             lockCount = 0;
             maxAmount = 10000;
             minAmount = 0;
             paidConnections =             (
             );
             paidCount = 0;
             personType = OFEEROR;
             privacyStatus = Any;
             productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/products/14-Electronics-Printers.png";
             productName = Printers;
             productType = USED;
             qrCode = "MTdAVVNFREBAUXJjb2RlLWNvbm5lY3Q=";
             qrGeneratedDate = "2020-11-23";
             qrId = 3;
             qrStatus = Active;
             title = iPhone;
             turnOn = 1;
         }
     );
     status = 1;
 }
 
 */
