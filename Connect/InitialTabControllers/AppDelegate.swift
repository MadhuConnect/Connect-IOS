//
//  AppDelegate.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import OneSignal
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    private let client = APIClient()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Remove this method to stop OneSignal Debugging
//        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
        // OneSignal initialization
          OneSignal.initWithLaunchOptions(launchOptions)
          OneSignal.setAppId("d5074b2e-333f-4b49-9a63-7b0bf0d96d95")
        
        // promptForPushNotifications will show the native iOS notification permission prompt.
          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
          OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
          })
        
//
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//        } else {
//          let settings: UIUserNotificationSettings =
//          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }

        application.registerForRemoteNotifications()

        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        Switcher.updateRootViewController(setTabIndex: 0)
        
        let loginStatusKey = UserDefaults.standard.bool(forKey: "loginStatusKey")
        
        if loginStatusKey {
            self.checkLocationEnabledOrNot()
            self.checkUpdateAvaialableForApp()
        }
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let loginStatusKey = UserDefaults.standard.bool(forKey: "loginStatusKey")
        if loginStatusKey {
            self.checkUpdateAvaialableForApp()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) { }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.checkLocationEnabledOrNot()
    }
    
    func applicationWillTerminate(_ application: UIApplication) { }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Connect")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let _ = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
      }

      // Print full message.
//      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let _ = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
      }

      // Print full message.
//      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        var readableToken: String = ""
//        for i in 0..<deviceToken.count {
//          readableToken += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
//        }
//        print("Received an APNs device token: \(readableToken)")
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Oh no! Failed to register for remote notifications with error \(error)")
//    }
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let _ = userInfo[gcmMessageIDKey] {
//      print("Message ID: \(messageID)")
    }

    // Print full message.
//    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound, .badge]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let _ = userInfo[gcmMessageIDKey] {
//      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
//    print(userInfo)

    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
        ConstHelper.deviceToken = fcmToken
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

extension AppDelegate {
    private func checkUpdateAvaialableForApp() {
        let loginStatusKey = UserDefaults.standard.bool(forKey: "loginStatusKey")
        if loginStatusKey {
            guard let info = Bundle.main.infoDictionary,
                  let currentVersion = info["CFBundleShortVersionString"] as? String,
                  let identifier = info["CFBundleIdentifier"] as? String,
                  let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)&country=In") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data)
                    guard let json = jsonObject as? [String: Any] else {
                        print("The received that is not a Dictionary")
                        return
                    }
                    
                    let results = json["results"] as? [[String: Any]]
                    let firstResult = results?.first
                    if let appStoreVersion = firstResult?["version"] as? String {
                        if currentVersion != appStoreVersion {
                            if let demoMobile = UserDefaults.standard.value(forKey: "LoggedUserMobile") as? String {
                                if demoMobile != "+918008679638" {
//                                    #error("Please uncomment below code while uploading to AppStore")
                                    self.showUpdateAlert()
                                }
                                
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
        
    }
    
    private func showUpdateAlert() {
        let alert = UIAlertController(title: "New Version Available", message: "There is a newer version available for download! Please update the app by visiting the Apple Store.", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Update", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.moveToAppStore()
        })
        
        alert.addAction(actionYes)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func moveToAppStore() {
        if let url = URL(string: "https://apps.apple.com/in/app/connect-your-need/id1550984712"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func checkLocationEnabledOrNot() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("Location services are not enabled")
                self.asksEnableLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    
    private func asksEnableLocation() {
        let alert = UIAlertController(
            title: "Allow \"Connect Your Need\" to use your location?",
            message: "This app collects location data to connect between offeror and seeker even when the app is in background. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)

        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
}



