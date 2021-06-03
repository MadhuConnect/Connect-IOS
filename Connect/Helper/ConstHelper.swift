//
//  ConstHelper.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
/*
UserDefaults.standard.set(user.verificationStatus, forKey: "UserVerificationStatus")
UserDefaults.standard.set(user.data?.userId, forKey: "LoggedUserId")
UserDefaults.standard.set(user.data?.name, forKey: "LoggedUserName")
UserDefaults.standard.set(user.data?.mobile, forKey: "LoggedUserMobile")
UserDefaults.standard.set(user.data?.email, forKey: "LoggedUserEmail")
UserDefaults.standard.set(user.data?.jwToken, forKey: "LoggedUserJWTToken")
UserDefaults.standard.set(user.data?.profileImage, forKey: "LoggedUserProfileImage")
UserDefaults.standard.set(true, forKey: "loginStatusKey")
*/

public class ConstHelper {
    //TOKEN
    public static var DYNAMIC_TOKEN = UserDefaults.standard.value(forKey: "LoggedUserJWTToken") as? String ?? ""
    
    //TEST BASE URL
    public static var testBaseURL = "http://test.connectyourneed.in"
//    public static var testBaseURL = "https://api.connectyourneed.in/"
    
    public static var dynamicBaseUrl = ""  
    
    //PROD BASE URL
    public static var prodBaseURL = "http://connectyourneed.in"
    
    
    //Terms and Conditins, PrivacyPolicy & Desclaimer
    public static var termsAndConditions = ConstHelper.testBaseURL + "/TermsAndConditions"
    public static var privacyPolicy = ConstHelper.testBaseURL + "/PrivacyPolicy"
    public static var desclaimer = ConstHelper.testBaseURL + "/Desclaimer"
    public static var tutorial = ConstHelper.testBaseURL + "/Tutorial"
    
    //Device model
    public static var iPhoneType = UIDevice.current.screenType.rawValue
    
    //Cell Identifiers
    public static var catecoryCellIdentifier = "CategoriesCell"
    public static var subscriptionCollectionIdentifier = "SubscriptionCell"
    public static var galleryCollectionIdentifier = "GalleryCell"    
    public static var categoryCollectionIdentifier = "CategoryCollectionCell"
    public static var formCellIdentifier = "FormCell"
    public static var sliderCellIdentifier = "SlideCollectionViewCell"
    public static var qRCellIdentifier = "QRCell"
    public static var qrImageUploadCellIdentifier = "ImageUploadCell"
    public static var ordersCellIdentifier = "OrdersTableViewCell"
    public static var emergencyOrdersTableViewCell = "EmergencyOrdersTableViewCell"
    public static var emergencyInterestTableViewCell = "EmergencyInterestTableViewCell"    
    public static var notificationCellIdentifier = "NotificationCell"
    public static var lockedUsersCellIdentifier = "LockedUsersCell"
    public static var paidUsersCellIdentifier = "PaidUsersCell"    
    public static var blockedUsersCellIdentifier = "BlockedUsersCell"
    public static var summaryCellIdentifier = "SummaryCell"    
    public static var settingsTableViewCellIdentifier = "SettingsTableViewCell"
    public static var emergencyTypesCollectionViewCell = "EmergencyTypesCollectionViewCell"
    public static var bloodGroupsCollectionViewCell = "BloodGroupsCollectionViewCell"
    public static var emergencyNearByTableViewCell = "EmergencyNearByTableViewCell"
    public static var choosePlanCellTableViewCell = "ChoosePlanCell"
    public static var adPremiumListCellTableViewCell = "AdPremiumListCell"
    
    // Color
    public static var orange = UIColor(red: 218/255, green: 95/255, blue: 57/255, alpha: 1.0)
    public static var blue = UIColor(red: 68/255, green: 140/255, blue: 248/255, alpha: 1.0)
    public static var red = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    public static var darkRed = UIColor(red: 126/255, green: 24/255, blue: 15/255, alpha: 1.0)
    public static var lightGray = UIColor(red: 226/255, green: 226/255, blue: 224/255, alpha: 1.0)
    public static var lightWhiteGray = UIColor(red: 226/255, green: 226/255, blue: 224/255, alpha: 1.0)
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
    public static var h7Bold = UIFont(name: "Helvetica-Bold", size: 10.0)
    
    public static var h1Normal = UIFont(name: "Helvetica", size: 24.0)
    public static var titleNormal = UIFont(name: "Helvetica", size: 22.0)
    public static var h2Normal = UIFont(name: "Helvetica", size: 20.0)
    public static var h3Normal = UIFont(name: "Helvetica", size: 18.0)
    public static var h4Normal = UIFont(name: "Helvetica", size: 16.0)
    public static var h5Normal = UIFont(name: "Helvetica", size: 14.0)
    public static var h6Normal = UIFont(name: "Helvetica", size: 12.0)
    public static var h7Normal = UIFont(name: "Helvetica", size: 10.0)
    
    public static var hTextColor = UIColor.black
    public static var hErrorColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    
    public static var disableColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0)
    public static var enableColor = UIColor.white
    public static var lineColor = UIColor(red: 198/255, green: 223/255, blue: 218/255, alpha: 1.0)
    
    //Lottie
    public static var lottie_heartbeat = "heartbeat"
    public static var lottie_bloodBag = "blood-bag-loading"
    public static var lottie_plasma = "plasma"
    public static var lottie_block = "block"
    public static var lottie_blood = "blood"
    public static var lottie_comingsoon = "comingsoon"
    public static var lottie_delete = "delete"
    public static var lottie_emerequest = "emerequest"
    public static var lottie_emergencyreq = "emergencyreq"
    public static var lottie_generate = "generate"
    public static var lottie_health = "health"
    public static var lottie_loader = "loader"
    public static var lottie_locked = "locked"
    public static var lottie_lockuser = "lockuser"
    public static var lottie_nearbyeme = "nearbyeme"
    public static var lottie_lockOutline = "21483-lock-outline-icon"
    public static var lottie_nodata = "nodata"
    public static var lottie_notification = "notification"
    
    
    public static var construction_animation = "7146-under-construction"
    public static var loader_animation = "6615-loader-animation"
    public static var error_animation = "13865-sign-for-error-flat-style"
    public static var dot_animation = "29577-dot-loader-5"
    public static var empty_animation = "8428-loader"
    public static var heartbeat_animation = "28648-healthcare-business-neon-heartbeat-love-animation"
    public static var heartbeat_medical = "4565-heartbeat-medical"
    
    public static var vb_circle_loading_animation = "28129-circle-loading-animation"
    
    public static var productCategory = ""
    public static var contactSuccessMsg: String = ""
    
    static var selectedNotificationModel = [NotificationModel]()
    
    public static var supportMessage = "Support hours are from 10 AM to 6 PM"
    public static var callToSupport = "+917013367849"
    
    //FCM TOKEN
    public static var deviceToken: String? = ""//UIDevice.current.identifierForVendor?.uuidString
    
    public static var myLatitude: Double? = 0
    public static var myLogitude: Double? = 0
    public static var myLocationName: String? = ""
}
