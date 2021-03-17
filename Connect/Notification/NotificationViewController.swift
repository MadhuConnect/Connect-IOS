//
//  NotificationViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 21/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class NotificationViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var tv_notificationBottomContraint: NSLayoutConstraint!
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
    
    @IBOutlet weak var btn_proceedConnection: UIButton!
    
    let animationView = AnimationView()
    
    private let client = APIClient()
    var qrInfo: QrCodeData?
    var notificationModel: [NotificationModel]?
    var filterNotificationModel: [NotificationModel]?
    var isSearchEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tf_searchTF.delegate = self

        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.tableFooterView = UIView(frame: .zero)
        
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ConstHelper.selectedNotificationModel.removeAll()
        self.getNotificationList()
        self.updateUIWhenViewWillAppear()
        
    }
    
    private func getNotificationList() {
        self.lbl_message.text = "Loading notifications..."
        self.setupAnimation(withAnimation: true, name: ConstHelper.lottie_notification)
        self.getNotificationsList(withQrId: (qrInfo?.qrId ?? 0), qrStatus: (qrInfo?.qrStatus ?? ""))
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func proceedConnectionAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Notification", bundle: nil)
        if let summaryVC = storyboard.instantiateViewController(withIdentifier: "SummaryUsersViewController") as? SummaryUsersViewController {
            summaryVC.qrInfo = qrInfo
            self.navigationController?.pushViewController(summaryVC, animated: true)
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
    
    private func disableLoaderView() {
        self.loadingBackView.backgroundColor = ConstHelper.white
    }

}

extension NotificationViewController {
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
                
        //Proceed connection button
        self.btn_proceedConnection.isHidden = true
        self.btn_proceedConnection.setTitle("PROCEED", for: .normal)
        self.btn_proceedConnection.backgroundColor = ConstHelper.orange
        self.btn_proceedConnection.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_proceedConnection.titleLabel?.font = ConstHelper.h3Bold
        
        self.tv_notificationBottomContraint.constant = 0
        self.disableLoaderView()
    }
    
    private func updateUIWhenViewWillAppear() {
        self.vw_searchBackView.isHidden = true
        self.btn_proceedConnection.isHidden = true
        
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
}


//MARK: - UITableViewDelegate
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
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
        let notificationsCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.notificationCellIdentifier, for: indexPath) as! NotificationCell
        
        if isSearchEnable {
            if let notification = self.filterNotificationModel?[indexPath.row] {
                let isSelected = ConstHelper.selectedNotificationModel.contains { ($0.connectedUserId ?? 0) == (notification.connectedUserId ?? 0) }
                                
                notificationsCell.setNotificationsForQRCode(notification, isAddedCart: isSelected)
            }
        } else {
            if let notification = self.notificationModel?[indexPath.row] {
                
                let isSelected = ConstHelper.selectedNotificationModel.contains { ($0.connectedUserId ?? 0) == (notification.connectedUserId ?? 0) }
                
                notificationsCell.setNotificationsForQRCode(notification, isAddedCart: isSelected)
            }
        }
        
        notificationsCell.btn_lock.tag = indexPath.row
        notificationsCell.btn_lock.addTarget(self, action: #selector(lockUserAction(_:)), for: .touchUpInside)
        
        notificationsCell.btn_block.tag = indexPath.row
        notificationsCell.btn_block.addTarget(self, action: #selector(blockUserAction(_:)), for: .touchUpInside)
    
        notificationsCell.btn_addCart.tag = indexPath.row
        notificationsCell.btn_addCart.addTarget(self, action: #selector(addCartAction(_:)), for: .touchUpInside)
        
        notificationsCell.btn_call.tag = indexPath.row
        notificationsCell.btn_call.addTarget(self, action: #selector(makeCallAction(_:)), for: .touchUpInside)
        
        return notificationsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    @objc private func lockUserAction(_ sender: UIButton) {
        if let notification = self.notificationModel?[sender.tag] {
            guard let qrId = qrInfo?.qrId else { return }
            self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
            if let connectedUserId = notification.connectedUserId {
                self.unlockuser(qrId, connectedUserId: connectedUserId, qrStatus: "lock")
            }
        }
    }
    
    @objc private func blockUserAction(_ sender: UIButton) {
        if let notification = self.notificationModel?[sender.tag] {
            self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
            if let connectedUserId = notification.connectedUserId {
                self.blockUser(connectedUserId, qrStatus: "block")
            }
        }
    }
    
    @objc private func addCartAction(_ sender: UIButton) {
        if let notification = self.notificationModel?[sender.tag] {
            let isSelected =  ConstHelper.selectedNotificationModel.contains { ($0.connectedUserId) == (notification.connectedUserId ?? 0) }
            if !isSelected {
                ConstHelper.selectedNotificationModel.append(notification)
            }
        }
        
        self.tv_notificationBottomContraint.constant = 66
        self.btn_proceedConnection.isHidden = false
        self.notificationTableView.reloadData()
    }
    
    @objc private func makeCallAction(_ sender: UIButton) {
        if isSearchEnable {
            if let notification = self.filterNotificationModel?[sender.tag] {
                self.dialNumber(notification.mobile ?? "")
            }
        } else {
            if let notification = self.notificationModel?[sender.tag] {
                self.dialNumber(notification.mobile ?? "")
            }
        }
        
    }
    
    private func dialNumber(_ mobile: String) {
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
    
}

//MARK: - API Call
extension NotificationViewController {
    //Post and Get All Notifications Selected Product
    private func getNotificationsList(withQrId qrId: Int, qrStatus: String) {
        let parameters: NotificationReqModel = NotificationReqModel(qrId: qrId, status: qrStatus)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .notifications

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_getOrderNotifications(from: endpoint) { [weak self] result in
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
                    strongSelf.lbl_message.text = "No new notifications"
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.lottie_nodata)
                    strongSelf.notificationModel = nil
                    DispatchQueue.main.async {
                        strongSelf.notificationTableView.reloadData()
                    }
                 }
             case .failure(let error):
                strongSelf.notificationModel = nil
                DispatchQueue.main.async {
                    strongSelf.notificationTableView.reloadData()
                }
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
    
    //Post to lock users
    private func unlockuser(_ qrId: Int, connectedUserId: Int, qrStatus: String) {
        let parameters: LockUnLockReqModel = LockUnLockReqModel(qrId: qrId, connectedUserId: connectedUserId, status: qrStatus)

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        let api: Apifeed = .lockUsers

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_lockUnLockUserNotifications(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 
                 if response.status {
                    strongSelf.getNotificationList()
                 } else {
                    strongSelf.lbl_message.text = response.message ?? ""
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.error_animation)
                 }
             case .failure(let error):
                 strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
             }
         }
    }
    
    //Post to block user
    private func blockUser(_ connectedUserId: Int, qrStatus: String) {
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
                    strongSelf.getNotificationList()
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

extension NotificationViewController: UITextFieldDelegate {
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
