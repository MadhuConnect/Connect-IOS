//
//  NotificationViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 21/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationViewController: UIViewController {

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
    
    private let client = APIClient()
    var qrInfo: QRInfoModel?
    var notificationModel: [NotificationModel]?
    var filterNotificationModel: [NotificationModel]?
    var isSearchEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tf_searchTF.delegate = self

        self.notificationTableView.delegate = self
        self.notificationTableView.dataSource = self
        self.notificationTableView.tableFooterView = UIView(frame: .zero)
        
        guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int else {
            return
        }
        
        self.getNotificationsList(withUserId: userId, qrId: (qrInfo?.qrId ?? 0), qrStatus: (qrInfo?.qrStatus ?? ""))
        self.updateDefaultUI()
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
        self.filterNotificationModel = nil
        self.notificationTableView.reloadData()
    }

}

extension NotificationViewController {
    private func updateDefaultUI() {
        self.tf_searchTF.addTarget(self, action: #selector(searchWhenTextIsChange(_:)), for: .editingChanged)
        self.vw_prodBackView.setBorderForView(width: 1, color: ConstHelper.lightGray, radius: 10)
        
        self.tf_searchTF.font = ConstHelper.h4Normal
        self.tf_searchTF.textColor = ConstHelper.white
        self.tf_searchTF.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.white])
        
    }
    
    private func updateUIWhenViewWillAppear() {
        self.vw_searchBackView.isHidden = true
        
        if let qrInfo = self.qrInfo {
            guard let productImageUrl = URL(string: qrInfo.productImage) else { return }
            self.downloadImage(url: productImageUrl)
            
            DispatchQueue.main.async {
                self.lbl_productName.text = qrInfo.productName
                if qrInfo.personType.lowercased() == "OFFEROR".lowercased() {
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
                notificationsCell.setNotificationsForQRCode(notification)
            }
        } else {
            if let notification = self.notificationModel?[indexPath.row] {
                notificationsCell.setNotificationsForQRCode(notification)
            }
        }
    
        return notificationsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
}

//MARK: - API Call
extension NotificationViewController {
    //Post and Get All Notifications Selected Product
    private func getNotificationsList(withUserId userId: Int, qrId: Int, qrStatus: String) {
        let parameters: NotificationReqModel = NotificationReqModel(userId: userId, qrId: qrId, status: qrStatus)
        print("Par: \(parameters)")

        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        let api: Apifeed = .notifications

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json")], body: body, timeInterval: 120)

        client.post_getOrderNotifications(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 
                 if response.status {
                    if let results = response.data {
                        strongSelf.notificationModel = results
                        DispatchQueue.main.async {
                            strongSelf.notificationTableView.reloadData()
                        }
                     }
                 } else {
                     strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: (response.message ?? ""), actionTitle: "Ok")
                     return
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
            self.filterNotificationModel = notificationModel.filter { $0.name.lowercased().contains(text.lowercased()) || $0.connectedLocation.lowercased().contains(text.lowercased()) || $0.mobile.lowercased().contains(text.lowercased())                
            }
        }
    }
}
