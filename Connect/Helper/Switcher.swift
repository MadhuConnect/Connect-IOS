//
//  Switcher.swift
//  Connect
//
//  Created by Venkatesh Botla on 06/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

class Switcher {
    static func updateRootViewController() {
        let status = UserDefaults.standard.bool(forKey: "loginStatusKey")
        var rootVC: UIViewController?
        
        print("Login status: \(status)")
        
        if status {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                rootVC = vc
            }
            
        } else {
            if let vc = UIStoryboard(name: "Authenticate", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                rootVC = vc
            }

        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
}
