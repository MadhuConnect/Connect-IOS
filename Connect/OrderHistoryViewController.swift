//
//  OrderHistoryViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit
import Lottie

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    //Search
    @IBOutlet weak var vw_searchBackView: UIView!
    @IBOutlet weak var tf_searchTF: UITextField!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var btn_searchCancel: UIButton!

    let animationView = AnimationView()
    
    private let client = APIClient()
    var qrInfoModel: [QRInfoModel]?
    var filterQrInfoModel: [QRInfoModel]?
    var isSearchEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.tf_searchTF.delegate = self
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        self.orderTableView.tableFooterView = UIView(frame: .zero)
        self.updateDefaultUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUIWhenViewWillAppear()
    }
    
    private func setupAnimation(withAnimation status: Bool) {
        animationView.animation = Animation.named("6615-loader-animation")
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
        self.filterQrInfoModel = nil
        self.orderTableView.reloadData()
    }

}

extension OrderHistoryViewController {
    private func updateDefaultUI() {
        self.tf_searchTF.addTarget(self, action: #selector(searchWhenTextIsChange(_:)), for: .editingChanged)
        
        self.tf_searchTF.font = ConstHelper.h4Normal
        self.tf_searchTF.textColor = ConstHelper.white
        self.tf_searchTF.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.white])
        
    }
    
    private func updateUIWhenViewWillAppear() {
        self.vw_searchBackView.isHidden = true
        
        guard let userId = UserDefaults.standard.value(forKey: "LoggedUserId") as? Int else {
             return
         }
         self.setupAnimation(withAnimation: true)
         self.getMyOrders(userId)
    }
}


//MARK: - UITableViewDelegate
extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            if let qrInfoModel = self.filterQrInfoModel {
                return qrInfoModel.count
            }
        } else {
            if let qrInfoModel = self.qrInfoModel {
                return qrInfoModel.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ordersCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.ordersCellIdentifier, for: indexPath) as! OrdersTableViewCell
        
        if isSearchEnable {
            if let qrInfo = self.filterQrInfoModel?[indexPath.row] {
                ordersCell.setQRInformation(qrInfo)
            }
        } else {
            if let qrInfo = self.qrInfoModel?[indexPath.row] {
                ordersCell.setQRInformation(qrInfo)
            }
        }
        
        //Button actions
        ordersCell.btn_qrInfo.tag = indexPath.row
        ordersCell.btn_qrInfo.addTarget(self, action: #selector(qrInfoAction(_:)), for: .touchUpInside)
        
        ordersCell.btn_bell.tag = indexPath.row
        ordersCell.btn_bell.addTarget(self, action: #selector(notifyBellAction(_:)), for: .touchUpInside)
        
        ordersCell.btn_lock.tag = indexPath.row
        ordersCell.btn_lock.addTarget(self, action: #selector(lockUserAction(_:)), for: .touchUpInside)
        
        return ordersCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    @objc private func qrInfoAction(_ sender: UIButton) {
        if let qrInfo = self.qrInfoModel?[sender.tag] {
            let storyboard = UIStoryboard(name: "Form", bundle: nil)
            if let qrVC = storyboard.instantiateViewController(withIdentifier: "QRViewController") as? QRViewController {
                qrVC.modalPresentationStyle = .fullScreen
                qrVC.qrInfo = qrInfo                
                self.present(qrVC, animated: true, completion: nil)
             }
        }

    }
    
    @objc private func notifyBellAction(_ sender: UIButton) {
        if let qrInfo = self.qrInfoModel?[sender.tag] {
            if qrInfo.qrStatus.lowercased() == "Active".lowercased() {
                let storyboard = UIStoryboard(name: "Notification", bundle: nil)
                if let notificationVC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                    notificationVC.modalPresentationStyle = .fullScreen
                    notificationVC.qrInfo = qrInfo
                    self.present(notificationVC, animated: true, completion: nil)
                 }
            } else {
                self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
                return
            }
        }

    }
    
    @objc private func lockUserAction(_ sender: UIButton) {
        if let qrInfo = self.qrInfoModel?[sender.tag] {
            if qrInfo.qrStatus.lowercased() == "Active".lowercased() {
                let storyboard = UIStoryboard(name: "Notification", bundle: nil)
                if let lockedUsersVC = storyboard.instantiateViewController(withIdentifier: "LockedUsersViewController") as? LockedUsersViewController {
                    lockedUsersVC.modalPresentationStyle = .fullScreen
                    lockedUsersVC.qrInfo = qrInfo
                    self.present(lockedUsersVC, animated: true, completion: nil)
                 }
            } else {
                self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
                return
            }
        }

    }
    
    @objc private func blockUserAction(_ sender: UIButton) {
        if let qrInfo = self.qrInfoModel?[sender.tag] {
            if qrInfo.qrStatus.lowercased() == "Active".lowercased() {
                let storyboard = UIStoryboard(name: "Notification", bundle: nil)
                if let blockedUsersVC = storyboard.instantiateViewController(withIdentifier: "BlockedUsersViewController") as? BlockedUsersViewController {
                    blockedUsersVC.modalPresentationStyle = .fullScreen
                    self.present(blockedUsersVC, animated: true, completion: nil)
                 }
            } else {
                self.showAlertMini(title: AlertMessage.appTitle.rawValue, message: "No Data Found", actionTitle: "Ok")
                return
            }
        }

    }
}


//MARK: - API Call
extension OrderHistoryViewController {
    private func getMyOrders(_ userId: Int) {
        let parameters = ["userId": userId]
        
        print("Par: \(parameters)")
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }
        
        //API
        let api: Apifeed = .myOrders
        
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.staticToken)], body: body, timeInterval: 120)
        
        client.post_getMyOrders(from: endpoint) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false)
            switch result {
            case .success(let response):
                guard let response = response else { return }
                
                if response.status {
                    if let qrInfo = response.data {
                        strongSelf.qrInfoModel = qrInfo
                        DispatchQueue.main.async {
                            strongSelf.orderTableView.reloadData()
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
    
    
}

//MARK: - UITextFieldDelegate
extension OrderHistoryViewController: UITextFieldDelegate {
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
            self.filterQrInfoModel = nil
            isSearchEnable = false
        }
        self.orderTableView.reloadData()
    }
    
    func filterSearchText(_ text: String) {
        if let qrInfoModel = self.qrInfoModel {
            self.filterQrInfoModel = qrInfoModel.filter { $0.personType.lowercased().contains(text.lowercased())}
        }
    }
}
