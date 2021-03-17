//
//  SettingsViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 27/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

struct Settings {
    let image: UIImage?
    let name: String
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tv_settingsTableView: UITableView!
    
    let settings = [
        Settings(image: UIImage(named: "cyn_privacypolicy"), name: "Privacy policy"),
        Settings(image: UIImage(named: "cyn_termsconditions"), name: "Terms and conditions"),
        Settings(image: UIImage(named: "cyn_disclamer"), name: "Disclaimer"),
        Settings(image: UIImage(named: "cyn_blockedUsers"), name: "Blocked users"),
        Settings(image: UIImage(named: "cyn_tutorial"), name: "Tutorial"),
        Settings(image: UIImage(named: "cyn_contactUs"), name: "Contact us")
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        self.tv_settingsTableView.delegate = self
        self.tv_settingsTableView.dataSource = self
        self.tv_settingsTableView.tableFooterView = UIView(frame: .zero)
        self.tv_settingsTableView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tv_settingsTableView.reloadData()
        
        if ConstHelper.contactSuccessMsg.count != 0 {
            self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: ConstHelper.contactSuccessMsg, actionTitle: "Ok")
            ConstHelper.contactSuccessMsg = ""
        }
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            emergencyRequestVC.isFromNotHome = true
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.settingsTableViewCellIdentifier, for: indexPath) as! SettingsTableViewCell
        
        let setting = self.settings[indexPath.row]
        settingsCell.setSettingsCell(setting.image, name: setting.name)
        
        return settingsCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.moveToTermsViewControler(ConstHelper.privacyPolicy, title: "Privacy policy")
        case 1:
            self.moveToTermsViewControler(ConstHelper.termsAndConditions, title: "Terms of service")
        case 2:
            self.moveToTermsViewControler(ConstHelper.desclaimer, title: "Disclaimer")
        case 3:
            self.moveToBlockedUsersViewControler()
        case 4:
            self.moveToTermsViewControler(ConstHelper.tutorial, title: "Tutorial")
        case 5:
            self.moveToContactUsViewControler("Contact Us")
        default:
            break
        }
    }
    
    private func moveToTermsViewControler(_ url: String, title: String) {
        let storyboard = UIStoryboard(name: "Terms", bundle: nil)
        if let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController {
            termsVC.loadUrl = url
            termsVC.headerTitle = title
            termsVC.modalPresentationStyle = .fullScreen
            self.present(termsVC, animated: true, completion: nil)
        }
        
    }
    
    private func moveToContactUsViewControler(_ title: String) {
        let storyboard = UIStoryboard(name: "Terms", bundle: nil)
        if let contactUsVC = storyboard.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController {
            contactUsVC.headerTitle = title            
            contactUsVC.modalPresentationStyle = .fullScreen
            self.present(contactUsVC, animated: true, completion: nil)
        }
        
    }
    
    private func moveToBlockedUsersViewControler() {
        let storyboard = UIStoryboard(name: "Notification", bundle: nil)
        if let blockedUsersVC = storyboard.instantiateViewController(withIdentifier: "BlockedUsersViewController") as? BlockedUsersViewController {
            blockedUsersVC.modalPresentationStyle = .fullScreen
            self.present(blockedUsersVC, animated: true, completion: nil)
        }
        
    }
}
