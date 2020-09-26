//
//  OTPResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct OTPResModel: Codable {
    let status: Bool
    let verificationStatus: Bool?
    let message: String?
    let data: LoginInfo?
}

struct OTPInfo: Codable {
    let userId: Int
    let name: String
    let mobile: String
    let email: String?
    let jwToken: String
    let profileImage: String?
}

//{"status":true,"message":"Login Success","data":{"userId":1,"name":"Gana","mobile":"+919502244622"}}

/*
{
    data =     {
        email = "<null>";
        jwToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsInRpbWUiOiIwLjY2ODY1MzAwIDE2MDEwNTYxMDAifQ.Btt61J_oAJUfG5fyVzwnTbiIEqMdR3T95UgcegtupgQ";
        mobile = "+919951451156";
        name = "Venkatesh Botla";
        profileImage = "<null>";
        userId = 1;
    };
    message = "Login Success";
    status = 1;
    verificationStatus = 1;
}
*/
