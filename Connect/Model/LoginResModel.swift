//
//  LoginResModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 09/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct LoginResModel: Codable {
    let status: Bool
    let verificationStatus: Bool?
    let message: String?
    let data: LoginInfo?
}

struct LoginInfo: Codable {
    let userId: Int
    let name: String
    let mobile: String
    let email: String?
    let jwToken: String
    let profileImage: String?
}

/*
{
    data =     {
        email = "<null>";
        jwToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjMsInRpbWUiOiIwLjg1NjcxNTAwIDE2MDA5MjA0MzIifQ.m3FWB7JOFpRoxcV0KFqXLCXvSh54BnJNvfd4EqO0RW8";
        mobile = "+919951451156";
        name = "Venkat Botla";
        profileImage = "https://connectyourneed.s3.ap-south-1.amazonaws.com/test/uploads/users/60c906bc577e9bcf00e004f471ab00bc1600434402";
        userId = 3;
    };
    message = "Login Success";
    status = 1;
    verificationStatus = 1;
}

 */
