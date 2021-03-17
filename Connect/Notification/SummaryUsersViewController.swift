//
//  SummaryUsersViewController.swift
//  Connect
//
//  Created by Venkatesh Botla on 05/12/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import UIKit

import UIKit
import Lottie

class SummaryUsersViewController: UIViewController {

    @IBOutlet weak var summaryUsersTableView: UITableView!
    
    //Search
    @IBOutlet weak var vw_searchBackView: UIView!
    @IBOutlet weak var tf_searchTF: UITextField!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var btn_searchCancel: UIButton!
    
    //Lottie
    @IBOutlet weak var loadingBackView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lbl_message: UILabel!
    
    @IBOutlet weak var btn_payCharge: UIButton!
    
    let animationView = AnimationView()
    
    
    private let client = APIClient()
    var qrInfo: QrCodeData?
    var filterSummaryNotificationModel: [NotificationModel]?
    var charges: [Charges]?
    var totalConnAmmount: Int? = 0
    var connections = [String]()

    var isSearchEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tf_searchTF.delegate = self

        self.summaryUsersTableView.delegate = self
        self.summaryUsersTableView.dataSource = self
        self.summaryUsersTableView.tableFooterView = UIView(frame: .zero)
        
        self.getConnectCharges()
        self.updateDefaultUI()
    }
    
    private func getSummaryUsers() {
        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        self.summaryUsersTableView.reloadData()
        self.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIWhenViewWillAppear()
        
    }
    
    @IBAction func backToHomeAction(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
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
        self.filterSummaryNotificationModel = nil
        self.summaryUsersTableView.reloadData()
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
    
    @IBAction func processConnectedUsersAction(_ sender: UIButton) {
        guard let qrId = self.qrInfo?.qrId else {
            return
        }

        for connect in ConstHelper.selectedNotificationModel {
            let cons = "\(connect.connectedUserId ?? 0)"
            self.connections.append(cons)
        }

        let selConns = self.connections.joined(separator: ",")

        self.proceedSelectedConnectionsToPayment(qrId, connections: selConns, amount: self.totalConnAmmount ?? 0)
    }
    
    private func moveToTermsViewControler(_ url: String, title: String) {
        let storyboard = UIStoryboard(name: "Notification", bundle: nil)
        if let termsVC = storyboard.instantiateViewController(withIdentifier: "RazorPayViewController") as? RazorPayViewController {
            termsVC.loadUrl = url
            termsVC.headerTitle = title
            termsVC.modalPresentationStyle = .fullScreen
            self.present(termsVC, animated: true, completion: nil)
        }
        
    }
    
}

extension SummaryUsersViewController {
    private func updateDefaultUI() {
        self.tf_searchTF.addTarget(self, action: #selector(searchWhenTextIsChange(_:)), for: .editingChanged)
    
        self.tf_searchTF.font = ConstHelper.h4Normal
        self.tf_searchTF.textColor = ConstHelper.white
        self.tf_searchTF.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ConstHelper.white])
        
        self.lbl_message.font = ConstHelper.h6Normal
        self.lbl_message.textColor = ConstHelper.gray
        
        //Proceed connection button
        self.btn_payCharge.isHidden = true
        self.btn_payCharge.setTitle("PAY INR", for: .normal)
        self.btn_payCharge.backgroundColor = ConstHelper.orange
        self.btn_payCharge.setTitleColor(ConstHelper.white, for: .normal)
        self.btn_payCharge.titleLabel?.font = ConstHelper.h3Bold
        
        self.disableLoaderView()
    }
    
    private func updateUIWhenViewWillAppear() {
        self.vw_searchBackView.isHidden = true
        self.summaryUsersTableView.reloadData()
    }
    
    private func disableLoaderView() {
        self.loadingBackView.backgroundColor = ConstHelper.white        
    }
}


