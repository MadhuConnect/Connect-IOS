//
//  ConstHelper.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

public class ConstHelper {
    //TEST BASE URL
    public static var testBaseURL = "http://test.connectyourneed.in"
    //PROD BASE URL
    public static var prodBaseURL = "http://connectyourneed.in"
    
    //Device model
    public static var iPhoneType = UIDevice.current.screenType.rawValue
    
    //Cell Identifiers
    public static var catecoryCellIdentifier = "CategoriesCell"
    public static var categoryCollectionIdentifier = "CategoryCollectionCell"
    public static var formCellIdentifier = "FormCell"
    public static var sliderCellIdentifier = "SlideCollectionViewCell"
    public static var qRCellIdentifier = "QRCell"
    public static var qrImageUploadCellIdentifier = "ImageUploadCell"
    public static var ordersCellIdentifier = "OrdersTableViewCell"
    public static var notificationCellIdentifier = "NotificationCell"
    public static var lockedUsersCellIdentifier = "LockedUsersCell"
    public static var blockedUsersCellIdentifier = "BlockedUsersCell"
    
    //UUID
    public static var deviceToken = UIDevice.current.identifierForVendor?.uuidString
    
    // Color
    public static var orange = UIColor(red: 230/255, green: 152/255, blue: 55/255, alpha: 1.0)
    public static var blue = UIColor(red: 68/255, green: 140/255, blue: 248/255, alpha: 1.0)
    public static var red = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    public static var lightGray = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
    public static var cyan = UIColor(red: 42/255, green: 50/255, blue: 77/255, alpha: 1.0)
    public static var white = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    public static var black = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    public static var gray = UIColor.gray
    
    //Font
    public static var h1Bold = UIFont(name: "Helvetica-Bold", size: 24.0)
    public static var titleBold = UIFont(name: "Helvetica-Bold", size: 22.0)
    public static var h2Bold = UIFont(name: "Helvetica-Bold", size: 20.0)
    public static var h3Bold = UIFont(name: "Helvetica-Bold", size: 18.0)
    public static var h4Bold = UIFont(name: "Helvetica-Bold", size: 16.0)
    public static var h5Bold = UIFont(name: "Helvetica-Bold", size: 14.0)
    public static var h6Bold = UIFont(name: "Helvetica-Bold", size: 12.0)
    
    public static var h1Normal = UIFont(name: "Helvetica", size: 24.0)
    public static var titleNormal = UIFont(name: "Helvetica", size: 22.0)
    public static var h2Normal = UIFont(name: "Helvetica", size: 20.0)
    public static var h3Normal = UIFont(name: "Helvetica", size: 18.0)
    public static var h4Normal = UIFont(name: "Helvetica", size: 16.0)
    public static var h5Normal = UIFont(name: "Helvetica", size: 14.0)
    public static var h6Normal = UIFont(name: "Helvetica", size: 12.0)
    
    public static var hTextColor = UIColor.black
    public static var hErrorColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    
    public static var disableColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
    public static var enableColor = UIColor.white
    
    //Lottie
    public static var construction_animation = "7146-under-construction"
    public static var loader_animation = "6615-loader-animation"
    public static var error_animation = "13865-sign-for-error-flat-style"
    
}


