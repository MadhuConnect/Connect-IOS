//
//  ContactUsResFormModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 29/09/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation


struct ContactUsResFormModel: Codable {
    let status: Bool
    let message: String?
    let requestData: FormResponseModel?
}

struct FormResponseModel: Codable {
    let requestId: Int?
    let userId: Int?
    let category: String?
    let product: String?
    let description: String?
    let requestDate: String?
    let requestTime: String?
    let requestStatus: String?
    let images: [FormImagesModell]?
}

struct FormImagesModell: Codable {
    let name: String?
    let productImage: String?
}


/*
 
 ======= Enquiry
 {
     message = " Thank you for contacting us. We will be get back to you with in 24 hours.";
     requestData =     {
         description = "Testing\n";
         requestDate = "2020-11-29";
         requestId = 2;
         requestStatus = New;
         requestTime = "10:10:37 AM";
         userId = 4;
     };
     status = 1;
 }
 ======= Feedback
 {
     message = " Thanks for your feedback. Please keep sending your feedback to us for improvement.";
     requestData =     {
         description = "Testing feedback\n";
         requestDate = "2020-11-29";
         requestId = 3;
         requestStatus = New;
         requestTime = "10:20:34 AM";
         userId = 4;
     };
     status = 1;
 }
 
 ======= Request
 {
     message = " Thank you for contacting us. We will be get back to you with in 24 hours.";
     requestData =     {
         category = "test category ";
         description = "Test request ";
         images =         (
         );
         product = "test title ";
         requestDate = "2020-11-29";
         requestId = 2;
         requestStatus = New;
         requestTime = "10:23:27 AM";
         userId = 4;
     };
     status = 1;
 }
 
 */


/*
{
 "status":true,
 "message":" Thank you for contacting us. We will be get back to you with in 24 hours.",
 "requestData":
    {
        "requestId":1,
        "userId":1,
        "category":"Mobiles",
        "product":"apple",
        "description":"Apple Need",
        "requestDate":"2020-09-15",
        "requestTime":"10:01:21 AM",
        "requestStatus":"Active",
        "images":[
            {
                "name":"67bde149659ed83e541877917c37be0f1600085407",
                "productImage":"https:\/\/connectyourneed.s3.ap-south-1.amazonaws.com\/dev\/uploads\/business\/67bde149659ed83e541877917c37be0f1600085407"
            }
            ,{
                "name":"67bde149659ed83e541877917c37be0f1600085407",
                "productImage":"https:\/\/connectyourneed.s3.ap-south-1.amazonaws.com\/dev\/uploads\/business\/67bde149659ed83e541877917c37be0f1600085407"
            }
        ]
    }
}
*/
