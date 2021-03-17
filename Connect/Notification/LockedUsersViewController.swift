//
//  LockedUsersViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 22/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class LockedUsersViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var vw_prodBackView: UIView!
    @IBOutlet weak var vw_lineView: UIView!
    @IBOutlet weak var iv_prodImageView: UIImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_personType: UILabel!
    
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
    var qrInfo: QrCodeData?
    var notificationModel: [LockedUserModel]?
    var filterNotificationModel: [LockedUserModel]?
    var isSearchEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tf_searchTF.delegate = self

        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.tableFooterView = UIView(frame: .zero)
        
        self.getLockedUsers()
        self.updateDefaultUI()
    }
    
    private func getLockedUsers() {
        self.lbl_message.text = "Loading locked users..."
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.getNotificationsList((qrInfo?.qrId ?? 0), qrStatus: ("lock"))        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIWhenViewWillAppear()
        
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emergencyReqAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Emergency", bundle: nil)
        if let emergencyRequestVC = storyboard.instantiateViewController(withIdentifier: "EmergencyRequestViewController") as? EmergencyRequestViewController {
            emergencyRequestVC.modalPresentationStyle = .fullScreen
            emergencyRequestVC.isFromNotHome = true
            self.present(emergencyRequestVC, animated: true, completion: nil)
        }
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
        self.filterNotificationModel = nil
        self.notificationTableView.reloadData()
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

extension LockedUsersViewController {
    private func updateDefaultUI() {
        self.tf_searchTF.addTarget(self, action: #selector(searchWhenTextIsChange(_:)), for: .editingChanged)
        self.vw_prodBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        self.vw_lineView.backgroundColor = ConstHelper.cyan
        self.tf_searchTF.font = ConstHelper.h4Normal
        self.tf_searchTF.textColor = ConstHelper.white
        self.tf_searchTF.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.white])
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        self.lbl_productName.font = ConstHelper.h2Normal
        self.lbl_productName.textColor = ConstHelper.black
        
        self.lbl_personType.font = ConstHelper.h4Normal
        self.lbl_personType.textColor = ConstHelper.black
        
        self.disableLoaderView()
    }
    
    private func updateUIWhenViewWillAppear() {
        self.vw_searchBackView.isHidden = true
        
        if let qrInfo = self.qrInfo {
            guard let productImageUrl = URL(string: qrInfo.productImage ?? "") else { return }
            self.downloadImage(url: productImageUrl)
            
            DispatchQueue.main.async {
                self.lbl_productName.text = qrInfo.productName
                if (qrInfo.personType ?? "").lowercased() == "OFFEROR".lowercased() {
                    self.lbl_personType.text = "SEEKER"
                } else {
                    self.lbl_personType.text = "OFFEROR"
                }
            }

        }
    }
    
    private func disableLoaderView() {
        self.loadingBackView.backgroundColor = ConstHelper.white
    }
}


//MARK: - UITableViewDelegate
extension LockedUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            if let notifications = self.filterNotificationModel {
                return notifications.count
            }
        } else {
            if let notifications = self.notificationModel {
                return notifications.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lockedUsersCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.lockedUsersCellIdentifier, for: indexPath) as! LockedUsersCell
        
        if isSearchEnable {
            if let notification = self.filterNotificationModel?[indexPath.row] {
                lockedUsersCell.setLockedUsersCellForQRCode(notification)
            }
        } else {
            if let notification = self.notificationModel?[indexPath.row] {
                lockedUsersCell.setLockedUsersCellForQRCode(notification)
            }
        }
        
        lockedUsersCell.btn_lock.tag = indexPath.row
        lockedUsersCell.btn_lock.addTarget(self, action: #selector(unLockUserAction(_:)), for: .touchUpInside)
    
        lockedUsersCell.btn_call.tag = indexPath.row
        lockedUsersCell.btn_call.addTarget(self, action: #selector(makeCallAction(_:)), for: .touchUpInside)
        
        return lockedUsersCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    @objc private func unLockUserAction(_ sender: UIButton) {
        if let notification = self.notificationModel?[sender.tag] {
            guard let qrId = qrInfo?.qrId else { return }
            self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
            
            if let connectedUserId = notification.connectedUserId {
                self.unlockuser(qrId, connectedUserId: connectedUserId, qrStatus: "unlock")
            }
        }

    }
    
    @objc private func makeCallAction(_ sender: UIButton) {
        if let notification = self.notificationModel?[sender.tag] {
            if let mobile = notification.mobile {
                if mobile.count > 0 {
                    if let url = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    } else {
                            self.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Something went wrong", actionTitle: "Ok")
                            return
                    }
                } else {
                    self.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Something went wrong", actionTitle: "Ok")
                    return
                }

            }
        } else {
            self.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "Something went wrong", actionTitle: "Ok")
            return
        }
    }
}

//MARK: - API Call
extension LockedUsersViewController {
    //Post and Get All Notifications Selected Product
    private func getNotificationsList(_ qrId: Int, qrStatus: String) {
        let parameters: NotificationReqModel = NotificationReqModel(qrId: qrId, status: qrStatus)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .notifications

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_getLockedUsers(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 strongSelf.notificationModel = nil
                 strongSelf.lbl_message.text = ""
                 if response.status {
                    if let results = response.data {
                        strongSelf.notificationModel = results
                        DispatchQueue.main.async {
                            strongSelf.notificationTableView.reloadData()
                        }
                     }
                 } else {
                    strongSelf.lbl_message.text = "No locked users"
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
                    DispatchQueue.main.async {
                        strongSelf.notificationTableView.reloadData()
                    }
                 }
             case .failure(let error):
                 strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
             }
         }
    }
    
    func downloadImage(url: URL) {
        let processor = DownsamplingImageProcessor(size: iv_prodImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 10)
        self.iv_prodImageView.kf.indicatorType = .activity
        iv_prodImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noimage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    //Post to unlock user
    private func unlockuser(_ qrId: Int, connectedUserId: Int, qrStatus: String) {
        let parameters: LockUnLockReqModel = LockUnLockReqModel(qrId: qrId, connectedUserId: connectedUserId, status: qrStatus)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .lockUsers

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_lockUnLockUserNotifications(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 
                 if response.status {
                    strongSelf.getLockedUsers()
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

extension LockedUsersViewController: UITextFieldDelegate {
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
            self.filterNotificationModel = nil
            isSearchEnable = false
        }
        self.notificationTableView.reloadData()
    }
    
    func filterSearchText(_ text: String) {
        if let notificationModel = self.notificationModel {
            self.filterNotificationModel = notificationModel.filter { ($0.name ?? "").lowercased().contains(text.lowercased()) || ($0.connectedLocation ?? "").lowercased().contains(text.lowercased()) || ($0.mobile ?? "").lowercased().contains(text.lowercased())
            }
        }
    }
}
