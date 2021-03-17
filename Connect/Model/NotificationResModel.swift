//
//  NotificationResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 22/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct NotificationResModel: Codable {
    let status: Bool
    let message: String?
    let data: [NotificationModel]?
}

struct NotificationModel: Codable {
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
    let images: [PaidConnectionImage]?
}

struct PaidConnectionImage: Codable {
    let productImage: String?
}

struct NotificationStatusResModel: Codable {
    let status: Bool
    let message: String?
    let turnOn: Bool
}
/*

 {
     data =     (
                 {
             connectedLocation = Visakhapatnam;
             connectedQrId = 41;
             connectedUserId = 12;
             date = "2021-02-13";
             description = test;
             distance = "0.0039475279572179";
             images =             (
             );
             kyc = 0;
             maxAmount = 0;
             minAmount = 0;
             mobile = "+919014728712";
             name = KRISHNA;
             paymentId = "pay_GV26ifrkDTuCbW";
             paymentStatus = 1;
             personType = OFFEROR;
             product = Hostel;
             time = "07:34 AM";
             title = hostel;
         },
                 {
             connectedLocation = Visakhapatnam;
             connectedQrId = 28;
             connectedUserId = 5;
             date = "2021-02-09";
             description = "test\n";
             distance = "0.006538140968494";
             images =             (
             );
             kyc = 1;
             maxAmount = 0;
             minAmount = 0;
             mobile = "+917013367849";
             name = "Veerla Ravi Shankar";
             paymentId = "pay_GUcpOWwjYwq5yw";
             paymentStatus = 1;
             personType = OFFEROR;
             product = Hostel;
             time = "12:21 PM";
             title = hostel;
         },
                 {
             connectedLocation = Visakhapatnam;
             connectedQrId = 46;
             connectedUserId = 13;
             date = "2021-01-30";
             description = "test\n";
             distance = "0.0051036001226286";
             images =             (
             );
             kyc = 1;
             maxAmount = 0;
             minAmount = 0;
             mobile = "+917013305160";
             name = Eetish;
             paymentId = "pay_GVTFZPdxxn2KZO";
             paymentStatus = 1;
             personType = OFFEROR;
             product = Hostel;
             time = "09:32 AM";
             title = hostel;
         },
                 {
             connectedLocation = Maddilapalem;
             connectedQrId = 26;
             connectedUserId = 2;
             date = "2021-01-28";
             description = "Hostel des gana";
             distance = "0.026688640790184";
             images =             (
                                 {
                     productImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/product_images/2afc1db7d6418dfa93c3b35089e11d9a1611812467";
                 }
             );
             kyc = 1;
             maxAmount = 3000;
             minAmount = 0;
             mobile = "+919502244622";
             name = "Ganesh Nd";
             paymentId = "<null>";
             paymentStatus = 1;
             personType = OFFEROR;
             product = Hostel;
             time = "05:42 AM";
             title = "Hostel title gana";
         }
     );
     status = 1;
 }
 
 */
