//
//  BlockedUsersViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 23/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class BlockedUsersViewController: UIViewController {

    @IBOutlet weak var blockedUsersTableView: UITableView!
    
    //Search
    @IBOutlet weak var vw_searchBackView: UIView!
    @IBOutlet weak var tf_searchTF: UITextField!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var btn_searchCancel: UIButton!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    let animationView = AnimationView()
    
    private let client = APIClient()
    
    var blockedUsers: [BlockedUsers]?
    var filterBlockedUsers: [BlockedUsers]?
    var isSearchEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tf_searchTF.delegate = self

        self.blockedUsersTableView.delegate = self
        self.blockedUsersTableView.dataSource = self
        self.blockedUsersTableView.tableFooterView = UIView(frame: .zero)
        
        self.getBlockedUsers()
        self.updateDefaultUI()
    }
    
    private func getBlockedUsers() {
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.getBlockedUsersList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIWhenViewWillAppear()
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchEnableAction(_ sender: UIButton) {
        self.tf_searchTF.text = ""
        self.tf_searchTF.becomeFirstResponder()
        self.vw_searchBackView.isHidden = false
    }
    
    @IBAction func searchCancelAction(_ sender: UIButton) {
        self.tf_searchTF.text = ""
        self.tf_searchTF.resignFirstResponder()
        self.vw_searchBackView.isHidden = true
        isSearchEnable = false
        self.filterBlockedUsers = nil
        self.blockedUsersTableView.reloadData()
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            emergencyRequestVC.isFromNotHome = true
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
    }

    private func setupAnimation(withAnimation status: Bool, name: String) {
        animationView.animation = Animation.named(name)
        animationView.frame = loadingView.bounds
        animationView.backgroundColor = ConstHelper.white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        if status {
            animationView.play()
            loadingView.addSubview(animationView)
            loadingBackView.isHidden = false
        }
        else {
            animationView.stop()
            loadingBackView.isHidden = true
        }

    }
    
}

extension BlockedUsersViewController {
    private func updateDefaultUI() {
        self.tf_searchTF.addTarget(self, action: #selector(searchWhenTextIsChange(_:)), for: .editingChanged)
    
        self.tf_searchTF.font = ConstHelper.h4Normal
        self.tf_searchTF.textColor = ConstHelper.white
        self.tf_searchTF.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.white])
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        self.disableLoaderView()
    }
    
    private func updateUIWhenViewWillAppear() {
        self.vw_searchBackView.isHidden = true
        self.blockedUsersTableView.reloadData()
    }
    
    private func disableLoaderView() {
        self.loadingBackView.backgroundColor = ConstHelper.white        
    }
}


//MARK: - UITableViewDelegate
extension BlockedUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            if let blockedUsers = self.filterBlockedUsers {
                return blockedUsers.count
            }
        } else {
            if let blockedUsers = self.blockedUsers {
                return blockedUsers.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blockedUsersCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.blockedUsersCellIdentifier, for: indexPath) as! BlockedUsersCell
        
        if isSearchEnable {
            if let blockedUsers = self.filterBlockedUsers?[indexPath.row] {
                blockedUsersCell.setBlockedUsersCellForQRCode(blockedUsers)
            }
        } else {
            if let blockedUsers = self.blockedUsers?[indexPath.row] {
                blockedUsersCell.setBlockedUsersCellForQRCode(blockedUsers)
            }
        }
        
        blockedUsersCell.btn_block.tag = indexPath.row
        blockedUsersCell.btn_block.addTarget(self, action: #selector(unBlockUserAction(_:)), for: .touchUpInside)
    
        return blockedUsersCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    @objc private func unBlockUserAction(_ sender: UIButton) {
        if isSearchEnable {
            if let blockedUser = self.filterBlockedUsers?[sender.tag] {
                self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
                self.unBlockuser(blockedUser.blockedUserId, qrStatus: "unblock")
            }
        } else {
            if let blockedUser = self.blockedUsers?[sender.tag] {
                self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
                self.unBlockuser(blockedUser.blockedUserId, qrStatus: "unblock")
            }
        }
    }
}

//MARK: - API Call
extension BlockedUsersViewController {
    //Post and Get All Notifications Selected Product
    private func getBlockedUsersList() {
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .blockUsersList

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)

        client.post_blockedUsersList(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 strongSelf.blockedUsers = nil
                 strongSelf.lbl_message.text = ""
                 if response.status {
                    if let results = response.data {
                        strongSelf.blockedUsers = results
                        DispatchQueue.main.async {
                            strongSelf.blockedUsersTableView.reloadData()
                        }
                     }
                 } else {
                    strongSelf.lbl_message.text = "No blocked users"
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
                    DispatchQueue.main.async {
                        strongSelf.blockedUsersTableView.reloadData()
                    }
                 }
             case .failure(let error):
                 strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
             }
         }
    }
    
    //Post to unblock user
    private func unBlockuser(_ connectedUserId: Int, qrStatus: String) {
        let parameters: BlockUserReqModel = BlockUserReqModel(connectedUserId: connectedUserId, status: qrStatus)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .blockUsers

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_blockUnBlockUserNotifications(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 
                 if response.status {
                    strongSelf.getBlockedUsers()
                 } else {
                    strongSelf.lbl_message.text = response.message ?? ""
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.error_animation)
                 }
             case .failure(let error):
                 strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
             }
         }
    }
}

extension BlockedUsersViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tf_searchTF {
            self.tf_searchTF.text = ""
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.tf_searchTF {
            self.tf_searchTF.resignFirstResponder()
        }
    }
    
    @objc func searchWhenTextIsChange(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            self.filterSearchText(searchText)
            isSearchEnable = true
        } else {
            self.filterBlockedUsers = nil
            isSearchEnable = false
        }
        self.blockedUsersTableView.reloadData()
    }
    
    func filterSearchText(_ text: String) {
        if let blockedUsers = self.blockedUsers {
            self.filterBlockedUsers = blockedUsers.filter { $0.name.lowercased().contains(text.lowercased()) || $0.mobile.lowercased().contains(text.lowercased())
            }
        }
    }
}