//MARK: - UITableViewDelegate
extension SummaryUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            if let summaryNotification = self.filterSummaryNotificationModel {
                return summaryNotification.count
            }
        } else {
            return ConstHelper.selectedNotificationModel.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let summaryCell = tableView.dequeueReusableCell(withIdentifier: ConstHelper.summaryCellIdentifier, for: indexPath) as! SummaryCell
        
        if isSearchEnable {
            if let summaryNotification = self.filterSummaryNotificationModel?[indexPath.row] {
                summaryCell.setSummaryCell(summaryNotification)
            }
        } else {
            let summaryNotification = ConstHelper.selectedNotificationModel[indexPath.row]
            summaryCell.setSummaryCell(summaryNotification)
        }
        
        summaryCell.btn_remove.tag = indexPath.row
        summaryCell.btn_remove.addTarget(self, action: #selector(summaryUserRemoveAction(_:)), for: .touchUpInside)
    
        return summaryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    @objc private func summaryUserRemoveAction(_ sender: UIButton) {
        var removeConnectedUserId: Int?
        
        if isSearchEnable {
            if let summaryNotification = self.filterSummaryNotificationModel {
                removeConnectedUserId = summaryNotification[sender.tag].connectedUserId
            }
        } else {
            removeConnectedUserId = ConstHelper.selectedNotificationModel[sender.tag].connectedUserId
        }
        
        if let connectedUserId = removeConnectedUserId {
            let selIndex = ConstHelper.selectedNotificationModel.firstIndex { $0.connectedUserId == connectedUserId }
            if let index = selIndex {
                ConstHelper.selectedNotificationModel.remove(at: index)
            }
            
        }
        
        if ConstHelper.selectedNotificationModel.count == 0 {
            self.btn_payCharge.isHidden = true
            self.btn_payCharge.setTitle("PAY INR 0.00", for: .normal)
        } else if ConstHelper.selectedNotificationModel.count < 5 {
            self.btn_payCharge.isHidden = false
            let price = ConstHelper.selectedNotificationModel.count * (self.charges?.first?.price ?? 0)
            self.btn_payCharge.setTitle("PAY INR \(price).00", for: .normal)
            self.totalConnAmmount = price//Double(price)
        } else if ConstHelper.selectedNotificationModel.count > 5 {
            self.btn_payCharge.isHidden = false
            let selCount = ConstHelper.selectedNotificationModel.count
            let totolPrice = selCount * (self.charges?.last?.price ?? 0)
            if let percentage = self.charges?.last?.percentage {
                let price = totolPrice % percentage
                self.btn_payCharge.setTitle("PAY INR \(price).00", for: .normal)
                self.totalConnAmmount = price//Double(price)
            }
        }
        
        self.filterSummaryNotificationModel = nil
        self.summaryUsersTableView.reloadData()
        
    }
}

//MARK: - API Call
extension SummaryUsersViewController {
    
    
}

extension SummaryUsersViewController: UITextFieldDelegate {
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
            self.filterSummaryNotificationModel = nil
            isSearchEnable = false
        }
        self.summaryUsersTableView.reloadData()
    }
    
    func filterSearchText(_ text: String) {
        self.filterSummaryNotificationModel = ConstHelper.selectedNotificationModel.filter {
            let name = $0.name ?? ""
            return name.lowercased().contains(text.lowercased())
        }
        
    }
}

extension SummaryUsersViewController {
    //Post to lock users
    private func getConnectCharges() {
        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .connectCharges

        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .get , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: nil, timeInterval: 120)

        self.setupAnimation(withAnimation: true, name: ConstHelper.loader_animation)
        client.get_connectCharges(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }
                 
                 if response.status {
                    strongSelf.charges = response.data
                    strongSelf.btn_payCharge.isHidden = false
                    if ConstHelper.selectedNotificationModel.count < 5 {
                        let price = ConstHelper.selectedNotificationModel.count * (strongSelf.charges?.first?.price ?? 0)
                        strongSelf.btn_payCharge.setTitle("PAY INR \(price).00", for: .normal)
                        strongSelf.totalConnAmmount = price//Double(price)
                    } else if ConstHelper.selectedNotificationModel.count > 5 {
                        strongSelf.btn_payCharge.isHidden = false
                        let selCount = ConstHelper.selectedNotificationModel.count
                        let totolPrice = selCount * (strongSelf.charges?.last?.price ?? 0)
                        if let percentage = strongSelf.charges?.last?.percentage {
                            let price = totolPrice % percentage
                            strongSelf.btn_payCharge.setTitle("PAY INR \(price).00", for: .normal)
                            strongSelf.totalConnAmmount = price//Double(price)
                        }
                        
                    }
                    
                    strongSelf.getSummaryUsers()
                    strongSelf.summaryUsersTableView.reloadData()
                 } else {
                    strongSelf.setupAnimation(withAnimation: true, name: ConstHelper.error_animation)
                 }
             case .failure(let error):
                 strongSelf.showAlertMini(title: AlertMessage.errTitle.rawValue, message: "\(error.localizedDescription)", actionTitle: "Ok")
             }
         }
    }
    
    private func proceedSelectedConnectionsToPayment(_ qrId: Int, connections: String, amount: Int) {
        let parameters = SendConnectedUsersReqModel(qrId: qrId, connectedUserId: connections, amount: amount)
        
        //Encode parameters
        guard let body = try? JSONEncoder().encode(parameters) else { return }

        //API
        ConstHelper.dynamicBaseUrl = DynamicBaseUrl.baseUrl.rawValue
        let api: Apifeed = .sendConnectedPersons
        
        let endpoint: Endpoint = api.getApiEndpoint(queryItems: [], httpMethod: .post , headers: [.contentType("application/json"), .authorization(ConstHelper.DYNAMIC_TOKEN)], body: body, timeInterval: 120)

        client.post_sendConnectedUsers(from: endpoint) { [weak self] result in
             guard let strongSelf = self else { return }
            strongSelf.setupAnimation(withAnimation: false, name: ConstHelper.loader_animation)
             switch result {
             case .success(let response):
                 guard let response = response else { return }

                 if response.status {
                    let paymentUrl = response.url ?? ""
                    strongSelf.moveToTermsViewControler(paymentUrl, title: "Payment")

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
